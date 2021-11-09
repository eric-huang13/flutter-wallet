import 'dart:convert';

class SDKIPCMessage {
  String action;
  String json;
  String sender;

  SDKIPCMessage({required this.action, required this.json, required this.sender});

  factory SDKIPCMessage.fromIPCMessage(String base64EncodedMessage){

    final json = utf8.decode(base64Url.decode(base64EncodedMessage));
    final jsonMap = jsonDecode(json);

    return SDKIPCMessage(action: jsonMap['action'].toString(), json: jsonMap['json'].toString(), sender: jsonMap['sender'].toString());
  }



  String toJson() => jsonEncode(
      {
        'sender' : sender,
        'json' : json,
        'action' : action
      }
  );

  String createMessage() => base64Url.encode(utf8.encode(toJson()));

  @override
  String toString() {
    return 'SDKIPCMessage{action: $action, json: $json, sender: $sender}';
  }
}
