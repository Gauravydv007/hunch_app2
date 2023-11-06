// import 'dart:ffi';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class UserPage extends StatefulWidget {
//   const UserPage({super.key});

//   @override
//   State<UserPage> createState() => _UserPageState();
// }

// class _UserPageState extends State<UserPage> {

//   final ref = FirebaseDatabase.instance.ref('');
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 15),
//           child: Column(
//             children: [
//               SizedBox(height:20),
//               Center(
//                 child: Container(
//                   height: 130,
//                   width: 130,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: Colors.black,
//                     )
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(100),
//                     child: Image(
//                       fit: BoxFit.cover,
//                       image: NetworkImage(''),
//                       loadingBuilder: (context, child , loadingProgress){
//                         if(loadingProgress == null) return child ;
//                         return Center(child: CircularProgressIndicator(),);
//                       },
//                       errorBuilder: (context ,Object, Stack){
//                         return Container(
//                           child: Icon(Icons.error_outline, color: Colors.amber,),
//                         );
//                       }
//                                  ),
//                   ),
//                 ),
//               )
      
              
//             ],
//           ),
//         ),
//       ),
//     );
// //   }
// // }



