import 'dart:typed_data';

import 'package:contacts_service/contacts_service.dart';
import 'package:dailerapp/model/callLog.dart';
import 'package:flutter/material.dart';

class ContactDetails extends StatefulWidget {
  final Contact contact;
  ContactDetails({Key? key, required this.contact}) : super(key: key);

  @override
  _ContactDetailsState createState() => _ContactDetailsState(
      contact.avatar!, contact.phones!.first.value!, contact.displayName!);
}

class _ContactDetailsState extends State<ContactDetails> {
  final Uint8List avatar;
  final String number;
  final String name;

  _ContactDetailsState(this.avatar, this.number, this.name);

  @override
  void initState() {
    super.initState();
    print('Avatar: $avatar');
  }

  @override
  Widget build(BuildContext context) {
    var scrHeight = MediaQuery.of(context).size.height / 100;
    var fontHeight = MediaQuery.of(context).size.height * 0.01;
    return Column(
      children: [
        Stack(
          fit: StackFit.loose,
          alignment: Alignment.bottomLeft,
          children: [
            Container(
              height: scrHeight * 30,
              width: double.infinity,
              color: Colors.blueGrey,
              child: avatar.length == 0
                  ? Icon(
                      Icons.person,
                      size: fontHeight * 10,
                    )
                  : Image.memory(avatar),
            ),
            ListTile(
              title: Text(
                '$name',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fontHeight * 3.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        Card(
          elevation: 5,
          child: ListTile(
            onTap: () => CallLogger().call(number),
            title: Text(
              number,
              style: TextStyle(
                fontSize: fontHeight * 3.0,
              ),
            ),
            subtitle: Text('Mobile'),
          ),
        )
      ],
    );
  }
}
