// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:hunch_app/model/userModel.dart';


// class UserProvider extends ChangeNotifier {
//   var username;
//   TextEditingController _author = TextEditingController();
//   TextEditingController get author => _author;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> addDatatoFireStore(UserModel user) async {
//     print('addiing data');
//     CollectionReference _db = _firestore.collection('Users');
//     try {
//       Map<String, dynamic> data = {
//         'name': username,
//         'email': user.email,
//         'password': user.password,
//       };
//       await _db.add(data);
//       print('added');
//     } catch (e) {
//       print('$e');
//     }
//   }
// }