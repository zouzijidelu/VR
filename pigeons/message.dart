import 'package:pigeon/pigeon.dart';


// val index = message.get<Int>("index")
// val tempPath = message.get<String>("tempPath")
// val tempThumbnail = message.get<String>("tempThumbnail")
// val relativeCoverPath = message.get<String>("relativeCoverPath")
// val title = message.get<String>("title")
class F2NMessage{
  String? msg;
  int? index;
  String? tempPath;
  String? tempThumbnail;
  String? relativeCoverPath;
  String? title;
}

class N2FMessage{
  String? msg2;
}

@HostApi()
abstract class FlutterMessage{
  void flutterSendMessage(F2NMessage msg);
}

@FlutterApi()
abstract class NativeMessage{
  void nativeSendMessage(N2FMessage msg);
}