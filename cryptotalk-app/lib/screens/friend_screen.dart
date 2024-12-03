import 'package:cryptotalk/crypto/sha256_utils.dart';
import 'package:cryptotalk/models/key_pair.dart';
import 'package:cryptotalk/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cryptotalk/common/api.dart';
import 'package:cryptotalk/models/friend.dart';
import 'package:cryptotalk/screens/qr_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:toastification/toastification.dart';

import '../common/hex_utils.dart';

class FriendScreen extends StatefulWidget {
  String name;
  String privateKey;
  String publicKey;

  FriendScreen(
      {super.key,
      required this.name,
      required this.privateKey,
      required this.publicKey});

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  List<Friend> friends = [];

  void scanQRCode(BuildContext context) async {
    final scanned = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const QrScreen()));
    if (scanned == null) return;
    final friend = await API.getFriend(scanned);
    if (friends.contains(friend)) {
      toastification.show(
        title: const Text('오류'),
        description: const Text('이미 추가한 친구입니다.'),
        type: ToastificationType.error,
        alignment: Alignment.bottomCenter,
        showIcon: false,
        showProgressBar: false,
        closeButtonShowType: CloseButtonShowType.none,
        autoCloseDuration: const Duration(seconds: 2),
      );
    } else {
      toastification.show(
        title: const Text('성공'),
        description: const Text('친구가 추가되었습니다.'),
        type: ToastificationType.success,
        alignment: Alignment.bottomCenter,
        showIcon: false,
        showProgressBar: false,
        closeButtonShowType: CloseButtonShowType.none,
        autoCloseDuration: const Duration(seconds: 2),
      );
      setState(() {
        friends.add(friend);
        print(friends);
      });
    }
  }

  Widget addFriendButton() {
    return MaterialButton(
        onPressed: () {
          scanQRCode(context);
        },
        color: Colors.blue,
        splashColor: Colors.blue[300],
        padding: EdgeInsets.zero,
        child: Container(
            height: 50,
            width: double.infinity,
            alignment: Alignment.center,
            child: const Text('친구 추가',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18))));
  }

  void showChats(Friend friend) {
    final kp = KeyPair(
        privateKey: HexUtils.hexToBytes(widget.privateKey),
        publicKey: HexUtils.hexToBytes(widget.publicKey));
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) =>
            ChatScreen(name: widget.name, friend: friend, keyPair: kp)));
  }

  Widget friend(Friend friend) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        child: InkWell(
            onTap: () {
              showChats(friend);
            },
            splashColor: Colors.grey,
            child: Container(
                height: 50,
                width: double.infinity,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Text(
                    '${friend.name} (${friend.publicKey.substring(0, 16)}...)',
                    style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 18)))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('친구 목록',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 24))),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text('내 공개키',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 18)),
                      const SizedBox(height: 8),
                      QrImageView(
                          data: widget.publicKey,
                          version: QrVersions.auto,
                          size: 192),
                      const SizedBox(height: 32),
                      const Text('친구 목록',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 18)),
                      const SizedBox(height: 8),
                      ...friends.map((e) => friend(e))
                    ],
                  ),
                ),
              ),
              addFriendButton()
            ],
          ),
        ),
      ),
    );
  }
}
