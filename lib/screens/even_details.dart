import 'package:flutter/material.dart';

class EventDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> event;

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
            Text(
              'Category: ${event['category']}',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            if (event['category'] == 'My Events' ||
                event['category'] == 'Past Events')
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'No additional details for this category.',
                  style: TextStyle(fontSize: 16.0),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Place: ${event['Place'] ?? 'Not specified'}'),
                  Text('Date: ${event['date'] ?? 'Not specified'}'),
                  if (event.containsKey('time')) Text('Time: ${event['time']}'),
                  if (event.containsKey('enteredText'))
                    Text('Description: ${event['enteredText']}'),
                  if (event.containsKey('imagePath'))
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(event['imagePath']),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  if (event.containsKey('customHeight'))
                    Container(
                      height: double.parse(event['customHeight'].toString()),
                      color: Colors.grey.shade300,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
