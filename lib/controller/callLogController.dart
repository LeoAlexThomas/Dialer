import 'package:dailerapp/model/callSearch.dart';

class CallLogController {
  List<CallDetail> callData = [];

  addCalls(CallDetail data) {
    if (!callData.contains(data)) callData.add(data);
  }
}
