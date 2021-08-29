import 'package:call_log/call_log.dart';
import 'package:dailerapp/model/callLog.dart';
import 'package:dailerapp/widget/callType.dart';
import 'package:flutter/material.dart';

class CallDetails extends StatefulWidget {
  final CallLogEntry entry;
  CallDetails({Key? key, required this.entry}) : super(key: key);

  @override
  _CallDetailsState createState() => _CallDetailsState();
}

class _CallDetailsState extends State<CallDetails> {
  var scrHeight;
  var scrWidth;
  var fontHeight;
  CallLogger callLogger = CallLogger();
  @override
  Widget build(BuildContext context) {
    scrHeight = MediaQuery.of(context).size.height / 100;
    scrWidth = MediaQuery.of(context).size.width / 100;
    fontHeight = MediaQuery.of(context).size.height * 0.01;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Call Details'),
        ),
        body: Container(
          height: scrHeight * 50,
          padding: EdgeInsets.symmetric(
            horizontal: scrWidth * 5,
            vertical: scrHeight * 5,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: fontHeight * 5,
                child: callLogger.isNumeric(callLogger.getName(widget.entry)[0])
                    ? Icon(
                        Icons.account_circle,
                        size: fontHeight * 5,
                      )
                    : Text(
                        callLogger.getName(widget.entry)[0],
                        style: TextStyle(
                          fontSize: fontHeight * 5,
                        ),
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    callLogger.getName(widget.entry),
                    style: TextStyle(
                      fontSize: fontHeight * 3,
                    ),
                  ),
                  IconButton(
                    onPressed: () => callLogger.call(widget.entry.number),
                    icon: Icon(
                      Icons.phone,
                      size: fontHeight * 3.5,
                    ),
                  ),
                ],
              ),
              if (!callLogger.isNumeric(callLogger.getName(widget.entry)[0]))
                Text(
                  widget.entry.number!,
                  style: TextStyle(
                    fontSize: fontHeight * 2,
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(children: [
                      CallTypeWidget(callType: widget.entry.callType!),
                      SizedBox(
                        width: scrWidth * 5,
                      ),
                      getCallType(widget.entry.callType!),
                    ]),
                  ),
                  Text(callLogger.getTime(widget.entry.duration)),
                ],
              ),
              Text(
                callLogger.getFormatedDate(
                    new DateTime.fromMillisecondsSinceEpoch(
                        widget.entry.timestamp ?? 0)),
              ),
              Text(widget.entry.simDisplayName!),
            ],
          ),
        ),
      ),
    );
  }

  Widget getCallType(CallType callType) {
    String type = callType.toString();
    int index = type.indexOf('.');
    type = type.substring(index + 1);

    return Text(type + ' ' + 'call');
  }
}
