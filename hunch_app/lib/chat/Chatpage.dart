import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hunch_app/auth_service.dart';
import 'package:hunch_app/chat/chat_page.dart';
import 'package:provider/provider.dart';

// class Chatpage extends StatefulWidget {
//   const Chatpage({super.key});

//   @override
//   State<Chatpage> createState() => _ChatpageState();
// }

// class _ChatpageState extends State<Chatpage> {
//   var senderUrl = FirebaseAuth.instance.currentUser!.photoURL.toString();
//   Future<String?> getImageUrlForUser() async {
//     final em = FirebaseAuth.instance.currentUser!.email.toString();

//     final userSnapshot = await FirebaseFirestore.instance
//         .collection('user')
//         .where('email', isEqualTo: em)
//         .get();

//     if (userSnapshot.docs.isNotEmpty) {
//       final userData = userSnapshot.docs.first.data() as Map<String, dynamic>;

//       final imageUrl = userData['imgUrl'] as String?;
//       print(imageUrl);
//       return imageUrl;
//     } else {
//       return null;
//     }
//   }

//   String selected = '';
//   Map<String, dynamic> cur = {};
//   final _auth = FirebaseAuth.instance;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.orange.shade100,

//         // AppBar(
//         //   title: Text(
//         //     'Messenger',
//         //     style: GoogleFonts.ubuntu(fontSize: 25),
//         //   ),
//         //   centerTitle: true,
//         //   backgroundColor: Colors.white,
//         //   foregroundColor: Colors.black,
//         // ),
//         body: Container(
//           child: Column(
//             children: [
//               _usersList(context, selected),
//               Expanded(
//                   child: Container(
//                 margin: EdgeInsets.only(top: 5),
//                 color: Colors.orange.shade100,
//                 child: Container(
//                     decoration: BoxDecoration(
//                         // color: Colors.grey.shade400,
//                         color: Colors.white,
//                         boxShadow: [
//                           BoxShadow(
//                             blurRadius: 5,
//                           )
//                         ],
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(25),
//                             topRight: Radius.circular(25))),
//                     alignment: Alignment.center,
//                     width: MediaQuery.sizeOf(context).width,
//                     child: cur.isEmpty
//                         ? Center(
//                             child: Text(
//                             "SELECT USER ",
//                             style: TextStyle(
//                                 fontSize: 24, fontWeight: FontWeight.bold),
//                           ))
//                         : Chatscreen(
//                             Remail: cur['email'],
//                             Rid: cur['uid'],
//                             imgUrl: cur['image'],
//                             senderUrl: senderUrl,
                            
//                           )),
//               ))
//             ],
//           ),
//         ));
//   }

//   Widget _usersList(context, selected) {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance.collection('user').snapshots(),
//       builder: (context, snapshot) {
//         final w = MediaQuery.sizeOf(context).width;

//         if (snapshot.hasError) {
//           return Text('error');
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(
//               color: Colors.orange,
//             ),
//           );
//         } else {
//           return Container(
//             color: Colors.orange.shade100,
//             height: w * 0.3,
//             child: ListView(
//                 physics: BouncingScrollPhysics(),
//                 scrollDirection: Axis.horizontal,
//                 children: snapshot.data!.docs
//                     .map<Widget>((e) => buildUserList(e, context, selected))
//                     .toList()),
//           );
//         }
//       },
//     );
//   }

//   Widget buildUserList(DocumentSnapshot snapshot, context, selected) {
//     final h = MediaQuery.sizeOf(context).height;
//     final w = MediaQuery.sizeOf(context).width;
//     String select = '';
//     final data = snapshot.data()! as Map<String, dynamic>;
//     // print(data);
//     if (_auth.currentUser!.email.toString().toLowerCase() !=
//         data['email'].toString().toLowerCase()) {
//       final email = data['email'].toString();
//       return GestureDetector(
//         onTap: () {

//           getImageUrlForUser().then((value) {
//             senderUrl = value.toString();
//             print(senderUrl);
//           });
//           // print(select);
//           print(_auth.currentUser!.email.toString() +
//               "  " +
//               _auth.currentUser!.uid.toString());
//           print(email + 'as');
//           cur = data;
//           select = email;
//           print(cur);
//           setState(() {});
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Container(
//             width: w * 0.23,

//             // color: Colors.red,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 CircleAvatar(
//                   radius: 35,
//                   backgroundImage: NetworkImage(data['image']),
//                   backgroundColor:
//                       select == email ? Colors.orange : Colors.grey.shade200,
//                 ),
//                 Text(
//                   email.split('@')[0].toString().toLowerCase(),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 )
//               ],
//             ),
//           ),
//         ),
//       );
//     } else {
//       return Container();
//     }
//   }
// }







class Chatpage extends StatefulWidget {
  const Chatpage({super.key});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  @override
  void initState() {
    getImageUrlForUser().then((value) {
      print(value);
      senderUrl = value.toString();
    });
  }

  var senderUrl = '';
  Future<String?> getImageUrlForUser() async {
    final em = FirebaseAuth.instance.currentUser!.email.toString();

    final userSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('email', isEqualTo: em)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      final userData = userSnapshot.docs.first.data() as Map<String, dynamic>;

      final imageUrl = userData['image'] as String?;
      print(imageUrl);
      return imageUrl;
    } else {
      return null;
    }
  }

  String selected = '';
  Map<String, dynamic> cur = {};
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange.shade100,
        appBar: AppBar(
          title: Text(
            'Flash Chat',
            style:
                GoogleFonts.ubuntu(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Container(
          child: Column(
            children: [
              _usersList(context, selected),
              Expanded(
                  child: Container(
                margin: const EdgeInsets.only(top: 5),
                color: Colors.orange.shade100,
                child: Container(
                    decoration: BoxDecoration(
                        // color: Colors.grey.shade400,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5,
                              spreadRadius: 1,
                              color: Colors.grey.shade500)
                        ],
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                    alignment: Alignment.center,
                    width: MediaQuery.sizeOf(context).width,
                    child: cur.isEmpty
                        ? Center(
                            child: Text(
                            "Select a chat ",
                            style: GoogleFonts.ubuntu(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ))
                        : Chatscreen(
                            Remail: cur['email'],
                            Rid: cur['uid'],
                            imgUrl: cur['image'],
                            senderUrl: senderUrl,
                          )),
              ))
            ],
          ),
        ));
  }

  Widget _usersList(context, selected) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('user').snapshots(),
      builder: (context, snapshot) {
        final w = MediaQuery.sizeOf(context).width;

        if (snapshot.hasError) {
          return const Text('error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
              
            ),
          );
        } else {
          return Container(
            color: Colors.orange.shade100,
            height: w * 0.3,
            child: ListView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: snapshot.data!.docs
                    .map<Widget>((e) => buildUserList(e, context, selected))
                    .toList()),
          );
        }
      },
    );
  }

  Widget buildUserList(DocumentSnapshot snapshot, context, selected) {
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;
    String select = '';
    final data = snapshot.data()! as Map<String, dynamic>;
    // print(data);
    if (_auth.currentUser!.email.toString().toLowerCase() !=
        data['email'].toString().toLowerCase()) {
      final email = data['email'].toString();
      return GestureDetector(
        onTap: () {
          getImageUrlForUser().then((value) {
            senderUrl = value.toString();

            print(senderUrl);
          });
          print(_auth.currentUser!.email.toString() +
              "  " +
              _auth.currentUser!.uid.toString());
          print(email + 'as');
          cur = data;
          // ChatService().current = email;
          // // ChatService().notifyListeners();
          // print(email + "++ " + ChatService().current);
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: w * 0.23,

            // color: Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 35,
                  // backgroundColor: ChatService().current == email
                  //     ? Colors.orange
                  //     : Colors.grey.shade200,
                  backgroundImage: NetworkImage(data['image'].toString()),
                ),
                Text(
                  email.split('@')[0].toString().toLowerCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}