import 'package:flutter/material.dart';
import 'package:get_contacts/screens/sending_options.dart';

class OtherPage extends StatelessWidget {
  final String eventTitle;
  final String eventType;
  final DateTime eventDate;
  final String location;
  final String enteredText;
  final List<Image> images;

  OtherPage({
    required this.eventTitle,
    required this.eventType,
    required this.eventDate,
    required this.location,
    required this.enteredText,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Other Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Invitation',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              const Text(
                'Create a new video invitation which can be shared with your family & friends',
                style: TextStyle(
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.left,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var i = 0; i < images.length; i++)
                      Container(
                        height: 500, //MediaQuery.of(context).size.height * 0.5,
                        width: 350, //MediaQuery.of(context).size.width * 0.5,
                        margin: const EdgeInsets.all(10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: images[i],
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Perform the action for the first button
                    },
                    child: Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to another page when the second button is clicked
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactsPage(
                            eventTitle: eventTitle,
                            eventType: eventType,
                            eventDate: eventDate,
                            location: location,
                            enteredText: enteredText,
                          ),
                        ),
                      );
                    },
                    child: Text('Preview & Next'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
