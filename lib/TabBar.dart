import 'package:flutter/material.dart';

import 'package:get_contacts/screens/events_list.dart';
import 'package:get_contacts/screens/profile.dart';
import 'package:get_contacts/screens/shopping.dart';

class TabScreen extends StatefulWidget {
  @override
  State<TabScreen> createState() {
    return _TabScreenState();
  }
}

class _TabScreenState extends State<TabScreen> {
  int _currentIndex = 0;

  void _selectedpage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = EventScreenList();

    if (_currentIndex == 1) {
      activePage = shoppingPage();
    } else if (_currentIndex == 2) {
      activePage = ProfilePage();
    }

    return Scaffold(
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.lightBlue,
        selectedItemColor:
            Colors.black, // Set the selected icon color to yellow
        unselectedItemColor:
            Colors.white, // Set the unselected icon color to blue
        showSelectedLabels: true, // Show labels for selected items
        showUnselectedLabels: true, // Show labels for unselected items
        onTap: _selectedpage,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
