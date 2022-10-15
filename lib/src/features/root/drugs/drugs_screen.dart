import 'package:flutter/material.dart';

import '../../../shared/views/root_layout.dart';


class DrugsList extends StatefulWidget {
  const DrugsList({Key? key}) : super(key: key);

  @override
  State<DrugsList> createState() => _DrugsListState();
}

class _DrugsListState extends State<DrugsList> {
  Widget homeScreen = const Center(
    child: Text('Drugs Screen'),
  );

  @override
  Widget build(BuildContext context) {
    return RootLayout(child: homeScreen);
  }
}
