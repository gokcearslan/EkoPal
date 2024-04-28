import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekopal/login_page.dart';
import 'package:ekopal/main.dart';
import 'package:firebase_core/firebase_core.dart';
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


  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        backgroundColor: backgroundColor,  // Make sure this color is defined in your color resources
        body: FutureBuilder(
          future: Firebase.initializeApp(),  // Initialization of Firebase
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 23.0),
                    Container(
                      width: double.infinity,
                      child: const Text(
                        'Hesap Oluşturun',
                        style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    const Text(
                      'Devam etmek için lütfen okul mailiniz ile hesap oluşturun',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: textColor,  // Ensure textColor is defined
                      ),
                    ),
                    Image.network(
                      'https://i.pinimg.com/564x/d6/3d/95/d63d95bd2b5d0db1f114384b089451ce.jpg',
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height * 0.39,
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Form(
                        key: _registerFormKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameTextController,
                              focusNode: _focusName,
                              validator: (value) => Validator.validateName(name: value ?? ''),
                              decoration: InputDecoration(
                                labelText: "İsim Soyisim",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: kahve),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: kahve),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              controller: _emailTextController,
                              focusNode: _focusEmail,
                              validator: (value) => Validator.validateEmail(email: value ?? ''),
                              decoration: InputDecoration(
                                labelText: "Okul Maili",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: kahve),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: kahve),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              controller: _passwordTextController,
                              focusNode: _focusPassword,
                              obscureText: true,
                              validator: (value) => Validator.validatePassword(password: value ?? ''),
                              decoration: InputDecoration(
                                labelText: "Şifre",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: kahve),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: kahve),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            SizedBox(
                              width: double.infinity,  // Makes the button full width
                              child: ElevatedButton(
                                onPressed: register,
                                child: Text(
                                  'KAYDOL VE GİRİŞ YAP',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonColor,  // Use the same background color variable as in the login page
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),  // Consistent border radius with the login page
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 15),  // Optional: Adjusts the vertical padding
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Zaten bir hesabınız var mı? ',
                                  style: TextStyle(
                                    color: textColor,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => LoginPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Giriş Yapın.',
                                    style: TextStyle(
                                      color: Colors.blue,  // Replace with your preferred color, e.g., kahve if you have such a color
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }


}


