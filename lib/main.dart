import 'package:cash_app/cashDepositScreen.dart';
import 'package:cash_app/data.dart';
import 'package:cash_app/maps_screen.dart';
import 'package:cash_app/stats_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import './colors.dart';
import 'package:flutter/cupertino.dart';
import "package:hive_flutter/hive_flutter.dart";

const depositBoxName = 'deposits';
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DepositAdapter());
  await Hive.openBox<Deposit>(depositBoxName);
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    final double screenWidth = MediaQuery.of(context).size.width;
    final box = Hive.box<Deposit>(depositBoxName);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "NotoSans",
      ),
      home: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.notifications_rounded,
                color: Colors.white,
              ),
            )
          ],
          leading: const Padding(
            padding: EdgeInsets.only(left: 15),
            child: CircleAvatar(
              maxRadius: 20,
              foregroundImage: NetworkImage(
                  "https://mdbcdn.b-cdn.net/img/Photos/new-templates/bootstrap-profiles/avatar-1.webp"),
              backgroundColor: backgroundColor,
            ),
          ),
        ),
        body: ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, value, child) {
              final totalCount =
                  box.values.fold(0.0, (sum, deposit) => sum + deposit.count);
              return BottomBar(
                barColor: Colors.transparent,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: likeContainerColor),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.home_filled,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.newspaper_rounded,
                          size: 35,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.history,
                          size: 35,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.apps_rounded,
                          size: 35,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                body: (context, controller) => Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 75),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Row(
                          children: [
                            Text(
                              "Browse",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer()
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        StatisticsCard(
                          screenWidth: screenWidth,
                          totalCount: totalCount,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SmallCard(
                                screenWidth: screenWidth,
                                imagePath: "assets/images/card2.png",
                                title: "Cash \ndeposit",
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const Cashdepositscreen(),
                                  ));
                                },
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              SmallCard(
                                screenWidth: screenWidth,
                                imagePath: "assets/images/atm.png",
                                title: "Find an \nATM",
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const MapsScreen(),
                                  ));
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Row(
                          children: [
                            Text(
                              "OTHER FEATURES",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                            Spacer()
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: screenWidth,
                            height: 160,
                            decoration: BoxDecoration(
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black,
                                  )
                                ],
                                color: cardColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InviteFriendCard(
                                    isgift: true,
                                    title: "Invite friends",
                                    description: "up to 200\$ in cash",
                                    leadingContainerColor: iconContainerColor,
                                    leadingIcon: Icon(
                                      Icons.person_add_alt_1_rounded,
                                      color: personIconColor,
                                    ),
                                    secondIcon: Icon(
                                      Icons.wallet_giftcard_rounded,
                                      color: personIconColor,
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                    height: 20,
                                  ),
                                  InviteFriendCard(
                                    title: "Vote for new features",
                                    description: "and propose new ideas",
                                    leadingContainerColor: likeContainerColor,
                                    leadingIcon: Icon(
                                      CupertinoIcons.hand_thumbsup_fill,
                                      color: likeIconColor,
                                    ),
                                    secondIcon: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: likeIconColor,
                                    ),
                                    isgift: false,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class InviteFriendCard extends StatelessWidget {
  final Icon leadingIcon;
  final Color leadingContainerColor;
  final String title;
  final String description;
  final Icon secondIcon;
  final bool isgift;

  const InviteFriendCard(
      {super.key,
      required this.leadingIcon,
      required this.description,
      required this.title,
      required this.secondIcon,
      required this.leadingContainerColor,
      required this.isgift});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: leadingContainerColor),
            child: leadingIcon),
        const SizedBox(
          width: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              description,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
        const Spacer(),
        isgift
            ? Container(
                height: 40,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: iconContainerColor),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.wallet_giftcard_rounded,
                      color: personIconColor,
                    ),
                    Text(
                      '20\$',
                      style: TextStyle(
                          color: personIconColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ))
            : secondIcon
      ],
    );
  }
}

class SmallCard extends StatelessWidget {
  const SmallCard(
      {super.key,
      required this.screenWidth,
      required this.onTap,
      required this.imagePath,
      required this.title});

  final double screenWidth;
  final String imagePath;
  final String title;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 200,
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(
              color: Colors.black,
            )
          ], color: cardColor, borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Image.asset(imagePath)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StatisticsCard extends StatelessWidget {
  const StatisticsCard({
    super.key,
    required this.screenWidth,
    required this.totalCount,
  });

  final double screenWidth;
  final double totalCount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const StatsScreen(),
      )),
      child: Container(
          height: 160,
          width: screenWidth - 50,
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(
              color: Colors.black,
            )
          ], color: cardColor, borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Statistics',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const Spacer(),
                      Text(
                        "${totalCount.toStringAsFixed(0)}\$",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Total deposits',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      )
                    ],
                  ),
                ),
                const Spacer(),
                Image.asset("assets/images/Card1.png")
              ],
            ),
          )),
    );
  }
}
