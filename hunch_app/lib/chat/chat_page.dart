import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hunch_app/chat/Chatpage.dart';
import 'package:hunch_app/chat_bubble.dart';
import 'package:hunch_app/chat/chat_service.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key, required this.Remail, required this.Rid,required this.imgUrl});
  final Remail;
  final imgUrl;
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
            // Container(
            //   alignment: align,
            //   child: Text(
            //     data['senderEmail'].toString(),
            //     style: GoogleFonts.ubuntu(color: Colors.black),
            //   ),
            // ),
            Container(
                alignment: Alignment.center,
                width: w * 0.5,
                decoration: BoxDecoration(
                    borderRadius: kk
                        ? BorderRadius.only(
                            bottomLeft: Radius.circular(23),
                            topLeft: Radius.circular(23))
                        : BorderRadius.only(
                            bottomRight: Radius.circular(23),
                            topRight: Radius.circular(23)),
                    color: Color.fromARGB(255, 240, 208, 160)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 1),
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
            hintText: 'Send Message',
            focusColor: Colors.black,
            hoverColor: Colors.black,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(23)),
            suffixIcon: IconButton(
                onPressed: () => send(), icon: Icon(Icons.send_rounded))),
      ),
    );
  }
}

