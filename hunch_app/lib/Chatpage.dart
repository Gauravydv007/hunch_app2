// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:hunch_app/auth_service.dart';
// // import 'package:hunch_app/chat_page.dart';
// // import 'package:provider/provider.dart';

// // class Chat extends StatefulWidget {
// //   const Chat({Key? key}) : super(key: key);


// //   @override
// //   State<Chat> createState() => _ChatState();
// // }

// // class _ChatState extends State<Chat> {

// //     //instance of auth 
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Messenger'),

// //       ),
// //       body: _buildUserListItem(),


// //     );
// //   }

// //   // build a list of users except for current logged user
// //   Widget _buildUserList(DocumentSnapshot document){
// //     return StreamBuilder<QuerySnapshot>(
// //       stream: FirebaseFirestore.instance.collection('user').snapshots(), 
// //       builder: (context, snapshot){
// //         if (snapshot.hasError){
// //           return const Text('error');
// //         }

// //         if(snapshot.connectionState == ConnectionState.waiting){
// //           return const Text('loading.....');

// //         }
// //         return ListView(
// //           children: snapshot.data!.docs.map<Widget>((doc) => _buildUserListItem(doc)).toList(),
// //         );
// //       }
// //       );
// //   }

// //   // build  individual user list items
// //   Widget _buildUserListItem(DocumentSnapshot document){
// //     Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

// //     //display all users expect current user
// //     if (_auth.currentUser!.email != data['email']){
// //       return ListTile(
// //         title: Text(data['email']),
// //         onTap: (){
// //           // pass the clicked user Uid to the chat page
// //           Navigator.push(
// //             context, 
// //             MaterialPageRoute(builder: (context) => ChatPage(
// //               receiverUserEmail: data['email'],
// //               receiverUserID: data['uid'],
// //             ))
// //             );

// //         },
// //       );
// //     }
// //     else{
// //       // return empty container
// //       return Container();
// //     }
// //   }
// // }




// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:hunch_app/auth_service.dart';
// import 'package:hunch_app/chat_page.dart';
// import 'package:provider/provider.dart';

// class Chat extends StatefulWidget {
//   const Chat({Key? key}) : super(key: key);

//   @override
//   State<Chat> createState() => _ChatState();
// }

// class _ChatState extends State<Chat> {
//   // Instance of auth
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Messenger'),
//       ),
//       body: _buildUserList(),
//     );
//   }

//   // Build a list of users except for the current logged-in user
//   Widget _buildUserList() {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('user').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return const Text('error');
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Text('loading.....');
//         }

//         return ListView(
//           children: snapshot.data!.docs.map<Widget>((doc) => _buildUserListItem(doc)).toList(),
//         );
//       },
//     );
//   }

//   // Build individual user list items
//   Widget _buildUserListItem(DocumentSnapshot document) {
//     Map<String, dynamic> data = document.data() as Map<String, dynamic>;

//     // Check if a user is logged in before accessing user data
//     if (_auth.currentUser != null) {
//       if (_auth.currentUser!.email != data['email']) {
//         return ListTile(
//           title: Text(data['email']),
//           onTap: () {
//             // Pass the clicked user Uid to the chat page
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ChatPage(
//                   receiverUserEmail: data['email'],
//                   receiverUserID: data['uid'],
//                 ),
//               ),
//             );
//           },
//         );
//       }
//     }

//     // Return an empty container if there is no logged-in user
//     return Container();
//   }
// }





import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hunch_app/auth_service.dart';
import 'package:hunch_app/chat_page.dart';
import 'package:provider/provider.dart';

// 



class Chatpage extends StatefulWidget {
  const Chatpage({super.key});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  String selected = '';
  Map<String, dynamic> cur = {};
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange.shade100,
        appBar: AppBar(
          title: Text(
            'Messenger',
            style: GoogleFonts.ubuntu(fontSize: 25),
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
                margin: EdgeInsets.only(top: 5),
                color: Colors.orange.shade100,
                child: Container(
                    decoration: BoxDecoration(
                        // color: Colors.grey.shade400,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                          )
                        ],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                    alignment: Alignment.center,
                    width: MediaQuery.sizeOf(context).width,
                    child: cur.isEmpty
                        ? Center(child: Text("SELECT A CHAT "))
                        : Chatscreen(
                            Remail: cur['email'],
                            Rid: cur['uid'],
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
          return Text('error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
              
            ),
          );
        } else {
          return Container(
            color: Colors.orange.shade100,
            height: w * 0.3,
            child: ListView(
                physics: BouncingScrollPhysics(),
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
          // print(select);
          print(_auth.currentUser!.email.toString() +
              "  " +
              _auth.currentUser!.uid.toString());
          print(email + 'as');
          cur = data;
          select = email;
          print(cur);
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
                  backgroundColor:
                      select == email ? Colors.orange : Colors.grey.shade200,
                  child: Icon(
                    Icons.person_2,
                    color: Colors.black,
                  ),
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