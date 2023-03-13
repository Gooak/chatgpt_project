
import 'package:flutter/material.dart';

enum ChatMessageType {user,bot}

class ChatMessage{

  final String text;
  final ChatMessageType chatMessageType;

  ChatMessage({
    required this.text,
    required this.chatMessageType,
  });
}


class ChatFields{
  static final String id = '_id';
  static final String text = 'text';
  static final String bottext ='bottext';
  static final String date = 'date';
}
class Contents{
  static String tableName ='mychatgpt';
  final int? id;
  final String text;
  final String bottext;
  final String date;

  Contents({
    this.id,
    required this.text,
    required this.bottext,
    required this.date,
  });

  Map<String, dynamic?> toJson() {
    return{
      ChatFields.id: id,
      ChatFields.text: text,
      ChatFields.bottext: bottext,
      ChatFields.date: date,
    };
  }
  
  factory Contents.fromJson(Map<String, dynamic> json){
    return Contents(
      id: json[ChatFields.id] as int?,
      text: json[ChatFields.text] == null? '': json[ChatFields.text] as String,
      bottext: json[ChatFields.bottext],
      date: json[ChatFields.date] == null ? '' : json[ChatFields.date].toString(),
    );
  }
  Contents clone({
    int? id,
    String? text,
    String? bottext,
    String? date,
  }) {
    return Contents(
      id: id ?? this.id,
      text: text ?? this.text,
      bottext: bottext ?? this.bottext,
      date: date ?? this.date
    );
  }
}