import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share/share.dart';

class ChatState extends StatefulWidget {
  const ChatState({Key? key}) : super(key: key);

  @override
  _ChatStateState createState() => _ChatStateState();
}

class _ChatStateState extends State<ChatState> {
  List<Image> images = [];
  final ImagePicker _imagePicker = ImagePicker();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedCategory;
  TextEditingController textController = TextEditingController();

  final List<String> categories = [
    'Birthday',
    'Marriage',
    'Start New Business',
    'Business Success Party',
  ];

  Future<void> _getImageFromSource(ImageSource source) async {
    final XFile? pickedFile = await _imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        images.add(Image.file(File(pickedFile.path)));
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _shareInformation() {
    // Prepare the information to share
    String category = _selectedCategory ?? 'No category selected';
    String date = _selectedDate != null
        ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
        : 'No date selected';
    String time = _selectedTime != null
        ? "${_selectedTime!.hour}:${_selectedTime!.minute}"
        : 'No time selected';

    String enteredText = textController.text.isNotEmpty
        ? 'Entered Text: ${textController.text}\n'
        : '';

    String text = '$enteredText'
        'Event Category: $category\n'
        'Event Date: $date\n'
        'Event Time: $time\n';

    // Share the information using the share package
    Share.share(
      text,
      subject: 'Event Information',
      // You can customize the subject as needed
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('event creation'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdown for selecting category
              DropdownButton<String>(
                value: _selectedCategory,
                hint: const Text('Select Event Category'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Input line for selecting date
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                        labelText: 'Select Date',
                        suffixIcon: IconButton(
                          onPressed: () => _selectDate(context),
                          icon: const Icon(Icons.calendar_today),
                        ),
                      ),
                      controller: _selectedDate != null
                          ? TextEditingController(
                              text:
                                  "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      onTap: () => _selectTime(context),
                      decoration: InputDecoration(
                        labelText: 'Select Time',
                        suffixIcon: IconButton(
                          onPressed: () => _selectTime(context),
                          icon: const Icon(Icons.access_time),
                        ),
                      ),
                      controller: _selectedTime != null
                          ? TextEditingController(
                              text:
                                  "${_selectedTime!.hour}:${_selectedTime!.minute}",
                            )
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Text input box
              TextFormField(
                maxLength: 1000,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                minLines: 3,
                maxLines: null,
                controller: textController,
                decoration: InputDecoration(
                  labelText: 'Enter text (3-1000 characters)',
                  border: OutlineInputBorder(),
                ),
                // You can add onChanged or controller if needed
              ),
              const SizedBox(height: 16),
              // Image upload section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Upload Photos button inside the image container
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
                            color: Colors.black, // Set the color of the border
                            width: 2.0, // Set the width of the border
                          ),
                          borderRadius:
                              BorderRadius.circular(8.0), // Set border radius
                        ),
                        height: 150, // Increase the height as needed
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
                                      for (var image in images)
                                        GestureDetector(
                                          onTap: () {
                                            _viewImage(
                                                image); // Call _viewImage function
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(4),
                                            child: image,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  // + icon button below the image container
                  if (images.isNotEmpty)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        onPressed: () async {
                          await _getImageFromSource(ImageSource.gallery);
                        },
                        child: Icon(Icons.add),
                        // Remove background color
                      ),
                    ),
                  const SizedBox(
                    height: 17,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Add functionality for the submit button
                          // For example, you can handle form submission here
                          _shareInformation();
                        },
                        child: Text('Submit'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _shareInformation();
                        },
                        child: Text('Invite'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _viewImage(Image image) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            child: image,
          ),
        );
      },
    );
  }
}
