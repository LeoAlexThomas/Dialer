import 'package:fluttertoast/fluttertoast.dart';

class ShowMessage {
  customMsg(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.CENTER,
    );
  }
}
