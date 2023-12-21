// contacts_screen.dart
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  _getContacts() async {
    try {
      if (await Permission.contacts.request().isGranted) {
        Iterable<Contact> _contacts = await ContactsService.getContacts();
        setState(() {
          contacts = _contacts.toList();
        });
      } else {
        // Handle the case when permission is not granted
        print('Permission not granted');
      }
    } catch (e) {
      // Handle other exceptions
      print('Error fetching contacts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contacts')),
      body: contacts.isEmpty
          ? Center(child: Text('No contacts available'))
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ListTile(
                  title: Text(contact.displayName ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildPhoneNumbers(contact.phones),
                  ),
                );
              },
            ),
    );
  }

  List<Widget> _buildPhoneNumbers(List<Item>? phones) {
    if (phones == null || phones.isEmpty) {
      return [Text('No phone numbers available')];
    }

    return phones
        .map((phone) => Text('${phone.label}: ${phone.value}'))
        .toList();
  }
}
