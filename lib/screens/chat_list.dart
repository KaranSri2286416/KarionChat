import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chats')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chats').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          return ListView.builder(itemCount: docs.length, itemBuilder: (context, index) {
            final d = docs[index];
            return ListTile(leading: CircleAvatar(child: Icon(Icons.person)), title: Text(d['title'] ?? 'Chat'), subtitle: Text(d['lastMessage'] ?? ''), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(chatId: d.id, title: d['title'] ?? 'Chat'))));
          });
        },
      ),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.chat), onPressed: (){}),
    );
  }
}
