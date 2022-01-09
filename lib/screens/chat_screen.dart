import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}
  User loggedInUser;

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _store = FirebaseFirestore.instance;
  String messageText;
  final textController = TextEditingController();
  void getCurrentUser() async {
     try{
       final user = await _auth.currentUser;
       if(user != null){
         loggedInUser = user;
         print(loggedInUser.email);
       }

     }
     catch(e){
       print(e);
     }
  }

  void getMessagesStream() async {
    await for (var snapshot in _store.collection('messages').snapshots()){
      for(var messages in snapshot.docs){
        print(messages.data());
      }

    }
  }

  @override
  void initState(){
    super.initState();
    getCurrentUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // _auth.signOut();
                // Navigator.pop(context);
                getMessagesStream();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _store.collection('messages').snapshots(),
              builder: (context,snapshot){
                  List<MessageBubble> messagesWidgets = [];
                if(snapshot.hasData){
                  final messages = snapshot.data.docs.reversed;
                  for(var message in messages){
                    final  messageText = message.get('text');
                    final messageSender = message.get('sender');
                    final currentUser = loggedInUser.email;

                  final messageWidget = MessageBubble(messageSender: messageSender,messageText: messageText, isMe: currentUser == messageSender);
                  messagesWidgets.add(messageWidget);
                  }
                }
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      children: 
                      messagesWidgets
                    ),
                  );
                
              }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController,
                      style: TextStyle(color: Colors.black),
                      onChanged: (value) {
                        messageText = value;
                     
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _store.collection('messages').add({
                        'text' : messageText,
                        'sender' : loggedInUser.email
                      });
                       textController.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  
    final bool isMe;
    final messageText;
    final messageSender;

  const MessageBubble({this.messageText, this.messageSender, this.isMe});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
          crossAxisAlignment : isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(messageSender, style: TextStyle(color: Colors.black38)),
          Material(
            color: isMe ? Colors.blueAccent : Colors.white,
            borderRadius: isMe ? BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30),bottomRight:Radius.circular(30),): BorderRadius.only(topRight: Radius.circular(30), bottomLeft: Radius.circular(30),bottomRight:Radius.circular(30),),
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
              child: Text(messageText, style: TextStyle(color: isMe ? Colors.white : Colors.black)),
            )),
        ],
      ),
    );
      
    
  }
}