// home_screen.dart
import 'package:flutter/material.dart';
import 'contacts.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Referral App')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ContactsScreen()),
            );
          },
          child: Text('Refer'),
        ),
      ),
    );
  }
}
