import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_contacts/dropdown.dart';
import 'package:get_contacts/login.dart';
import 'package:get_contacts/preview.dart';
import 'package:get_contacts/screens/events_list.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Image> images = [];
  final ImagePicker _imagePicker = ImagePicker();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  // TextEditingController textController = TextEditingController();
  String selectedEvent = 'Celestial Soiree'; // Dropdown default value
  DateTime selectedDate = DateTime.now(); // Date picker default value
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _emojiShowing = false;

  String address = 'Address: ';
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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

  Future<void> navigateToPage(BuildContext context, String itemName) async {
    if (itemName == 'Sign out') {
      // Perform sign-out and navigate to the login page
      await signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
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

  Future<void> signOut() async {
    // Clear the login status in shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
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

      textError = _controller.text.isEmpty ? 'pls enter Event remarks' : null;
    });

    if (firstNameError == null && locationError == null && textError == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtherPage(
            eventTitle: firstNameController.text,
            eventType: selectedEvent,
            eventDate: selectedDate,
            location: locationController.text,
            enteredText: _controller.text,
            images: images,
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
          style: TextStyle(color: Color.fromARGB(167, 253, 252, 252)),
        ),
        // Set your desired background color
      ),
      endDrawer: AppDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: SingleChildScrollView(
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
                  items:
                      eventList.map<DropdownMenuItem<String>>((String value) {
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
                    suffixIcon: IconButton(
                      icon: Icon(Icons.location_on),
                      onPressed: () {
                        _getCurrentLocation();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    errorText: locationError,
                  ),
                ),
                Column(
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
                          width:
                              280, // Adjust this value to increase the height
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                    Container(
                        height: 66.0,
                        color: Color.fromARGB(255, 230, 233, 236),
                        child: Row(
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _emojiShowing = !_emojiShowing;
                                  });
                                },
                                icon: const Icon(
                                  Icons.emoji_emotions,
                                  color: Color.fromARGB(255, 31, 30, 30),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: TextField(
                                    controller: _controller,
                                    scrollController: _scrollController,
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      hintText: 'Event Remarks',
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.only(
                                        left: 16.0,
                                        bottom: 8.0,
                                        top: 8.0,
                                        right: 16.0,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        )),
                    Offstage(
                      offstage: !_emojiShowing,
                      child: EmojiPicker(
                        textEditingController: _controller,
                        scrollController: _scrollController,
                        config: Config(
                          height: 256,
                          checkPlatformCompatibility: true,
                          emojiViewConfig: EmojiViewConfig(
                            emojiSizeMax: 28 *
                                (foundation.defaultTargetPlatform ==
                                        TargetPlatform.iOS
                                    ? 1.2
                                    : 1.0),
                          ),
                          swapCategoryAndBottomBar: false,
                          skinToneConfig: const SkinToneConfig(),
                          categoryViewConfig: const CategoryViewConfig(),
                          bottomActionBarConfig: const BottomActionBarConfig(),
                          searchViewConfig: const SearchViewConfig(),
                        ),
                      ),
                    ),
                  ],
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
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        side: BorderSide(
                          color: Colors.black,
                          width: 1.5,
                        ),
                        minimumSize: Size(double.infinity, 50.0),
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
                      child: const Text('Remove'),
                    ),
                    const SizedBox(width: 16),
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

  Future<void> _getCurrentLocation() async {
    try {
      // Check and request location permissions
      await _checkLocationPermission();

      // Get the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');

      await _getAddress(position.latitude, position.longitude);
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _getAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark addressPlacemark = placemarks[0];
        String formattedAddress =
            '${addressPlacemark.street},${addressPlacemark.subLocality}, ${addressPlacemark.locality},${addressPlacemark.administrativeArea},${addressPlacemark.postalCode}, ${addressPlacemark.country}';
        print(formattedAddress);

        setState(() {
          locationController.text = formattedAddress;
          address = formattedAddress;
        });
      } else {
        print('No address found for the provided coordinates.');
        setState(() {
          locationController.text = 'No address found';
          address = 'No address found';
        });
      }
    } catch (e) {
      print('Error getting address: $e');
      setState(() {
        locationController.text = 'Error getting address';
        address = 'Error getting address';
      });
    }
  }

  Future<void> _checkLocationPermission() async {
    var status = await Permission.location.status;
    if (status != PermissionStatus.granted) {
      await Permission.location.request();
    }
  }
}
