import 'package:drugs_dosage_app/src/features/root/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/constants.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(image: AssetImage('resources/images/menu-background.jpg'), fit: BoxFit.cover)),
            child: FractionallySizedBox(
                alignment: Alignment.topLeft,
                widthFactor: 0.5,
                heightFactor: 0.4,
                child: Container(
                  color: Colors.lightBlue.withOpacity(0.7),
                  child: ListTile(
                    leading: const Icon(Icons.home_outlined),
                    title: const Text('Menu'),
                    onTap: () {
                      context.go(Constants.homeScreenRoute);
                      Navigator.pop(context);
                    },
                  ),
                )),
          ),
          ListTile(
              leading: const Icon(Icons.medical_services_outlined),
              title: const Text('Baza leków'),
              onTap: () {
                context.go(Constants.drugsScreenRoute);
                Navigator.pop(context);
              }),
          ListTile(
              leading: const Icon(Icons.medical_information_outlined),
              title: const Text('Kalkulator dawek'),
              onTap: () {
                context.go(Constants.drugDosageCalculatorScreenRoute);
                Navigator.pop(context);
              }),
          ListTile(
              leading: const Icon(Icons.calculate_outlined),
              title: const Text('Kalkulator BMI'),
              onTap: () {
                context.go(Constants.bmiCalculatorScreenRoute);
                Navigator.pop(context);
              }),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Ustawienia'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Settings()),
              );
            },
          ),
        ],
      ),
    );
  }
}
