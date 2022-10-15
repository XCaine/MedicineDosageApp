import 'package:flutter/material.dart';

import 'main_menu.dart';

class RootLayout extends StatelessWidget {
  const RootLayout({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
/*        actions: [
          IconButton(
              onPressed: () => context.go(Constants.homeScreenRoute),
              icon: const Icon(Icons.home)
          )
        ],*/
      ),
      body: child,
      drawer: const MainMenu(),
    );
  }
}
