import 'dart:typed_data';

import 'package:contacts_service/contacts_service.dart';
import 'package:dailerapp/screen/contactDetails.dart';
import 'package:flutter/material.dart';

class ContactTab extends StatefulWidget {
  final Iterable<Contact> contacts;
  ContactTab({Key? key, required this.contacts}) : super(key: key);

  @override
  _ContactTabState createState() => _ContactTabState();
}

class _ContactTabState extends State<ContactTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: widget.contacts.length == 0
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: widget.contacts.length,
                itemBuilder: (BuildContext context, int index) {
                  Contact contact = widget.contacts.elementAt(index);
                  Uint8List avatar = contact.avatar!;
                  String name = contact.displayName!;
                  return ListTile(
                    leading: CircleAvatar(
                        child: avatar.length == 0
                            ? Icon(Icons.person)
                            : Image.memory(avatar)),
                    onTap: () => showModalBottomSheet(
                        context: context,
                        builder: (context) => ContactDetails(
                              contact: contact,
                            )),
                    title: Text(name),
                  );
                },
              ),
      ),
    );
  }
}
