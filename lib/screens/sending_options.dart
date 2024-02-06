import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:EventBasedapp/dropdown.dart';
import 'package:EventBasedapp/login.dart';
import 'package:EventBasedapp/screens/events_list.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsPage extends StatefulWidget {
  final String eventTitle;
  final String eventType;
  final DateTime eventDate;
  final String location;
  final String enteredText;

  ContactsPage({
    required this.eventTitle,
    required this.eventType,
    required this.eventDate,
    required this.location,
    required this.enteredText,
  });

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> _contacts = [];
  List<Contact> _selectedMessageContacts = [];
  List<Contact> _selectedEmailContacts = [];
  List<Contact> _selectedWhatsappContacts = [];
  bool _isLoadingContacts = true;
  TextEditingController _searchController = TextEditingController();
  List<Contact> _filteredContacts = [];

  List<Color> avatarColors = [
    const Color.fromARGB(158, 244, 67, 54),
    const Color.fromARGB(158, 33, 149, 243),
    const Color.fromARGB(162, 76, 175, 79),
    const Color.fromARGB(144, 254, 220, 47),
    const Color.fromARGB(154, 255, 64, 128),
    // Add more colors as needed
  ];
  bool isMenuOpen = false;

  void toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  Future<void> navigateToPage(BuildContext context, String itemName) async {
    if (itemName == 'Sign out') {
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

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '',
          style: TextStyle(color: Color.fromARGB(167, 253, 252, 252)),
        ),
      ),
      endDrawer: AppDrawer(),
      backgroundColor:
          Color.fromARGB(255, 253, 249, 255), // Set the background color

      body: _isLoadingContacts
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchTextChanged,
                        decoration: InputDecoration(
                          hintText: 'Search contacts...',
                          contentPadding: EdgeInsets.all(8.0),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredContacts.length,
                    itemBuilder: (context, index) {
                      Contact contact = _filteredContacts[index];
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 243, 228, 228),
                          border: Border.all(
                            color: const Color.fromARGB(255, 27, 26, 26),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          title: Text(
                            contact.displayName ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            contact.emails?.isNotEmpty == true
                                ? contact.emails!.first.value ?? ''
                                : 'No email address',
                          ),
                          leading: ClipOval(
                            child: contact.avatar != null &&
                                    contact.avatar!.isNotEmpty
                                ? CircleAvatar(
                                    backgroundImage:
                                        MemoryImage(contact.avatar!),
                                    backgroundColor: Colors.transparent,
                                    radius:
                                        25.0, // Adjust the radius to increase/decrease the size
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: avatarColors[
                                          index % avatarColors.length],
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: const Icon(Icons.person,
                                        color: Colors.white,
                                        size:
                                            40.0), // Adjust the size of the icon
                                  ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.message),
                                onPressed: () {
                                  _toggleMessageContactSelection(contact);
                                },
                                color:
                                    _selectedMessageContacts.contains(contact)
                                        ? Colors.blue
                                        : null,
                              ),
                              IconButton(
                                icon: const Icon(Icons.email),
                                onPressed: () {
                                  _toggleEmailContactSelection(contact);
                                },
                                color: _selectedEmailContacts.contains(contact)
                                    ? Colors.blue
                                    : null,
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              IconButton(
                                icon: const Icon(Icons.whatshot),
                                onPressed: () {
                                  _toggleWhatsappContactSelection(contact);
                                },
                                color:
                                    _selectedWhatsappContacts.contains(contact)
                                        ? Colors.green
                                        : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(11.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _showSendOptions();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange, // Set the button color
                      onPrimary: Colors.white, // Set the text color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 29.0, vertical: 15.0),
                      side: const BorderSide(color: Colors.black, width: 2.0),
                    ),
                    child: Text(
                      'Send Invitation',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _getContacts() async {
    setState(() {
      _isLoadingContacts = true;
    });

    if (await Permission.contacts.request().isGranted) {
      Iterable<Contact> contacts = await ContactsService.getContacts();

      setState(() {
        _contacts = contacts.toList();
        _filteredContacts = _contacts;
        _isLoadingContacts = false;
      });
    } else {
      print('Permission denied');
      setState(() {
        _isLoadingContacts = false;
      });
    }
  }

  void _toggleMessageContactSelection(Contact contact) {
    setState(() {
      if (_selectedMessageContacts.contains(contact)) {
        _selectedMessageContacts.remove(contact);
      } else {
        _selectedMessageContacts.add(contact);
      }
    });
  }

  void _toggleEmailContactSelection(Contact contact) {
    setState(() {
      if (_selectedEmailContacts.contains(contact)) {
        _selectedEmailContacts.remove(contact);
      } else {
        _selectedEmailContacts.add(contact);
      }
    });
  }

  void _toggleWhatsappContactSelection(Contact contact) {
    setState(() {
      if (_selectedWhatsappContacts.contains(contact)) {
        _selectedWhatsappContacts.remove(contact);
      } else {
        _selectedWhatsappContacts.add(contact);
      }
    });
  }

  void _showSendOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Send Message'),
              onTap: () {
                Navigator.pop(context);
                _sendMessage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Send Email'),
              onTap: () {
                Navigator.pop(context);
                _sendEmail();
              },
            ),
            ListTile(
              leading: const Icon(Icons.whatshot),
              title: const Text('Send WhatsApp Message'),
              onTap: () {
                Navigator.pop(context);
                _sendWhatsappMessage();
              },
            ),
          ],
        );
      },
    );
  }

  void _sendMessage() async {
    String message =
        'Event Information:\neventTitle: ${widget.eventTitle}\neventType: ${widget.eventType}\nDate: ${widget.eventDate}\nMessage: ${widget.enteredText}\nlocation: ${widget.location}';

    List<String> phoneNumbers = _selectedMessageContacts
        .map((contact) => contact.phones?.isNotEmpty == true
            ? contact.phones!.first.value!
            : '')
        .toList();

    String phoneNumbersStr = phoneNumbers.join(',');

    String smsUrl = 'sms:$phoneNumbersStr?body=$message';

    if (await canLaunch(smsUrl)) {
      await launch(smsUrl);
    } else {
      print('Could not launch messaging app');
    }
  }

  void _sendEmail() async {
    String message =
        'Event Information:\neventTitle: ${widget.eventTitle}\neventType: ${widget.eventType}\nDate: ${widget.eventDate}\nMessage: ${widget.enteredText}\nlocation: ${widget.location}';

    List<String> emailAddresses = _selectedEmailContacts
        .map((contact) => contact.emails?.isNotEmpty == true
            ? contact.emails!.first.value!
            : '')
        .toList();

    String emailUrl =
        'mailto:${emailAddresses.join(', ')}?subject=Your%20Subject&body=$message';

    if (await canLaunch(emailUrl)) {
      await launch(emailUrl);
    } else {
      print('Could not launch email app');
    }
  }

  void _sendWhatsappMessage() async {
    String message =
        'Event Information:\neventTitle: ${widget.eventTitle}\neventType: ${widget.eventType}\nDate: ${widget.eventDate}\nMessage: ${widget.enteredText}\nlocation: ${widget.location}';

    for (Contact contact in _selectedWhatsappContacts) {
      String phoneNumber = contact.phones?.isNotEmpty == true
          ? contact.phones!.first.value!
          : '';

      String whatsappUrl = 'https://wa.me/$phoneNumber?text=$message';

      if (await canLaunch(whatsappUrl)) {
        await launch(whatsappUrl);
      } else {
        print('Could not launch WhatsApp for $contact');
      }
    }
  }

  void _onSearchTextChanged(String query) {
    setState(() {
      _filteredContacts = _contacts
          .where((contact) =>
              contact.displayName
                  ?.toLowerCase()
                  .contains(query.toLowerCase()) ==
              true)
          .toList();
    });
  }
}
