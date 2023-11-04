import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hunch_app/model/message.dart';
import 'dart:ui';

// class ChatService extends ChangeNotifier{

//   // get instance of auth and firestore

//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   //send Message
//   Future<void> sendMessage(String receiverId, String message) async {
//     // get currrent user infor.
//     final String currentUserId = _firebaseAuth.currentUser!.uid;
//     final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
//     final Timestamp timestamp = Timestamp.now();

//     //create new message

//     Message newMessage = Message(
//       senderId: currentUserId,
//       senderEmail: currentUserEmail,
//       receiverId: receiverId,
//       timestamp: timestamp,
//       message: message,


//     );


//    // construct chat room id from current user id and receiver id (sorted to ensure uniqeness )
//    List<String> ids = [currentUserId , receiverId];

//    ids.sort();
//    String chatRoomId = ids.join(
//     "_"
//    );
//    await _firestore
//    .collection('chat_rooms')
//    .doc(chatRoomId)
//    .collection('message')
//    .add(newMessage.toMap());



//   }

//   //get message
//   Stream<QuerySnapshot> getMessages(String userId, String otherUserId){
//     List<String> ids = [userId , otherUserId];
//     ids.sort();
//     String chatRoomId =ids.join("_");

//     return _firestore
//     .collection('chat_rooms')
//     .doc(chatRoomId)
//     .collection('messages')
//     // .orderBy('timestamp', descending: false)dsds
//     .snapshots();

//   }

// }






class ChatService extends ChangeNotifier {
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
        timestamp: time);

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