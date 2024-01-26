import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_contacts/screens/events_list.dart';
import 'package:get_contacts/screens/sending_options.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Image> images = [];
  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController textController = TextEditingController();
  String selectedEvent = 'Celestial Soiree'; // Dropdown default value
  DateTime selectedDate = DateTime.now(); // Date picker default value

  Future<void> _getImageFromSource(ImageSource source) async {
    final XFile? pickedFile = await _imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        images.add(Image.file(File(pickedFile.path)));
      });
    }
  }

  List<String> eventList = [
    'Celestial Soiree',
    'EnchantMingle',
    'LunaGala',
    'Radiant Re',
    'Harmony Have',
    'Nebula Nexus',
    'BlissBash',
    'GalaGrove',
    'MysticMingle',
  ];

  String? firstNameError;
  String? locationError;
  String? textError;

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _validateAndSubmit() {
    setState(() {
      firstNameError =
          firstNameController.text.isEmpty ? 'Please enter Event Title' : null;

      locationError =
          locationController.text.isEmpty ? 'Please enter Location' : null;

      textError =
          textController.text.isEmpty ? 'pls enter Event remarks' : null;
    });

    if (firstNameError == null && locationError == null && textError == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContactsPage(
            eventTitle: firstNameController.text,
            eventType: selectedEvent,
            eventDate: selectedDate,
            location: locationController.text,
            enteredText: textController.text,
          ),
        ),
      );
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'New event',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              const Text(
                'You can create your own invitation video for your event if you want to',
                style: TextStyle(
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: 'Event Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11.0),
                  ),
                  errorText: firstNameError,
                ),
              ),
              SizedBox(height: 10.0),
              DropdownButtonFormField<String>(
                value: selectedEvent,
                decoration: InputDecoration(
                  labelText: 'Event Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedEvent = newValue!;
                  });
                },
                items: eventList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(
                  text: "${selectedDate.toLocal()}".split(' ')[0],
                ),
                decoration: InputDecoration(
                  labelText: 'Event Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  errorText: locationError,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                maxLength: 1000,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                minLines: 3,
                maxLines: null,
                controller: textController,
                decoration: InputDecoration(
                  labelText: 'Event Remarks',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  errorText: textError,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: GestureDetector(
                      onTap: () async {
                        if (images.isEmpty) {
                          await _getImageFromSource(ImageSource.gallery);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(132, 0, 0, 0),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        height: 150,
                        width: 280, // Adjust this value to increase the height
                        child: Center(
                          child: images.isEmpty
                              ? Text(
                                  'Select Images',
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      for (var i = 0; i < images.length; i++)
                                        GestureDetector(
                                          onTap: () {
                                            _viewImage(images[i], i);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(4),
                                            child: images[i],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  if (images.isNotEmpty)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        onPressed: () async {
                          await _getImageFromSource(ImageSource.gallery);
                        },
                        child: Icon(Icons.add),
                      ),
                    ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _validateAndSubmit,
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 241, 195, 46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Adjust the radius as needed
                          ),
                          side: BorderSide(
                            color: Colors.black, // Set the border color
                            width: 1.5, // Set the border width
                          ),
                          minimumSize: Size(
                              double.infinity, 50.0), // Set the button height
                        ),
                        child: const Text(
                          'Submit & Create Invitation',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _viewImage(Image image, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: image,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _removeImage(index);
                        Navigator.pop(context);
                      },
                      child: Text('Remove'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () async {
                        await _replaceImage(index);
                        Navigator.pop(context);
                      },
                      child: Text('Replace'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _removeImage(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  Future<void> _replaceImage(int index) async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        images[index] = Image.file(File(pickedFile.path));
      });
    }
  }
}
