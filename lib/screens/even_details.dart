import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_contacts/screens/events_list.dart';

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

  void navigateToPage(BuildContext context, String itemName) {
    if (itemName == 'Sign out') {
      FirebaseAuth.instance.signOut();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
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
            icon: Icon(
              Icons.menu,
              size: 30.0,
              color: Colors.black,
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
