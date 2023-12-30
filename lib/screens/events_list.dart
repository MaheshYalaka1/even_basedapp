import 'package:flutter/material.dart';
import 'package:get_contacts/even_createpage.dart';

class EventScreenList extends StatefulWidget {
  const EventScreenList({Key? key}) : super(key: key);

  @override
  _EventScreenListState createState() => _EventScreenListState();
}

class _EventScreenListState extends State<EventScreenList> {
  List<Map<String, String>> events = [
    {
      'category': 'Yesterday Events',
    },
    {
      'category': 'Meeting',
      'date': '2023-02-14',
      'time': '3:00 PM',
      'enteredText': 'Discuss project updates.',
    },
    // Add more predefined events as needed
    {
      'category': 'Today Events',
    },
    {
      'category': 'Birthday',
      'date': '2023-01-01',
      'time': '12:00 PM',
      'enteredText': 'Happy Birthday!',
    },
    {
      'category': 'Meeting',
      'date': '2023-02-15',
      'time': '10:30 AM',
      'enteredText': 'Discuss project updates.',
    },
    // Add more predefined events as needed
    {
      'category': 'Tomorrow Events',
    },
    {
      'category': 'Appointment',
      'date': '2023-02-16',
      'time': '2:30 PM',
      'enteredText': 'Meet with client.',
    },
    // Add more predefined events as needed
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
              onPressed: () {
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
                if (event['category'] == 'Yesterday Events' ||
                    event['category'] == 'Today Events' ||
                    event['category'] == 'Tomorrow Events')
                  _buildHeader(event),
                if (event.containsKey('date'))
                  ListTile(
                    title: Text('Category: ${event['category']}'),
                    subtitle: Text('Date: ${event['date']}'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      _navigateToEventDetails(event);
                    },
                  ),
                if (event.containsKey('date'))
                  Divider(), // Add divider to separate events
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(Map<String, String> event) {
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

  void _navigateToEventDetails(Map<String, String> event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsScreen(event: event),
      ),
    );
  }
}

class EventDetailsScreen extends StatelessWidget {
  final Map<String, String> event;

  const EventDetailsScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.containsKey('date'))
              Text('Category: ${event['category']}'),
            if (event.containsKey('date')) const SizedBox(height: 16),
            if (event.containsKey('date')) Text('Date: ${event['date']}'),
            if (event.containsKey('date')) const SizedBox(height: 16),
            if (event.containsKey('date'))
              Text('Time: ${event['time'] ?? 'Not specified'}'),
            if (event.containsKey('date')) const SizedBox(height: 16),
            if (event.containsKey('date'))
              Text('Entered Text: ${event['enteredText'] ?? 'Not specified'}'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
