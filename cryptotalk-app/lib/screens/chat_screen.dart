import 'package:cryptotalk/common/api.dart';
import 'package:cryptotalk/crypto/sha256_utils.dart';
import 'package:cryptotalk/models/friend.dart';
import 'package:cryptotalk/models/key_pair.dart';
import 'package:cryptotalk/models/message.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../common/hex_utils.dart';

class ChatScreen extends StatefulWidget {
  final String name;
  final Friend friend;
  final KeyPair keyPair;

  const ChatScreen(
      {super.key,
      required this.name,
      required this.friend,
      required this.keyPair});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _controller = TextEditingController();
  List<Message> messages = [];
  String text = "";

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() async {
    try {
      final messages = await API.getMessages(
          HexUtils.bytesToHex(widget.keyPair.privateKey),
          HexUtils.bytesToHex(widget.keyPair.publicKey),
          widget.friend.publicKey);
      setState(() {
        this.messages = messages;
      });
    } catch (e) {
      print(e);
      toastification.show(
        title: const Text('오류'),
        description: const Text('메시지 조회에 실패했습니다.'),
        type: ToastificationType.error,
        alignment: Alignment.bottomCenter,
        showIcon: false,
        showProgressBar: false,
        closeButtonShowType: CloseButtonShowType.none,
        autoCloseDuration: const Duration(seconds: 2),
      );
    }
  }

  void send() async {
    if (text.isEmpty) return;
    try {
      await API.sendMessage(
          HexUtils.bytesToHex(widget.keyPair.privateKey),
          HexUtils.bytesToHex(widget.keyPair.publicKey),
          widget.friend.publicKey,
          text);
      _controller.clear();
      FocusScope.of(context).unfocus();
      refresh();
    } catch (e) {
      print(e);
      toastification.show(
        title: const Text('오류'),
        description: const Text('메시지 전송에 실패했습니다.'),
        type: ToastificationType.error,
        alignment: Alignment.bottomCenter,
        showIcon: false,
        showProgressBar: false,
        closeButtonShowType: CloseButtonShowType.none,
        autoCloseDuration: const Duration(seconds: 2),
      );
    }
  }

  Widget _button(String text, VoidCallback onPress) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: MaterialButton(
          onPressed: onPress,
          color: Colors.blue,
          splashColor: Colors.blue[300],
          child: Container(
              height: 50,
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(text,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18)))),
    );
  }

  Widget _textField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: TextField(
          controller: _controller,
          onChanged: (text) {
            this.text = text;
          },
          decoration: InputDecoration(
              hintText: '메시지 입력',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ))),
    );
  }

  Widget chat(Message message) {
    final me = HexUtils.bytesToHex(widget.keyPair.publicKey);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Row(
        children: [
          if (message.from == me) ...[SizedBox(width: 32)],
          Expanded(
            child: Container(
              color: (message.from == me) ? Colors.blue[300] : Colors.blue[100],
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: (message.from == me)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text((message.from == me) ? widget.name : widget.friend.name,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w800,
                          fontSize: 16)),
                  Text(message.message,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 16)),
                  Text(message.date.substring(0, message.date.length - 4),
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 14))
                ],
              ),
            ),
          ),
          if (message.from != me) ...[SizedBox(width: 32)],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.friend.name,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontSize: 24))),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                    child: Column(
                        children: messages.map((e) => chat(e)).toList())),
              ),
              _textField(),
              SizedBox(height: 8),
              _button('전송', send),
              _button('새로고침', refresh)
            ],
          ),
        ));
  }
}
