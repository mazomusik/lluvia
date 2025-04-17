import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    // Se comprueba si el timestamp es un String o un Timestamp de Cloud Firestore
    DateTime time;
    if (map['timestamp'] is String) {
      time = DateTime.parse(map['timestamp']);
    } else if(map['timestamp'] is Timestamp) {
      time = (map['timestamp'] as Timestamp).toDate();
    } else {
      time = DateTime.now(); // valor por defecto
    }
    return Message(
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      text: map['text'],
      timestamp: time,
    );
  }
}
