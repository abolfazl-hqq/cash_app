import 'package:cash_app/colors.dart';
import 'package:cash_app/data.dart';
import 'package:cash_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';

String? _selectedItem = 'Category';

class Cashdepositscreen extends StatefulWidget {
  const Cashdepositscreen({super.key});

  @override
  State<Cashdepositscreen> createState() => _CashdepositscreenState();
}

final List<String> _items = [
  'Category',
  'Savings',
  'Food',
  'Digital Currency',
  'Charity',
  'Others'
];

class _CashdepositscreenState extends State<Cashdepositscreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _countController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: personIconColor,
        onPressed: () {
          final deposit = Deposit();
          deposit.name = _nameController.text.toString();
          deposit.count = double.parse(_countController.text);
          deposit.category = _selectedItem.toString();
          deposit.isSelectedToDelete = false;
          if (deposit.isInBox) {
            deposit.save();
          } else {
            final Box<Deposit> box = Hive.box(depositBoxName);
            box.add(deposit);
          }
          Navigator.of(context).pop();
        },
        child: const Icon(
          Icons.check_rounded,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: backgroundColor,
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
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/Top up credit-pana.svg',
                height: 300,
                width: 300,
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                children: [
                  Text(
                    'Deposit your money',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  Spacer()
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'what are you saving for?', // Placeholder text
                    filled: true,
                    fillColor: cardColor,
                    hintStyle: const TextStyle(color: Colors.white54),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0), // Inner padding
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(24.0), // Rounded corners
                      borderSide: BorderSide.none, // No border
                    ),
                  ),
                  style: const TextStyle(color: Colors.white), // Text color
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _countController,
                  decoration: InputDecoration(
                    hintText: 'How much are you saving?',
                    filled: true,
                    fillColor: cardColor,
                    hintStyle: const TextStyle(color: Colors.white54),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonFormField<String>(
                  hint: const Text('Categories',
                      style: TextStyle(color: Colors.white)),
                  dropdownColor: cardColor,
                  value: _selectedItem,
                  items: _items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedItem = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true, // Background color
                    fillColor: cardColor, // Black background
                    hintText: 'Select Category',
                    hintStyle: const TextStyle(color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(24.0), // Rounded corners
                      borderSide: BorderSide.none, // No border outline
                    ),
                  ),
                  style: const TextStyle(color: Colors.white), // Text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
