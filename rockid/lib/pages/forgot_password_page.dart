import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/my_textfield.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future ResetPAssword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The email has been succesfully sent')),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 237, 223),
      appBar: AppBar(
        title: Text(
          'Forgot Password',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
        actions: [],
        backgroundColor: Colors.brown,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Please enter your email to recieve a reset password link",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.brown),
            ),
            SizedBox(height: 16.0),
            MyTextField(
              controller: _emailController,
              hintText: 'Email',
              obscureText: false,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                ResetPAssword();
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(180, 50),
                backgroundColor: Colors.brown,
              ),
              child: Text(
                'Reset Password',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
