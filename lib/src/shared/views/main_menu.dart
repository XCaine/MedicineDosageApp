import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/medical_data_fetch/medical_data_fetch_button.dart';
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
          const DrawerHeader(
            decoration: BoxDecoration(
                color: Colors.blue,
                gradient: LinearGradient(colors: [Colors.grey, Colors.blue])),
            child: Text(''),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Menu'),
            onTap: () {
              context.go(Constants.homeScreenRoute);
              Navigator.pop(context);
            },
          ),
          ListTile(
              leading: const Icon(Icons.medical_services_outlined),
              title: const Text('Lista leków'),
              onTap: () {
                context.go(Constants.drugsScreenRoute);
                Navigator.pop(context);
              }),
          ListTile(
              leading: const Icon(Icons.calculate_outlined),
              title: const Text('Kalkulator BMI'),
              onTap: () {
                context.go(Constants.bmiCalculatorScreenRoute);
                Navigator.pop(context);
              }),
          const MedicalDataFetchButton(),
        ],
      ),
    );
  }
}
