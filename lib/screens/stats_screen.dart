import 'package:cash_app/cashDepositScreen.dart';
import 'package:cash_app/data.dart';
import 'package:cash_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';

bool isDeleting = false;

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final box = Hive.box<Deposit>(depositBoxName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            isDeleting && box.isNotEmpty ? Colors.red : personIconColor,
        onPressed: () {
          if (isDeleting) {
            deleteSelectedDeposits();
            setState(() {
              isDeleting = false;
            });
          } else {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const Cashdepositscreen()));
          }
        },
        child: isDeleting && box.isNotEmpty
            ? const Icon(
                CupertinoIcons.delete_solid,
                color: Colors.white,
              )
            : const Icon(
                Icons.add_rounded,
                color: Colors.white,
              ),
      ),
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        actions: [
          IconButton(
            onPressed: () {
              if (box.isNotEmpty) {
                setState(() {
                  isDeleting = !isDeleting;
                });
              }
            },
            icon: Icon(CupertinoIcons.delete_solid,
                color:
                    isDeleting && box.isNotEmpty ? Colors.red : Colors.white),
          )
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, value, child) {
                if (box.isNotEmpty) {
                  return ListView.builder(
                    itemCount: box.values.length + 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return SvgPicture.asset(
                          'assets/images/Top up credit-bro.svg',
                          height: 300,
                          width: 300,
                        );
                      } else if (index == 1) {
                        return const Row(
                          children: [
                            Text(
                              'Your Deposits',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
                            ),
                            Spacer()
                          ],
                        );
                      } else {
                        final Deposit deposit = box.values.toList()[index - 2];
                        return DepositCard(deposit: deposit);
                      }
                    },
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/Wallet 03.svg',
                        width: 200,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        'You have no deposits',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  );
                }
              },
            ),
          )),
    );
  }
}

class DepositCard extends StatefulWidget {
  const DepositCard({
    super.key,
    required this.deposit,
  });

  final Deposit deposit;

  @override
  State<DepositCard> createState() => _DepositCardState();
}

class _DepositCardState extends State<DepositCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: isDeleting
          ? () {
              setState(() {
                widget.deposit.isSelectedToDelete =
                    !widget.deposit.isSelectedToDelete;
              });
            }
          : null,
      child: Container(
        margin: const EdgeInsets.only(top: 8, left: 4, right: 4),
        height: 75,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: cardColor),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: isDeleting
              ? Row(
                  children: [
                    MyCheckBox(
                      value: widget.deposit.isSelectedToDelete,
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    Expanded(child: NormalDepositCard(deposit: widget.deposit))
                  ],
                )
              : NormalDepositCard(deposit: widget.deposit),
        ),
      ),
    );
  }
}

class MyCheckBox extends StatelessWidget {
  const MyCheckBox({
    super.key,
    required this.value,
  });

  final bool value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
          border: !value ? Border.all(color: Colors.grey, width: 2) : null,
          borderRadius: BorderRadius.circular(12),
          color: value ? Colors.red : null),
      child: value
          ? const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 18,
            )
          : null,
    );
  }
}

class NormalDepositCard extends StatelessWidget {
  const NormalDepositCard({
    super.key,
    required this.deposit,
  });

  final Deposit deposit;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              deposit.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              deposit.category,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            )
          ],
        ),
        Text(
          "${deposit.count.toStringAsFixed(0)}\$",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.green[600],
              fontSize: 22,
              fontWeight: FontWeight.w600),
        )
      ],
    );
  }
}

Future<void> deleteSelectedDeposits() async {
  final box = Hive.box<Deposit>(depositBoxName);

  // Collect all keys of items to delete
  final keysToDelete = box.keys.where((key) {
    final deposit = box.get(key);
    return deposit?.isSelectedToDelete == true;
  }).toList();

  // Delete the selected items
  await box.deleteAll(keysToDelete);

  print('Deleted ${keysToDelete.length} selected deposits.');
}
