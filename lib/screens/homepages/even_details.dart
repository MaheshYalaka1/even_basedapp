import 'package:flutter/material.dart';
import 'package:EventBasedapp/screens/homepages/dropdown.dart'; // Import for the custom dropdown widget

class EventDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> event;

  const EventDetailsScreen({Key? key, required this.event}) : super(key: key);

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool isMenuOpen = false; // Variable to track whether the menu is open or not

  // Method to toggle the menu state
  void toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''), // Empty title for the app bar
      ),
      endDrawer: AppDrawer(), // Drawer widget for the end side
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Padding for the body content
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.event.containsKey('imagePath'))
              // Display event image if available
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
            const SizedBox(height: 16.0), // SizedBox for spacing
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
            SizedBox(height: 8.0), // SizedBox for spacing
            Text(
              '${widget.event['Place'] ?? 'Not specified'}',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0), // SizedBox for spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  // Button for option 1
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
                  // Button for option 2
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
                  // Button for option 3
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
