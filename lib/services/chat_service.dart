import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot> messagesStream(String chatId) {
    return _db.collection('chats').doc(chatId).collection('messages').orderBy('timestamp').snapshots();
  }

  Future<void> sendMessage(String chatId, Map<String,dynamic> message) async {
    await _db.collection('chats').doc(chatId).collection('messages').add(message);
  }
}
