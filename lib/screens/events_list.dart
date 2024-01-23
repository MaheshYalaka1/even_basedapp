import 'package:flutter/material.dart';
import 'package:get_contacts/even_createpage.dart';
import 'package:get_contacts/screens/even_details.dart';

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
      'category': 'Meeting',
      'date': '2024-01-20',
      'Place': 'Guntur',
      'time': '3:00 PM',
      'enteredText': 'Discuss project updates.',
      'imagePath': 'assets/splash4.jpg',
      'customHeight': 200.0, // Custom height for Meeting event
    },
    {
      'category': 'Birthday',
      'date': '2024-03-01',
      'Place': 'chennai',
      'time': '12:00 PM',
      'enteredText': 'Happy Birthday!',
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
    },
    {
      'category': 'tripe arakuS',
      'date': '2023-02-15',
      'Place': 'vijayawada',
      'time': '10:30 AM',
      'enteredText': 'Discuss project updates.',
      'imagePath': 'assets/splash2.jpg',
    },
    {
      'category': 'marrage',
      'date': '2023-02-15',
      'Place': 'KPHP colony',
      'time': '10:30 AM',
      'enteredText': 'Discuss project updates.',
      'imagePath': 'assets/splash1.jpg',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Events'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                _navigateToChatState();
              },
            ),
          ],
        ),
        body: ListView.builder(
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
                            (event['category'] == 'Meeting' ||
                                event['category'] == 'Birthday'))
                          Stack(
                            children: [
                              Container(
                                height: event['customHeight'] ??
                                    MediaQuery.of(context).size.height * 0.5,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(event['imagePath'] ?? ''),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              Positioned(
                                top: 8.0,
                                left: 8.0,
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Category: ${event['category']}',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Place: ${event['Place'] ?? 'Not specified'}',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Date: ${event['date'] ?? 'Not specified'}',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 8.0,
                                right: 8.0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _navigateToEventDetails(event,
                                        context); // Pass the context here
                                  },
                                  child: Text(
                                    'View',
                                    style: TextStyle(fontSize: 11.0),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(189, 210, 248, 43),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        else if (event['category'] != 'My Events' &&
                            event['category'] != 'Past Events')
                          Container(
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    AssetImage(event['imagePath'] ?? ''),
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
                                  _navigateToEventDetails(
                                      event, context); // Pass the context here
                                },
                                child: Text(
                                  'View',
                                  style: TextStyle(fontSize: 11.0),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromARGB(189, 210, 248, 43),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                if (event.containsKey('date')) Divider(),
              ],
            );
          },
        ),
      ),
    );
  }

  void _navigateToChatState() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChatState()),
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
      'customHeight': (event['customHeight'] ?? '').toString(),
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsScreen(event: eventDetails),
      ),
    );
  }
}
