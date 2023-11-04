import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hunch_app/Chatpage.dart';
import 'package:hunch_app/chat_bubble.dart';
import 'package:hunch_app/chat_service.dart';


// class ChatPage extends StatefulWidget {

//     final String receiverUserEmail;
//   final String receiverUserID;
//   const ChatPage({
//   Key? key,
//   required this.receiverUserEmail,
//   required this.receiverUserID,
// }) : super(key: key);




//   // const ChatPage({
//   //   super.key, 
//   //   required this.receiverUserEmail,
//   //   required this.receiverUserID,
//   //   });

  

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {

//   final TextEditingController _messageController = TextEditingController();
//   final ChatService _chatService = ChatService();
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   void sendMessage() async {
//     //only send messag. if something send
//     if (_messageController.text.isNotEmpty){
//       await _chatService.sendMessage(
//         widget.receiverUserID, _messageController.text);

//         _messageController.clear();
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
      
//       appBar: AppBar(
//         title: Text(widget.receiverUserEmail)
//       ),
//       body: Column(
//         children: [
//           // messages 
//           Expanded(
//             child: _buildMessageList(),
//             ),
            
            
//              //user input
//             _buildMessageInput(),

//             const SizedBox(height: 25,)
//         ],
//       ),
//     );
//   }

//   //build message list
//   Widget _buildMessageList(){
//     return StreamBuilder(
//       stream: _chatService.getMessages(
//         widget.receiverUserID, _firebaseAuth.currentUser!.uid),

//        builder: (context, snapshot){
//         if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         }

//         if (snapshot.connectionState == ConnectionState.waiting){
//           return const Text('Loading....');
//         }


//           // Print the data received from Firestore for debugging
//           print('Messages: ${snapshot.data!.docs}');
//         return ListView(
//           children: snapshot.data!.docs.map((document) => 
//           _buildMessageItem(document)).toList(),
//         );
//        }
//        );
//   }





//   // build message item
//   // Widget _buildMessageItem(DocumentSnapshot document){
//   //   Map<String, dynamic> data = document.data() as Map<String, dynamic>;

//   //   var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
//   //   ? Alignment.centerRight
//   //   : Alignment.centerLeft;

//   //   return Container(
//   //     alignment: alignment,
//   //     child: Padding(
//   //       padding:  const EdgeInsets.all(8.0),
//   //       child: Column(
//   //         crossAxisAlignment: 
//   //         (data['senderId'] == _firebaseAuth.currentUser!.uid)
//   //              ? CrossAxisAlignment.end
//   //              :CrossAxisAlignment.start,
//   //              mainAxisAlignment: 
//   //              (data['senderId'] == _firebaseAuth.currentUser!.uid)
//   //              ?MainAxisAlignment.end
//   //              :MainAxisAlignment.start,
//   //         children: [
//   //         Text(data['senderEmail'],style: TextStyle( color: Colors.black),),
//   //         const SizedBox(height: 5,),
//   //         ChatBubble(message: data['message']),
//   //       ],
//   //       ),
//   //     ),
//   //   );

//   // }

//   Widget _buildMessageItem(DocumentSnapshot document) {
//   Map<String, dynamic> data = document.data() as Map<String, dynamic>;

//   var isSentMessage = (data['senderId'] == _firebaseAuth.currentUser!.uid);

//   return Align(
//     alignment: isSentMessage ? Alignment.centerRight : Alignment.centerLeft,
//     child: Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: isSentMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           if (!isSentMessage)
//             Text(data['senderEmail'], style: TextStyle(color: Colors.black)),
//           const SizedBox(height: 5,),
//           ChatBubble(message: data['message']),
//         ],
//       ),
//     ),
//   );
// }






//   // build message input
//   Widget _buildMessageInput(){
//     return Row(
//       children: [
//         Expanded(
//           child: TextField(
//             controller: _messageController,
//            decoration: InputDecoration(
//              hintText: 'Enter message',
//            ),
//             obscureText: false,


//           )
//           ),

//           //button
//           IconButton(onPressed: sendMessage, 
//           icon: const Icon(Icons.arrow_upward,
//           size: 40,
//           )
//           )
//       ],
//     );
//   }



// }


class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key, required this.Remail, required this.Rid});
  final Remail;
  final Rid;
  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  final _messageController = TextEditingController();
  final chatService = ChatService();
  final auth = FirebaseAuth.instance;
  void send() {
    if (_messageController.text.isNotEmpty) {
      chatService.sendMessage(widget.Rid, _messageController.text.toString());
    }
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.Remail.toString().split('@')[0],
              style:
                  GoogleFonts.ubuntu(fontSize: 23, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: builderMessage(),
          )),
          input(),
        ],
      ),
    );
  }

  Widget builderMessage() {
    return StreamBuilder(
      stream: chatService.getMessages(widget.Rid, auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
              
            ),
          );
        }
        print('tolist');
        return ListView(
            reverse: true,
            physics: BouncingScrollPhysics(),
            children:
                snapshot.data!.docs.map((e) => messages(e, context)).toList());
      },
    );
  }

  Widget messages(DocumentSnapshot docsss, context) {
    final w = MediaQuery.sizeOf(context).width;
    Map<String, dynamic> data = docsss.data() as Map<String, dynamic>;
    print(data['senderId']);
    var align = (data['senderId'] == auth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    final kk = (data['senderId'] == auth.currentUser!.uid);
    return Container(
      alignment: align,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Column(
          children: [
            Container(
              alignment: align,
              child: Text(
                data['senderEmail'].toString(),
                style: GoogleFonts.ubuntu(color: Colors.black),
              ),
            ),
            Container(
                alignment: Alignment.center,
                width: w * 0.7,
                decoration: BoxDecoration(
                    borderRadius: kk
                        ? BorderRadius.only(
                            bottomLeft: Radius.circular(23),
                            topLeft: Radius.circular(23))
                        : BorderRadius.only(
                            bottomRight: Radius.circular(23),
                            topRight: Radius.circular(23)),
                    color: Colors.orange.shade100),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    data['message'],
                    style: GoogleFonts.ubuntu(fontSize: 20),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget input() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: _messageController,
        decoration: InputDecoration(
            suffixIconColor: Colors.black,
            hintText: 'Message',
            focusColor: Colors.black,
            hoverColor: Colors.black,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(23)),
            suffixIcon: IconButton(
                onPressed: () => send(), icon: Icon(Icons.send_rounded))),
      ),
    );
  }
}

