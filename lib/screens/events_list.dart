import 'package:flutter/material.dart';
import 'package:get_contacts/even_createpage.dart';
import 'package:get_contacts/screens/even_details.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class EventScreenList extends StatefulWidget {
  const EventScreenList({Key? key}) : super(key: key);

  @override
  _EventScreenListState createState() => _EventScreenListState();
}

class _EventScreenListState extends State<EventScreenList> {
  List<Map<String, dynamic>> events = [
    {
      'category': 'My Events',
    },
    {
      'category': 'Maria Birthday',
      'date': '12 may 2024',
      'Place': 'Guntur',
      'time': '3:00 PM',
      'enteredText': 'Happy Birthday maria',
      'imagePath': 'assets/splash4.jpg',
      'customHeight': 200.0, // Custom height for Meeting event
    },
    {
      'category': 'Natalia Graduation',
      'date': '12 july 2024',
      'Place': 'chennai',
      'time': '12:00 PM',
      'enteredText': 'congrats Natalia',
      'imagePath': 'assets/splash2.jpg',
      'customHeight': 200.0, // Custom height for Birthday event
    },
    {
      'category': 'Past Events',
    },
    {
      'category': 'Appointment',
      'date': '17/12/2023',
      'Place': 'Hyderabad',
      'time': '2:30 PM',
      'enteredText': 'Meet with client.',
      'imagePath': 'assets/splash3.jpg',
      'customHeight': 70.0,
    },
    {
      'category': 'tripe araku',
      'date': '28/12/2023',
      'Place': 'vijayawada',
      'time': '10:30 AM',
      'enteredText': 'Discuss project updates.',
      'imagePath': 'assets/splash2.jpg',
      'customHeight': 70.0,
    },
    {
      'category': 'marrage',
      'date': '15/11/2023',
      'Place': 'KPHP colony',
      'time': '10:30 AM',
      'enteredText': 'Discuss project updates.',
      'imagePath': 'assets/splash1.jpg',
      'customHeight': 70.0,
    }
  ];
  bool isMenuOpen = false;

  void toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  Future<void> navigateToPage(BuildContext context, String itemName) async {
    if (itemName == 'Sign out') {
      // await FirebaseAuth.instance.signOut();
      // // After signing out, you may want to navigate to a login or home page.
      // Navigator.pushReplacementNamed(
      //     context, '/LoginPage'); // Replace with your route
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
        title: const Text(
          '',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(
          255,
          248,
          249,
          250,
        ), // Set your desired background color
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
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Welcome jane',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: [
                        const Text(
                          'Create an event',
                          style: TextStyle(
                            color: Color.fromARGB(255, 58, 58, 58),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6.0),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromARGB(
                                0, 243, 173, 33), // Circular background color
                            border: Border.all(
                              color: const Color.fromARGB(
                                255,
                                58,
                                58,
                                58,
                              ), // Border color
                              width: 3.0, // Border width
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: Color.fromARGB(255, 58, 58, 58),
                            ),
                            onPressed: () async {
                              _navigateToChatState();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (event['category'] == 'My Events' ||
                        event['category'] == 'Past Events')
                      _buildHeader(event),
                    if (event.containsKey('date'))
                      Container(
                        width: MediaQuery.of(context).size.width - 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (event.containsKey('date') &&
                                (event['category'] == 'Maria Birthday' ||
                                    event['category'] == 'Natalia Graduation'))
                              _buildEventBox(event)
                            else if (event['category'] != 'My Events' &&
                                event['category'] != 'Past Events')
                              _buildEventAvatar(event),
                          ],
                        ),
                      ),
                    if (event.containsKey('date')) const Divider(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventBox(Map<String, dynamic> event) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: event['customHeight'] ?? 200.0,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black), // Add border
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              child: Image.asset(
                event['imagePath'] ?? '',
                fit: BoxFit.cover,
                width: double.infinity,
                height: event['customHeight'] ?? 200.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${event['category']}',
                      style: const TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 18, color: Color.fromARGB(255, 37, 38, 39)),
                        const SizedBox(
                          width: 15,
                        ),
                        Text('${event['Place'] ?? 'Not specified'}'),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.calendar_month,
                            size: 18, color: Color.fromARGB(255, 59, 60, 61)),
                        const SizedBox(
                          width: 15,
                        ),
                        Text('${event['date'] ?? 'Not specified'}')
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    _navigateToEventDetails(event, context);
                  },
                  child: const Text('View',
                      style: TextStyle(fontSize: 11.0, color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(239, 248, 217, 43),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(
                        color: Colors.black, // Set the border color
                        width: 1.0, // Set the border width
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventAvatar(Map<String, dynamic> event) {
    return Container(
      height: event['customHeight'] ?? 70.0,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: AssetImage(event['imagePath'] ?? ''),
        ),
        title: Text(
          '${event['category']}',
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${event['Place']}'),
            const SizedBox(
              height: 5,
            ),
            Text('${event['date']}'),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            _navigateToEventDetails(event, context);
          },
          child: const Text('View',
              style: TextStyle(fontSize: 11.0, color: Colors.black)),
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(239, 248, 217, 43),
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(
                color: Colors.black, // Set the border color
                width: 1.5, // Set the border width
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> event) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        event['category'] ?? '',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
    );
  }

  void _navigateToChatState() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );

    // Check if result is not null and update the events list
    if (result != null) {
      setState(() {
        events.add({
          'category': result['category'],
          'date': result['date'],
          'time': result['time'],
          'enteredText': result['enteredText'],
        });
      });
    }
  }

  void _navigateToEventDetails(
      Map<String, dynamic> event, BuildContext context) {
    // Create a new Map<String, String> with values explicitly cast to String
    Map<String, String> eventDetails = {
      'category': event['category'].toString(),
      'Place': event['Place'].toString(),
      'date': event['date'].toString(),
      'time': event['time'].toString(),
      'enteredText': event['enteredText'].toString(),
      'imagePath': event['imagePath'].toString(),
    };

    // Handle customHeight parsing
    if (event.containsKey('customHeight')) {
      try {
        double customHeight = double.parse(event['customHeight'].toString());
        eventDetails['customHeight'] = customHeight.toString();
      } catch (e) {
        // Handle the exception, log an error, or provide a default value
        print('Error parsing double for customHeight: $e');
        // Provide a default value or handle the error appropriately
        eventDetails['customHeight'] = '200.0'; // You can use any default value
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsScreen(event: eventDetails),
      ),
    );
  }
}
