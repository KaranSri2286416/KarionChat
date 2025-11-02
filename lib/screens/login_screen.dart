import 'package:flutter/material.dart';
import 'profile_setup.dart';
import 'chat_list.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  String? _verificationId;
  final _codeController = TextEditingController();
  bool _codeSent = false;

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset('assets/logo.png', height: 120),
            SizedBox(height: 20),
            Text('Karion Chat', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            TextField(controller: _phoneController, decoration: InputDecoration(labelText: 'Phone (eg +9199...)'), keyboardType: TextInputType.phone),
            SizedBox(height: 12),
            if (!_codeSent)
              ElevatedButton(onPressed: () async {
                final phone = _phoneController.text.trim();
                if (phone.isEmpty) return;
                await auth.signInWithPhone(phone, (verId) {
                  setState(() { _verificationId = verId; _codeSent = true; });
                }, (err) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err))); });
              }, child: Text('Send Code')),
            if (_codeSent)
              Column(children: [
                TextField(controller: _codeController, decoration: InputDecoration(labelText: 'SMS Code')),
                SizedBox(height: 8),
                ElevatedButton(onPressed: () async {
                  await auth.verifySms(_verificationId!, _codeController.text.trim());
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfileSetup()));
                }, child: Text('Verify'))
              ])
          ]),
        ),
      ),
    );
  }
}
