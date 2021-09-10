import 'package:flutter/material.dart';

class CustomAvatar extends StatelessWidget {
  final String name;
  const CustomAvatar({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isNumeric(name)) {
      return CircleAvatar(
          child: Icon(
        Icons.account_circle,
        size: (MediaQuery.of(context).size.height * 0.01) * 3.0,
      ));
    } else {
      return CircleAvatar(
        child: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: (MediaQuery.of(context).size.height * 0.01) * 2.5,
          ),
        ),
      );
    }
  }

  bool isNumeric(String str) {
    try {
      double.parse(str);
      return true;
    } on FormatException {
      if (str.contains('+')) {
        return true;
      }
      return false;
    }
  }
}
