import 'package:flutter/material.dart';

class DialPad extends StatefulWidget {
  final Function(String number) onCall;
  DialPad({Key? key, required this.onCall}) : super(key: key);

  @override
  _DialPadState createState() => _DialPadState();
}

class _DialPadState extends State<DialPad> {
  var scrHeight;
  var scrWidth;
  var fontHeight;

  String phNumber = '';
  @override
  Widget build(BuildContext context) {
    scrHeight = MediaQuery.of(context).size.height / 100;
    scrWidth = MediaQuery.of(context).size.width / 100;
    fontHeight = MediaQuery.of(context).size.height * 0.01;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            height: scrHeight * 5,
            width: scrWidth * 85,
            child: Center(
              child: Text(
                phNumber,
                style: TextStyle(
                  fontSize: fontHeight * 3.5,
                ),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            numbers('1'),
            numbers('2'),
            numbers('3'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            numbers('4'),
            numbers('5'),
            numbers('6'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            numbers('7'),
            numbers('8'),
            numbers('9'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            numbers('*'),
            numbers('0'),
            numbers('#'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: scrWidth * 28,
              height: scrHeight * 5,
              child: Text(''),
            ),
            Container(
              width: scrWidth * 28,
              height: scrHeight * 7.5,
              child: IconButton(
                color: Colors.green,
                onPressed: () {
                  if (phNumber.length > 2) widget.onCall(phNumber);
                },
                icon: Icon(
                  Icons.phone,
                  size: fontHeight * 4,
                ),
              ),
            ),
            Container(
              width: scrWidth * 28,
              height: scrHeight * 7.5,
              child: IconButton(
                color: phNumber.length == 0 ? Colors.grey : Colors.red,
                onPressed: () {
                  if (phNumber.length != 0) {
                    phNumber = phNumber.substring(0, phNumber.length - 1);
                    setState(() {});
                  }
                },
                icon: Icon(Icons.backspace),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget numbers(String num) {
    return Container(
      width: scrWidth * 28,
      height: scrHeight * 7.5,
      child: InkWell(
        onTap: () {
          if (phNumber.length < 13) {
            phNumber += num;
            setState(() {});
          }
        },
        child: Center(
          child: Text(
            num,
            style: TextStyle(
              color: Colors.black,
              fontSize: fontHeight * 3,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
