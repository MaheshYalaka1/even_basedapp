import 'package:flutter/material.dart';
import 'package:get_contacts/even_createpage.dart';
import 'package:get_contacts/screens/even_details.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      'date': '2024-01-20',
      'Place': 'Guntur',
      'time': '3:00 PM',
      'enteredText': 'Happy Birthday maria',
      'imagePath': 'assets/splash4.jpg',
      'customHeight': 200.0, // Custom height for Meeting event
    },
    {
      'category': 'Natalia Graduation',
      'date': '2024-03-01',
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
      'date': '2023-02-16',
      'Place': 'Hyderabad',
      'time': '2:30 PM',
      'enteredText': 'Meet with client.',
      'imagePath': 'assets/splash3.jpg',
      'customHeight': 70.0,
    },
    {
      'category': 'tripe araku',
      'date': '2023-02-15',
      'Place': 'vijayawada',
      'time': '10:30 AM',
      'enteredText': 'Discuss project updates.',
      'imagePath': 'assets/splash2.jpg',
      'customHeight': 70.0,
    },
    {
      'category': 'marrage',
      'date': '2023-02-15',
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
            icon: Icon(
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
              padding: EdgeInsets.all(8.0),
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.all(2.0),
                    child: Row(
                      children: [
                        Text(
                          'Create an event',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 58, 58, 58),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 6.0),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(
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
                            icon: Icon(
                              Icons.add,
                              color: const Color.fromARGB(255, 58, 58, 58),
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
              physics: NeverScrollableScrollPhysics(),
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
                        width: MediaQuery.of(context).size.width - 16,
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
                    if (event.containsKey('date')) Divider(),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: event['customHeight'] ?? 200.0,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black), // Add border
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
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
                      style: TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 18,
                            color: const Color.fromARGB(255, 37, 38, 39)),
                        Text('${event['Place'] ?? 'Not specified'}'),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_month,
                            size: 18,
                            color: const Color.fromARGB(255, 59, 60, 61)),
                        Text('${event['date'] ?? 'Not specified'}')
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    _navigateToEventDetails(event, context);
                  },
                  child: Text('View', style: TextStyle(fontSize: 11.0)),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(189, 210, 248, 43),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
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
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${event['Place']}'),
            Text('${event['date']}'),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            _navigateToEventDetails(event, context);
          },
          child: Text('View', style: TextStyle(fontSize: 11.0)),
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(189, 210, 248, 43),
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
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
        style: TextStyle(
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
