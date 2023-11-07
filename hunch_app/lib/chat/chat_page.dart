import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hunch_app/chat/Chatpage.dart';
import 'package:hunch_app/chat_bubble.dart';
import 'package:hunch_app/chat/chat_service.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key, required this.Remail, required this.Rid,required this.imgUrl, this.senderUrl});
  final Remail;
  final imgUrl;
  final Rid;
  final senderUrl;
  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {

  String? senderUrl;
  // final _messageController = TextEditingController();
  // final auth = FirebaseAuth.instance;


  //  @override
  // void initState() {
  //   super.initState();
  //   // Fetch the sender's image URL when the widget is initialized
  //   getImageUrlForUser().then((url) {
  //     setState(() {
  //       senderUrl = url;
  //     });
  //   });
  // }


    @override
  void initState() {
    super.initState();
    // Fetch the sender's image URL when the widget is initialized
    getImageUrlForUser().then((url) {
      if (url != null) {
        setState(() {
          senderUrl = url;
        });
      } else {
        // Handle the case when the sender's image URL is null or not found
        // You can set a default image or display an error message here
      }
    });
  }





  Future<String?> getImageUrlForUser() async {
    final em = FirebaseAuth.instance.currentUser!.email.toString();

    final userSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: em)
        .get();

    if (userSnapshot.docs.isNotEmpty) {
      final userData = userSnapshot.docs.first.data() as Map<String, dynamic>;

      final imageUrl = userData['imgUrl'] as String?;
      print(imageUrl);
      return imageUrl;
    } else {
      // Handle the case when the user's document is not found
      return null;
    }
  }





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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Container(
        child: Column(
          children: [
            // Container(
            //   alignment: align,
            //   child: Text(
            //     data['senderEmail'].toString(),
            //     style: GoogleFonts.ubuntu(color: Colors.black),
            //   ),
            // ),
            // Row(
            //   children: Column(
            //     children: [
            //       Container(
            //         alignment: Alignment.center,
            //         width: w * 0.5,
            //         decoration: BoxDecoration(
            //             borderRadius: kk
            //                 ? BorderRadius.only(
            //                     bottomLeft: Radius.circular(23),
            //                     topLeft: Radius.circular(23))
            //                 : BorderRadius.only(
            //                     bottomRight: Radius.circular(23),
            //                     topRight: Radius.circular(23)),
            //             color: Color.fromARGB(255, 240, 208, 160)),
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 1),
            //           child: Column(
            //             children: [
            //               Text(
            //               data['message'],
            //               style: GoogleFonts.ubuntu(fontSize: 20),
            //             ),
            //             ]
            //           ),
            //         ),
            //         ),
            //     ]
            //   ),
            // )
            
             data['senderId'] == auth.currentUser!.uid?
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
        alignment: Alignment.center,
        width: w * 0.5,
        decoration: BoxDecoration(
          // borderRadius: kk
          //     ? BorderRadius.only(
          //         bottomLeft: Radius.circular(23),
          //         topLeft: Radius.circular(23))
          //     : BorderRadius.only(
          //         bottomRight: Radius.circular(23),
          //         topRight: Radius.circular(23)),
          // color: Color.fromARGB(255, 240, 208, 160),
          border: 
          Border.all( color: const Color.fromARGB(255, 244, 209, 163)


          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
            topLeft: Radius.circular(12),

            
          ),
          color: Color.fromARGB(255, 244, 219, 186)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 1),
          child: Column(
            children: [
              Text(
                data['message'],
                style: GoogleFonts.ubuntu(fontSize: 20),
              ),
            ],
          ),
        ),
          ),
      
           Container(
                  margin: EdgeInsets.only(bottom: 20, left: 5),
                  child: CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage(widget.senderUrl),
                  ),
      
                )
        ],
      ): Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 40, right: 5),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundImage: NetworkImage(widget.imgUrl),
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                                alignment: Alignment.center,
                                width: w * 0.5,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color.fromARGB(255, 214, 212, 212)),
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                    ),
                                    color: align == Alignment.centerLeft
                                        ? Color.fromARGB(255, 201, 237, 219)
                                        : Color.fromARGB(255, 221, 187, 134)),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    data['message'],
                                    style: GoogleFonts.roboto(fontSize: 20),
                                  ),
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Container(
                                //   alignment: Alignment.centerLeft,
      
                                //   width: w * 0.7,
                                //   // color: Colors.amber,
                                //   child: Text(
                                //     data['date']
                                //         .toString()
                                //         .split(' ')[1]
                                //         .replaceFirst('-', ':')
                                //         .toString(),
                                //     style: GoogleFonts.poppins(
                                //         fontSize: 10,
                                //         color: Colors.grey.shade600),
                                //   ),
                                // ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
      
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     Container(
                //       alignment: Alignment.centerRight,
                //       width: w*0.6,
                //       child: Text(
                //         data['data'].toString().split(' ')[1]
                //         .toString()
                //         .replaceFirst('-', ':')
                //       ),
      
                //     )
                //   ],
                // ),
               
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

