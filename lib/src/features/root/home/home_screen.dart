import 'package:drugs_dosage_app/src/shared/views/root_layout.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget homeScreen = const Center(
    child: Text('Home screen'),
  );

  @override
  Widget build(BuildContext context) {
    return RootLayout(child: homeScreen);
  }
}
