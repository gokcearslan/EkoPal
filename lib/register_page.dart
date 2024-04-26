import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekopal/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ekopal/HomePage.dart';
import 'package:ekopal/colors.dart';
import 'package:ekopal/services/fire_auth.dart';
import 'package:ekopal/validator.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  Future<void> register() async {
    if (_registerFormKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });

      String role = _emailTextController.text.endsWith('@ieu.edu.tr') ? 'staff' : 'student';

      User? user = await FireAuth.registerUsingEmailPassword(
        name: _nameTextController.text,
        email: _emailTextController.text,
        password: _passwordTextController.text,
        role: role, // Pass the determined role
      );

      setState(() {
        _isProcessing = false;
      });
        // Navigate to the home page or any other page after successful registration
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => MainApp(),
          ),
          ModalRoute.withName('/'),
        );

    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Kaydol',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: kahve,
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _registerFormKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _nameTextController,
                          focusNode: _focusName,
                          validator: (value) =>
                              Validator.validateName(name: _nameTextController.text),
                          decoration: InputDecoration(
                            hintText: "İsim Soyisim",
                            fillColor: somon.withOpacity(0.1),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: acikSari),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _emailTextController,
                          focusNode: _focusEmail,
                          validator: (value) =>
                              Validator.validateEmail(email: _emailTextController.text),
                          decoration: InputDecoration(
                            hintText: "Okul Maili",
                            fillColor: somon.withOpacity(0.1),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: acikSari),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: _passwordTextController,
                          focusNode: _focusPassword,
                          obscureText: true,
                          validator: (value) =>
                              Validator.validatePassword(password: _passwordTextController.text),
                          decoration: InputDecoration(
                            hintText: "Şifre",
                            fillColor: somon.withOpacity(0.1),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: acikSari),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        SizedBox(height: 32.0),
                        _isProcessing
                            ? CircularProgressIndicator()
                            : Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: register,
                                child: Text(
                                  'Kaydol ve Giriş yap',
                                  style: TextStyle(color: bej),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kahve,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
