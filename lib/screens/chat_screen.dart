import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String title;
  ChatScreen({required this.chatId, required this.title});
  @override _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  late final ChatService _chatService;
  @override
  void initState() {
    super.initState();
    _chatService = ChatService();
  }
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'anon';
    return Scaffold(appBar: AppBar(title: Text(widget.title)), body: Column(children: [
      Expanded(child: StreamBuilder<QuerySnapshot>(stream: _chatService.messagesStream(widget.chatId), builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        final docs = snapshot.data!.docs;
        return ListView.builder(itemCount: docs.length, itemBuilder: (context, index) {
          final m = docs[index].data() as Map<String, dynamic>;
          final isMe = m['uid'] == uid;
          return Align(alignment: isMe ? Alignment.centerRight : Alignment.centerLeft, child: Container(margin: EdgeInsets.all(8), padding: EdgeInsets.all(12), decoration: BoxDecoration(color: isMe ? Colors.deepPurple[300] : Colors.grey[200], borderRadius: BorderRadius.circular(12)), child: Text(m['text'] ?? '')));
        });
      })),
      Padding(padding: EdgeInsets.all(8), child: Row(children: [
        Expanded(child: TextField(controller: _controller, decoration: InputDecoration(hintText: 'Type a message'))),
        IconButton(icon: Icon(Icons.send), onPressed: () {
          final text = _controller.text.trim();
          if (text.isEmpty) return;
          _chatService.sendMessage(widget.chatId, {'text': text, 'uid': FirebaseAuth.instance.currentUser?.uid ?? 'anon', 'timestamp': FieldValue.serverTimestamp()});
          _controller.clear();
        })
      ]))
    ]));
  }
}
