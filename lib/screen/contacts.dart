import 'package:contacts_service/contacts_service.dart';
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
                  return ListTile(
                    title: Text(widget.contacts.elementAt(index).displayName ??
                        'unknown'),
                    subtitle: Text(
                        widget.contacts.elementAt(index).phones!.last.value!),
                  );
                },
              ),
      ),
    );
  }
}
