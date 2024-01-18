import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsPage extends StatefulWidget {
  final String eventCategory;
  final String eventDate;
  final String eventTime;
  final String enteredText;
  final String videoUrl;

  const ContactsPage({
    required this.eventCategory,
    required this.eventDate,
    required this.eventTime,
    required this.enteredText,
    required this.videoUrl,
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

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts List'),
        actions: [
          if (_selectedMessageContacts.isNotEmpty ||
              _selectedEmailContacts.isNotEmpty ||
              _selectedWhatsappContacts.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                _showSendOptions();
              },
            ),
        ],
      ),
      backgroundColor:
          Color.fromARGB(235, 230, 176, 248), // Set the background color
      body: _isLoadingContacts
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors
                          .white, // Set the background color for the search box
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
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(8.0),
                          prefixIcon: Icon(Icons.search), // Add the search icon
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
                          color: Colors
                              .white, // Set the background color for the contacts box
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          title: Text(
                            contact.displayName ?? '',
                            maxLines: 1, // Set maxLines to 1
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            contact.emails?.isNotEmpty == true
                                ? contact.emails!.first.value ?? ''
                                : 'No email address',
                          ),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.blue,
                                width: 2.0,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundImage: contact.avatar != null
                                  ? MemoryImage(contact.avatar!)
                                  : null,
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
        'Event Information:\nCategory: ${widget.eventCategory}\nDate: ${widget.eventDate}\nTime: ${widget.eventTime}\nMessage: ${widget.enteredText}\nVideo: ${widget.videoUrl}';

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
        'Event Information:\nCategory: ${widget.eventCategory}\nDate: ${widget.eventDate}\nTime: ${widget.eventTime}\nMessage: ${widget.enteredText}';

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
        'Event Information:\nCategory: ${widget.eventCategory}\nDate: ${widget.eventDate}\nTime: ${widget.eventTime}\nMessage: ${widget.enteredText}\nVideo: ${widget.videoUrl}';

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
