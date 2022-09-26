import 'package:intl/intl.dart';
class Message{
  static const String COLLECTION_NAME="message";

  String id;
  String content;
  int time;
  String senderName;
  String senderId;
  Message(
      {
        required this.id,
        required this.content,
        required this.senderName,
        required this.time,
        required this.senderId
      }
      );
  Message.fromJson(Map<String,Object?>json):this(
      id: json['id']! as String,
      content: json['content']! as String,
      senderName: json['senderName']! as String,
      time: json['time']! as int,
    senderId: json['senderId'] as String
  );
  Map<String,Object> toJson(){
    return {
      'id': id,
      'content': content,
      'senderName': senderName,
      'time' : time,
      'senderId' : senderId
    };
  }
  getDateFormatted(){
    var dataFormat=DateFormat('HH:mm a');
    return dataFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }
}