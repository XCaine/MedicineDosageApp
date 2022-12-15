import 'package:flutter/material.dart';

class NoDrugsInDatabase extends StatelessWidget {
  const NoDrugsInDatabase({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
          child: SizedBox(
            width: 320,
            child: Card(
              color: Colors.white,
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'W bazie danych nie ma żadnych leków',
                      style: TextStyle(fontSize: 40),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
  }

}