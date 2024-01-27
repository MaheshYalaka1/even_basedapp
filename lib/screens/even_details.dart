import 'package:flutter/material.dart';
import 'package:get_contacts/screens/events_list.dart';
import 'package:get_contacts/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> event;

  const EventDetailsScreen({Key? key, required this.event}) : super(key: key);

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool isMenuOpen = false;

  void toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  Future<void> navigateToPage(BuildContext context, String itemName) async {
    if (itemName == 'Sign out') {
      // Perform sign-out and navigate to the login page
      await signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else if (itemName == 'Home Page') {
      // Navigate to another page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EventScreenList()),
      );
    } else {
      print('Selected: $itemName');
    }
  }

  Future<void> signOut() async {
    // Clear the login status in shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '',
          style: TextStyle(color: Color.fromARGB(167, 253, 252, 252)),
        ),
        backgroundColor: Color.fromARGB(
            255, 27, 27, 28), // Set your desired background color
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              navigateToPage(context, value);
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: 'Sign out',
                  child: Text('Sign out'),
                ),
                const PopupMenuItem(
                  value: 'Home Page',
                  child: Text('Home Page'),
                ),
                const PopupMenuItem(
                  value: 'details',
                  child: Text('details'),
                ),
              ];
            },
            icon: const Icon(
              Icons.menu,
              size: 30.0,
              color: Color.fromARGB(220, 250, 247, 247),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.event.containsKey('imagePath'))
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.event['imagePath']),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${widget.event['category']}-${widget.event['date'] ?? 'Not specified'}',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              '${widget.event['Place'] ?? 'Not specified'}',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle button press
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 243, 228, 228),
                      side: BorderSide(color: Colors.black),
                    ),
                    child: Text(
                      'No 50',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle button press
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      side: BorderSide(color: Colors.black),
                    ),
                    child:
                        Text('Yes 25', style: TextStyle(color: Colors.black)),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle button press
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(104, 54, 114, 244),
                      side: BorderSide(color: Colors.black),
                    ),
                    child: Text(
                      'NoResponse 50',
                      style: TextStyle(fontSize: 10, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
