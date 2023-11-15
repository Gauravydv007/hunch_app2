import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  const Message({Key ? key}): super(key: key);

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Message'),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: (){
              Navigator( );

            },
            child: Icon(Icons.add),
          ),
          SizedBox(width: 20,)
        ],
      ),

      body: Column(
        children: [



        ],
      ),
    );
  }
}