// // import 'package:flutter/material.dart';

// // class ChatBubble extends StatelessWidget {
// //   final String message;
// //   const ChatBubble({super.key, required this.message});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       padding: const EdgeInsets.all(12),
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(8),
// //         color: Colors.blue,
// //       ),
// //       child: Text(
// //         message,
// //         style:  const TextStyle(fontSize: 16, color: Colors.white),
// //       ),
// //     );
// //   }
// // }



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:news_project/Features/Chat/Service/chatservice.dart';
// import 'package:news_project/Features/Profile/userProfilePage.dart';
// import 'package:news_project/model/UserModel.dart';

// class Chatscreen extends StatefulWidget {
//   const Chatscreen(
//       {super.key,
//       required this.Remail,
//       required this.Rid,
//       required this.imgUrl,
//       required this.senderUrl});
//   final Remail;
//   final senderUrl;
//   final Rid;
//   final imgUrl;
//   @override
//   State<Chatscreen> createState() => _ChatscreenState();
// }

// class _ChatscreenState extends State<Chatscreen> {
//   Future<String?> getImageUrlForUser() async {
//     final em = FirebaseAuth.instance.currentUser!.email.toString();

//     final userSnapshot = await FirebaseFirestore.instance
//         .collection('Users')
//         .where('email', isEqualTo: em)
//         .get();

//     if (userSnapshot.docs.isNotEmpty) {
//       final userData = userSnapshot.docs.first.data() as Map<String, dynamic>;

//       final imageUrl = userData['imgUrl'] as String?;
//       print(imageUrl);
//       return imageUrl;
//     } else {
//       // Handle the case when the user's document is not found
//       return null;
//     }
//   }

//   final _messageController = TextEditingController();
//   final chatService = ChatService();
//   final auth = FirebaseAuth.instance;
//   void send() {
//     if (_messageController.text.isNotEmpty) {
//       chatService.sendMessage(widget.Rid, _messageController.text.toString());
//     }
//     _messageController.clear();
//   }

//   Future<UserModel> toUserPofile() async {
//     final em = widget.Remail.toString();

//     final userSnapshot = await FirebaseFirestore.instance
//         .collection('Users')
//         .where('email', isEqualTo: em)
//         .get();
//     if (userSnapshot.docs.isNotEmpty) {
//       final userData = userSnapshot.docs.first.data() as Map<String, dynamic>;

//       final imageUrl = userData['imgUrl'] as String?;
//       return UserModel(
//           bio: userData['bio'],
//           email: userData['email'],
//           username: userData['username'],
//           uid: userData['uid'],
//           imgUrl: imageUrl.toString());
//     }
//     return UserModel(bio: 'bio', email: '', username: '', uid: '', imgUrl: '');
//   }

//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.sizeOf(context).width;
//     return Container(
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     toUserPofile().then((value) => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) =>
//                                 UserProfilePage(userModel: value))));
//                   },
//                   onLongPress: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) {
//                         return Container(
//                           child: Center(
//                             child: CircleAvatar(
//                               radius: 160,
//                               backgroundImage: NetworkImage(widget.imgUrl),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                   // onLongPressCancel: () => Navigator.pop(context),
//                   child: Padding(
//                     padding: const EdgeInsets.only(left: 8.0),
//                     child: CircleAvatar(
//                       backgroundImage: NetworkImage(widget.imgUrl),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                     // color: Colors.amber,
//                     // alignment: Alignment.center,
//                     margin: EdgeInsets.only(left: 90),
//                     child: Text(
//                       widget.Remail.toString().split('@')[0],
//                       style: GoogleFonts.ubuntu(
//                           fontSize: 25, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Divider(
//             height: 20,
//             color: Colors.black,
//           ),
//           Expanded(
//               child: Container(
//             decoration: BoxDecoration(
//                 image: DecorationImage(
//               opacity: 0.3,
//               image: AssetImage('assets/3731533_1971537.jpg'),
//               fit: BoxFit.cover,
//             )),
//             child: Padding(
//               padding: const EdgeInsets.all(4.0),
//               child: builderMessage(),
//             ),
//           )),
//           input(),
//         ],
//       ),
//     );
//   }

//   Widget builderMessage() {
//     return StreamBuilder(
//       stream: chatService.getMessages(widget.Rid, auth.currentUser!.uid),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: SpinKitWanderingCubes(
//               color: Colors.orange,
//               size: 35,
//             ),
//           );
//         }
//         print('tolist');
//         return ListView(
//             reverse: true,
//             physics: BouncingScrollPhysics(),
//             children:
//                 snapshot.data!.docs.map((e) => messages(e, context)).toList());
//       },
//     );
//   }

//   Widget messages(DocumentSnapshot docsss, context) {
//     final w = MediaQuery.sizeOf(context).width;
//     Map<String, dynamic> data = docsss.data() as Map<String, dynamic>;
//     print(data['senderId']);
//     var align = (data['senderId'] == auth.currentUser!.uid)
//         ? Alignment.centerRight
//         : Alignment.centerLeft;

//     // final kk = (data['senderId'] == auth.currentUser!.uid);
//     print(data['timeStamp'].toString());
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Container(
//         alignment: align,
//         child: Column(
//           children: [
//             // Container(
//             //   alignment: align,
//             //   child: Text(
//             //     data['email'].toString(),
//             //     style: GoogleFonts.ubuntu(color: Colors.black),
//             //   ),
//             // ),

//             data['senderId'] == auth.currentUser!.uid
//                 ? Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     // crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Column(
//                         children: [
//                           Container(
//                               alignment: Alignment.center,
//                               width: w * 0.7,
//                               decoration: BoxDecoration(
//                                   border:
//                                       Border.all(color: Colors.orange.shade300),
//                                   borderRadius: BorderRadius.only(
//                                     bottomLeft: Radius.circular(10),
//                                     topLeft: Radius.circular(10),
//                                     bottomRight: Radius.circular(10),
//                                   ),
//                                   color: align == Alignment.centerLeft
//                                       ? Colors.white
//                                       : Colors.orange.shade100),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(10.0),
//                                 child: Column(
//                                   children: [
//                                     Text(
//                                       data['message'],
//                                       style: GoogleFonts.ubuntu(fontSize: 20),
//                                     ),
//                                   ],
//                                 ),
//                               )),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Container(
//                                 alignment: Alignment.centerRight,
//                                 // color: Colors.amber,
//                                 width: w * 0.7,
//                                 // color: Colors.amber,
//                                 child: Text(
//                                   data['date']
//                                       .toString()
//                                       .split(' ')[1]
//                                       .toString()
//                                       .replaceFirst('-', ':'),
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 10,
//                                       color: Colors.grey.shade600),
//                                 ),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(bottom: 40, left: 5),
//                         child: CircleAvatar(
//                           radius: 12,
//                           backgroundImage: NetworkImage(widget.senderUrl),
//                         ),
//                       ),
//                     ],
//                   )
//                 : Row(
//                     children: [
//                       Container(
//                         margin: EdgeInsets.only(bottom: 40, right: 5),
//                         child: CircleAvatar(
//                           radius: 12,
//                           backgroundImage: NetworkImage(widget.imgUrl),
//                         ),
//                       ),
//                       Column(
//                         children: [
//                           Container(
//                               alignment: Alignment.center,
//                               width: w * 0.7,
//                               decoration: BoxDecoration(
//                                   border:
//                                       Border.all(color: Colors.grey.shade300),
//                                   borderRadius: BorderRadius.only(
//                                     bottomRight: Radius.circular(10),
//                                     topRight: Radius.circular(10),
//                                     bottomLeft: Radius.circular(10),
//                                   ),
//                                   color: align == Alignment.centerLeft
//                                       ? Colors.grey.shade200
//                                       : Colors.orange.shade200),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(10.0),
//                                 child: Text(
//                                   data['message'],
//                                   style: GoogleFonts.ubuntu(fontSize: 20),
//                                 ),
//                               )),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Container(
//                                 alignment: Alignment.centerLeft,

//                                 width: w * 0.7,
//                                 // color: Colors.amber,
//                                 child: Text(
//                                   data['date']
//                                       .toString()
//                                       .split(' ')[1]
//                                       .replaceFirst('-', ':')
//                                       .toString(),
//                                   style: GoogleFonts.poppins(
//                                       fontSize: 10,
//                                       color: Colors.grey.shade600),
//                                 ),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget input() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 10),
//       child: TextField(
//         controller: _messageController,
//         textInputAction: TextInputAction.newline,
//         decoration: InputDecoration(
//             suffixIconColor: Colors.black,
//             hintText: 'Message',
//             focusColor: Colors.black,
//             hoverColor: Colors.black,
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(23)),
//             suffixIcon: IconButton(
//                 onPressed: () => send(), icon: Icon(Icons.send_rounded))),
//       ),
//     );
//   }
// }