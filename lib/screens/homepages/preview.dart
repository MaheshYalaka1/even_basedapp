import 'package:EventBasedapp/screens/homepages/responce.dart';
import 'package:flutter/material.dart';
import 'package:EventBasedapp/screens/homepages/dropdown.dart';
import 'package:EventBasedapp/screens/homepages/sending_options.dart';

class preview extends StatelessWidget {
  final String eventTitle;
  final String eventType;
  final DateTime eventDate;
  final String location;
  final String enteredText;
  final List<Image> images;

  preview({
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
      endDrawer: AppDrawer(),
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
              Container(
                width: 350.0,
                height: 350.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var i = 0; i < images.length; i++)
                        Container(
                          width: 350.0,
                          height: 350.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: Center(
                            child: SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                              child: Image(
                                image: images[i].image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 249, 144, 78),
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => responce()));
                    },
                    child: Text('Responce'),
                  ),
                  ElevatedButton(
                    onPressed: () {
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
