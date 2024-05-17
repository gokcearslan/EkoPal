import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ekopal/colors.dart'; // Import your color constants
import 'package:ekopal/validator.dart'; // Import your validator class

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Şifre Değiştir',
          style: TextStyle(
            fontSize: 26,
          ),
        ),
        centerTitle: true,
        backgroundColor: appBarColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 15),
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mevcut şifre boş olamaz';
                  }
                  // Add more validation logic if needed
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Mevcut şifrenizi giriniz',
                  labelText: 'Mevcut Şifre',
                  fillColor: backgroundColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelStyle: TextStyle(fontSize: 20, color: textColor),
                  hintStyle: TextStyle(fontSize: 15, color: textColor),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Yeni şifre boş olamaz';
                  }
                  // Add more validation logic if needed
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Yeni şifrenizi giriniz',
                  labelText: 'Yeni Şifre',
                  fillColor: backgroundColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelStyle: TextStyle(fontSize: 20, color: textColor),
                  hintStyle: TextStyle(fontSize: 15, color: textColor),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                ),
              ),
              SizedBox(height: 60),
              ElevatedButton(
                onPressed: _isProcessing ? null : _changePassword,
                child: _isProcessing
                    ? CircularProgressIndicator(color: bej)
                    : Text('Şifreyi Değiştir'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor, // Use background color for the button
                  foregroundColor: textColor, // Use text color for the button text
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  elevation: 10, // Add shadow depth
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!,
            password: _currentPasswordController.text,
          );
          await user.reauthenticateWithCredential(credential);
          await user.updatePassword(_newPasswordController.text);
          Navigator.of(context).pop(); // Assume success and pop the screen
        }
      } catch (e) {
        // Handle exceptions
      } finally {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
}
