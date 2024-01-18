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
      'category': 'My Events',
    },
    {
      'category': 'Meeting',
      'date': '2024-01-20',
      'Place': 'Guntur',
      'time': '3:00 PM',
      'enteredText': 'Discuss project updates.',
      'imagePath': 'assets/just.jpg',
    },
    {
      'category': 'Birthday',
      'date': '2024-03-01',
      'Place': 'chennai',
      'time': '12:00 PM',
      'enteredText': 'Happy Birthday!',
      'imagePath': 'assets/splash1 .jpg',
    },

    // Add more predefined events as needed
    {
      'category': 'Past Events',
    },
    {
      'category': 'Appointment',
      'date': '2023-02-16',
      'Place': 'Hyderabad',
      'time': '2:30 PM',
      'enteredText': 'Meet with client.',
      'imagePath': 'assets/splash2 .jpg',
    },
    {
      'category': 'Meeting',
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
      'imagePath': 'assets/splash3.jpg',
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
                  ListTile(
                    // Add leading avatar to the list tile
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(event['imagePath'] ?? ''),
                    ),
                    title: Text('Category: ${event['category']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${event['Place']}'),
                        Text('${event['date']}'),
                      ],
                    ),
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
    // Simulate loading data asynchronously with Future.delayed
    Future.delayed(Duration(seconds: 1), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventDetailsScreen(event: event),
        ),
      );
    });
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
              Text('Place: ${event['Place'] ?? 'Not specified'}'),
            if (event.containsKey('date')) const SizedBox(height: 16),
            if (event.containsKey('date'))
              Text('Time: ${event['time'] ?? 'Not specified'}'),
            if (event.containsKey('date')) const SizedBox(height: 16),
            if (event.containsKey('date'))
              Text('Entered Text: ${event['enteredText'] ?? 'Not specified'}'),
            if (event.containsKey('date')) const SizedBox(height: 16),
            if (event.containsKey('date'))
              if (event['imagePath'] != null)
                Image.asset(
                  event['imagePath']!,
                  fit: BoxFit.cover,
                  height: 200, // Adjust the height as needed
                ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(EventScreenList());
}
