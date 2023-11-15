// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hunch_app/mesaging/const.dart';
// import 'package:hunch_app/provider/blog_provider.dart';
// import 'package:hunch_app/provider/user_provider.dart';
// import 'package:provider/provider.dart';



// class BlogsCreate extends StatefulWidget {
//   const BlogsCreate({Key? key}): super(key: key);

//   @override
//   State<BlogsCreate> createState() => _BlogsCreateState();
// }

// class _BlogsCreateState extends State<BlogsCreate> {
//   final user = FirebaseAuth.instance.currentUser;
//   File? _photo;
//   var download_link;



//     var  style= GoogleFonts.ubuntu(
//                               color: Colors.blue
//                              );
//   Future uploadFile(String title) async {
//     if (_photo == null) return;
//     final fileName = title;


//     try {
//       final ref = FirebaseStorage.instance.ref().child(fileName);
//       var task = await ref.putFile(_photo!);
//       download_link = await ref.getDownloadURL();
//       print('download link is  : ${download_link}');
//     } catch (e) {
//       print('error occured');
//     }
//   }

//   Future<void> uploadDataToFirestore(
//     String title,
//     String content,
//     String key,
//   ) async {
//     try {
//       final firestoreInstance = FirebaseFirestore.instance;

//       Map<String, dynamic> data = {
//         'title': title,
//         'content': content,
//         'user': key
//       };
//       await firestoreInstance
//           .collection('Blogs')
//           .doc(user!.email!.split('@')[0].toString())
//           .collection(user!.email!.split('@')[0].toString())
//           .doc(title)
//           .set(data);
//       await firestoreInstance.collection('AllBlogs').doc(title).set(data);

//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Blog Creted SuccessFullyyy')));
//     } catch (e) {
//       print('Error adding data to Firestore: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final h = MediaQuery.sizeOf(context).height;

//     final w = MediaQuery.sizeOf(context).width;
//     final currentUser = FirebaseAuth.instance.currentUser;
//     // final style =
//     //     GoogleFonts.ubuntu(color: Constant().blue, fontSize: h * 0.02);

//     return Consumer<UserProvider>(
//       builder: (context, valueUser, child) => Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Card(
//           elevation: 10,
//           child: Container(
//             height: h * 0.4,
//             // color: Constant().plat,
//             child: Stack(children: [
//               Opacity(
//                 opacity: 0.8,
//                 child: SvgPicture.asset(
//                   'assets/iPhone 14 & 15 Pro - 1bgcard.svg',
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               Center(
//                   child: Container(
//                 height: h * 0.6,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(top: h * 0.06),
//                       child: Text(
//                         'Create a New Blog ',
//                         style: GoogleFonts.ubuntu(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                             fontSize: h * 0.03),
//                       ),
//                     ),
//                     Column(
//                       children: [
//                         Form(
//                           // ignore: sort_child_properties_last
//                           child: Consumer<BlogProvider>(
//                               builder: (context, value, child) {
                            
//                             return Container(
//                               alignment: Alignment.topCenter,
//                               padding: EdgeInsets.all(w * 0.02),
//                               margin:
//                                   EdgeInsets.symmetric(horizontal: w * 0.04),
//                               child: Column(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Container(
//                                         margin: EdgeInsets.symmetric(
//                                             vertical: h * 0.01),
//                                         child: Text(
//                                           'Title*',
//                                           // style: style,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Container(
//                                       child: TextFormField(
//                                           validator: (text) {
//                                             if (text == null || text.isEmpty) {
//                                               return 'Title Must not be Empty';
//                                             } else {
//                                               return null;
//                                             }
//                                           },
//                                           controller: value.title,
//                                           onSaved: (text) {
//                                             value.title.text = text.toString();
//                                           },
//                                           cursorColor: Constant().blue,
//                                           decoration: InputDecoration(
//                                             hintText: 'Give your Blog a Title',
//                                             hintStyle: GoogleFonts.ubuntu(
//                                                 color: Constant().blue),
//                                             labelStyle: GoogleFonts.ubuntu(
//                                                 color: Constant().blue),
//                                             enabledBorder: OutlineInputBorder(
//                                                 borderSide: BorderSide(
//                                                     color: Constant().blue)),
//                                             focusedBorder: OutlineInputBorder(
//                                                 borderSide: BorderSide(
//                                                     color: Constant().blue)),
//                                           ),
//                                           maxLines: 1)),
//                                   Row(
//                                     children: [
//                                       Container(
//                                         margin: EdgeInsets.symmetric(
//                                             vertical: h * 0.01),
//                                         child: Text(
//                                           'Content*',
//                                           style: style,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Container(
//                                       child: TextFormField(
//                                           cursorColor: Constant().blue,
//                                           validator: (text) {
//                                             if (text == null || text.isEmpty) {
//                                               return 'Content Must not be Empty';
//                                             } else {
//                                               return null;
//                                             }
//                                           },
//                                           controller: value.content,
//                                           onSaved: (text) {
//                                             value.content.text =
//                                                 text.toString();
//                                           },
//                                           decoration: InputDecoration(
//                                               hintText: 'Content of Blog',
//                                               hintStyle: GoogleFonts.ubuntu(
//                                                   color: Constant().blue),
//                                               labelStyle: GoogleFonts.ubuntu(
//                                                   color: Constant().blue),
//                                               enabledBorder: OutlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: Constant().blue)),
//                                               focusedBorder: OutlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: Constant().blue)),
//                                               disabledBorder:
//                                                   OutlineInputBorder(
//                                                       borderSide: BorderSide(
//                                                           color: Constant()
//                                                               .blue))),
//                                           maxLines: 5)),
//                                   Container(
//                                     margin: EdgeInsets.only(top: h * 0.02),
//                                     alignment: Alignment.center,
//                                     child: ElevatedButton(
//                                       onPressed: () async {
//                                         if (value.title.text.isEmpty) {
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(SnackBar(
//                                                   content: Text(
//                                                     'Title Field cant be empty',
//                                                     style: style,
//                                                   ),
//                                                   dismissDirection:
//                                                       DismissDirection
//                                                           .horizontal,
//                                                   backgroundColor:
//                                                       Colors.pink.shade100));
//                                         }
//                                         if (value.content.text.isEmpty) {
//                                           ScaffoldMessenger.of(context)
//                                               .showSnackBar(SnackBar(
//                                                   content: Text(
//                                                     'Content Field cant be Empty',
//                                                     style: style,
//                                                   ),
//                                                   duration:
//                                                       Duration(seconds: 2),
//                                                   dismissDirection:
//                                                       DismissDirection
//                                                           .horizontal,
//                                                   backgroundColor:
//                                                       Colors.pink.shade100));
//                                         } else {
//                                           await uploadDataToFirestore(
//                                             value.title.text.toString(),
//                                             value.content.text.toString(),
//                                             currentUser!.email!
//                                                 .split('@')[0]
//                                                 .toString(),
//                                           );
//                                         }
//                                       },
//                                       // ignore: sort_child_properties_last
//                                       child: Text(
//                                         'Create Blog',
//                                         style: GoogleFonts.ubuntu(
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       style: ElevatedButton.styleFrom(
//                                           elevation: 10,
//                                           fixedSize: Size(w * 0.4, h * 0.05),
//                                           backgroundColor: Constant().pink,
//                                           foregroundColor: Constant().white,
//                                           shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(20))),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             );
//                           }),
//                           key: GlobalKey(),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               )),
//             ]),
//           ),
//         ),
//       ),
//     );
//   }
// }










