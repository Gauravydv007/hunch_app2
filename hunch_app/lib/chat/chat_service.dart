import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hunch_app/model/message.dart';
import 'dart:ui';

class ChatService extends ChangeNotifier {  //notify listner when state change
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;

  void sendMessage(String Remail, String message) async {
    final currentuserId = _auth.currentUser!.uid;
    final currentUserEmail = _auth.currentUser!.email.toString();
    final time = Timestamp.now();
    Message newMessage = Message(
        receiverId: Remail,
        message: message,
        senderEmail: currentUserEmail,
        senderId: currentuserId,
        timestamp: time,
        date: '',
        imgUrl: '',
        image: '');

    List<String> ids = [currentuserId, Remail];
    ids.sort();
    String room = ids.join("-");
    await _store
        .collection('ChatRoom')
        .doc(room)
        .collection('Messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String uid2, String uid1) {
    List<String> ids = [uid1, uid2];
    ids.sort();
    String room = ids.join("-");
    return _store
        .collection('ChatRoom')
        .doc(room)
        .collection('Messages')
        .orderBy('timestamp', descending: true)
        // .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
