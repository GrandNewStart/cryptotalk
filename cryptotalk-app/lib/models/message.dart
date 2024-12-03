import 'dart:convert';
import 'dart:typed_data';

import '../crypto/aes_utils.dart';
import '../common/hex_utils.dart';

class Message {
  String id;
  String from;
  String to;
  String message;
  String date;

  Message(
      {required this.id,
      required this.from,
      required this.to,
      required this.message,
      required this.date});

  factory Message.from(Map<String, dynamic> map, Uint8List secret) {
    final id = map['id']! as String;
    final from = map['from']! as String;
    final to = map['to']! as String;
    final data = map['data']! as String;
    final date = map['date']! as String;
    final encrypted = HexUtils.hexToBytes(data);
    final tag = encrypted.sublist(encrypted.length - 16, encrypted.length);
    final iv = encrypted.sublist(encrypted.length - 28, encrypted.length - 16);
    final cipherText = encrypted.sublist(0, encrypted.length - 28);
    final decrypted = AESUtils.decrypt(secret, tag, iv, cipherText);
    final message = utf8.decode(decrypted);
    return Message(id: id, from: from, to: to, message: message, date: date);
  }
}
