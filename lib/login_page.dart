import 'package:ekopal/main.dart';
import 'package:ekopal/services/UserManager.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ekopal/HomePage.dart';
import 'package:ekopal/colors.dart';
import 'package:ekopal/register_page.dart';
import 'package:ekopal/reset_password_page.dart';
import 'package:ekopal/validator.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  bool _isProcessing = false;
  String? _emailError;
  String? _passwordError;

  Future<void> login() async {
    setState(() => _isProcessing = true);
    _emailError = Validator.validateEmail(email: _emailTextController.text);
    _passwordError = Validator.validatePassword(password: _passwordTextController.text);

    if (_emailError != null || _passwordError != null) {
      setState(() => _isProcessing = false);
      return; // Stop the login process if there are validation errors
    }

    try {
      final auth = FirebaseAuth.instance;
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: _emailTextController.text.trim(),
        password: _passwordTextController.text.trim(),
      );

      if (userCredential.user != null) {
        await UserManager().login(userCredential.user!.uid); // Save user ID to UserManager and SharedPreferences
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MainApp()),
        );
      }
    } catch (e) {
      setState(() {
        _passwordError = "Şifreniz yanlış.";
        _isProcessing = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: FutureBuilder(
            future: Firebase.initializeApp(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.network(
                        'https://i.pinimg.com/564x/d6/3d/95/d63d95bd2b5d0db1f114384b089451ce.jpg',
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 0.36,
                      ),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: const Text(
                          'EKOPAL',
                          style: TextStyle(
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: Text(
                          'Devam etmek için lütfen hesap oluşturun',
                          style: TextStyle(
                            fontSize: 15,
                            color: textColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _emailTextController,
                                focusNode: _focusEmail,
                                validator: (value) => Validator.validateEmail(email: value ?? ''),
                                decoration: InputDecoration(
                                  labelText: "Okul Mail Adresiniz",
                                  errorText: _emailError,
                                  suffixIcon: PopupMenuButton<String>(
                                    onSelected: _appendDomain,
                                    color: backgroundColor,
                                    itemBuilder: (BuildContext context) {
                                      return <PopupMenuEntry<String>>[
                                        const PopupMenuItem<String>(
                                          value: '@std.ieu.edu.tr',
                                          child: Text('@std.ieu.edu.tr'),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: '@ieu.edu.tr',
                                          child: Text('@ieu.edu.tr'),
                                        ),
                                      ];
                                    },
                                    icon: Icon(Icons.arrow_drop_down),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(color: kahve),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                              ),
                              SizedBox(height: 20.0),
                              TextFormField(
                                controller: _passwordTextController,
                                focusNode: _focusPassword,
                                obscureText: true,
                                validator: (value) => Validator.validatePassword(password: value ?? ''),
                                decoration: InputDecoration(
                                  labelText: "Şifreniz",
                                  hintText: "Şifreniz",
                                  errorText: _passwordError,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(color: kahve),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(color: kahve),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              _isProcessing
                                  ? CircularProgressIndicator()
                                  : ElevatedButton(
                                onPressed: login,
                                child: Text('Giriş', style: TextStyle(color: Colors.white, fontSize: 22)),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 150), // Increase vertical padding
                                  backgroundColor: buttonColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              InkWell(
                                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResetPasswordPage())),
                                child: Text(
                                  'Şifremi Unuttum',
                                  style: TextStyle(
                                    color: Colors.red,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text('Hesabınız yok mu?', style: TextStyle(color: textColor)),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPage())),
                                    child: Text('Kaydolun.', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
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
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }


  void _appendDomain(String domain) {
    final currentText = _emailTextController.text;
    final atSymbolIndex = currentText.indexOf('@');

    if (atSymbolIndex == -1) {
      _emailTextController.text = '$currentText$domain';
    } else {
      final newText = currentText.substring(0, atSymbolIndex);
      _emailTextController.text = '$newText$domain';
    }
  }
}
