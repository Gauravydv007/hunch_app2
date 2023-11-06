import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late String myEmail;
  late String username;
  late String imageUrl;


  @override
  void initState() {
    super.initState();
    _fetch(); // Call the fetch method to get the user data and image URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: _fetch(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done)
                return Text('Loading data....');
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                     Center(
                child: GestureDetector(
                  onTap: (){
                    showDialog(context: context, builder: (context) {
                      return Container(
                        child: CircleAvatar(backgroundImage: NetworkImage(imageUrl),radius: 50,),
                      );
                    },);
                  },
                  child: Container(
                    height: 130,
                    width: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                      )
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: imageUrl.isNotEmpty
                       ? Image.network(imageUrl ,
                        fit: BoxFit.cover,
                        
                        loadingBuilder: (context, child , loadingProgress){
                          if(loadingProgress == null) return child ;
                          return Center(child: CircularProgressIndicator(),);
                        },
                        errorBuilder: (context ,Object, Stack){
                          return Container(
                            child: Icon(Icons.error_outline, color: Colors.amber,),
                          );
                        }
                                   ): Center(child: CircularProgressIndicator(),)
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),


                  SizedBox(
                    child: Card(
                      elevation: 12,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 10,
                                sigmaY: 10,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text('Username : $username',
                                style: TextStyle(fontSize: 20),
                                )
                                ))),
                    ),
                  ),

                     SizedBox(
                    child: Card(
                      elevation: 12,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 10,
                                sigmaY: 10,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'Email : $myEmail', style: TextStyle(fontSize: 19),
                                ),
                                ),
                                )),
                    ),
                  ),

                  // SizedBox(height: 20),
                  // Card(child: Text('Email : $myEmail')),
                ],
              );
            }),
      ),
    );
  }

//   _fetch() async {

//     final firebaseUser = await FirebaseAuth.instance.currentUser();
//     if(firebaseUser!=null)
//     await Firestore.instance.collection('user').document(firebaseUser.uid).get().then((ds){
//       myEmail =ds.data['email'];;
//     });
//   }
// }

  _fetch() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('user')
          .doc(firebaseUser.uid)
          .get();
      if (userDoc.exists) {
        myEmail = userDoc.data()?['email'] ?? '';
        username = userDoc.data()?['username'] ?? "";
         imageUrl = userDoc.data()?['image'] ?? ''; // Get the image URL from Firestore
        print(myEmail);
        final usernameFromFirestore = userDoc.data()?['username'];
        print(
            'Username stored in Firestore: $usernameFromFirestore'); // Print the username
      }
    }
  }
}
