import 'package:flutter/material.dart';
import 'chat_list.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileSetup extends StatefulWidget {
  @override _ProfileSetupState createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  final _nameController = TextEditingController();
  File? _imageFile;
  final _picker = ImagePicker();

  Future pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() { _imageFile = File(picked.path); });
  }

  Future uploadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    String? url;
    if (_imageFile != null && user != null) {
      final ref = FirebaseStorage.instance.ref().child('profiles/${user.uid}.jpg');
      await ref.putFile(_imageFile!);
      url = await ref.getDownloadURL();
    }
    if (user != null) {
      await FirebaseFirestore.instance.collection('profiles').doc(user.uid).set({
        'username': _nameController.text.trim(),
        'photoUrl': url ?? ''
      });
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ChatList()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Set up profile')), body: Padding(padding: EdgeInsets.all(16), child: Column(children: [
      GestureDetector(onTap: pickImage, child: CircleAvatar(radius: 48, backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null, child: _imageFile == null ? Icon(Icons.camera_alt) : null)),
      SizedBox(height: 12),
      TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Username')),
      Spacer(),
      ElevatedButton(onPressed: uploadProfile, child: Text('Save & Continue'))
    ])));
  }
}
