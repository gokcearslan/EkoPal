import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ekopal/HomePage.dart';
import 'package:ekopal/colors.dart';
import 'package:ekopal/register_page.dart';
import 'package:ekopal/reset_password_page.dart'; // Import the reset password page
import 'package:ekopal/validator.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
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

  Future<void> login() async {
    // Manually validate email and password
    String? emailError = Validator.validateEmail(email: _emailTextController.text);
    String? passwordError = Validator.validatePassword(password: _passwordTextController.text);

    // Check for email validation error
    if (emailError != null) {
      _showErrorDialog(emailError);
      return;
    }

    // Check for password validation error
    if (passwordError != null) {
      _showErrorDialog(passwordError);
      return;
    }

    // If no validation errors, proceed with Firebase authentication
    setState(() => _isProcessing = true);
    try {
      final auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(
        email: _emailTextController.text.trim(),
        password: _passwordTextController.text.trim(),
      );
      // Navigate to HomePage or handle successful login as needed
    } catch (e) {
      // Handle Firebase authentication errors
      _showErrorDialog("Authentication failed. Please try again.");
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mail Hatasi'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }





  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kahve, // Assuming 'kahve' is a defined color
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
            color: Colors.white,
          ),
          title: Text('Giriş Yap', style: TextStyle(color: Colors.white)),
        ),
        body: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Image.network(
                      'https://i.pinimg.com/564x/98/48/3e/98483e01c683158eac0e1153f5c38908.jpg',
                      fit: BoxFit.cover,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.4,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _emailTextController,
                              focusNode: _focusEmail,
                              validator: (value) =>
                                  Validator.validateEmail(email: value!),
                              decoration: InputDecoration(
                                hintText: "Okul Mail Adresiniz",
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: kahve),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            TextFormField(
                              controller: _passwordTextController,
                              focusNode: _focusPassword,
                              obscureText: true,
                              validator: (value) =>
                                  Validator.validatePassword(password: value!),
                              decoration: InputDecoration(
                                hintText: "Şifreniz",
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: kahve),
                                ),
                              ),
                            ),
                            SizedBox(height: 24.0),
                            _isProcessing
                                ? CircularProgressIndicator()
                                : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      // Manually call validation methods
                                      String? emailError = Validator.validateEmail(email: _emailTextController.text);
                                      String? passwordError = Validator.validatePassword(password: _passwordTextController.text);

                                      // Show the first error encountered in a popup dialog
                                      if (emailError != null) {
                                        _showErrorDialog(emailError);
                                      } else if (passwordError != null) {
                                        _showErrorDialog(passwordError);
                                      } else {
                                        // If no errors, proceed with the login
                                        await login();
                                      }
                                    },

                                    child: Text(
                                        'Giriş', style: TextStyle(color: bej)),
                                    // Assuming 'bej' is a defined color
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kahve,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 24.0),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegisterPage())),
                                    child: Text(
                                        'Kaydol', style: TextStyle(color: bej)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kahve,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            InkWell(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          ResetPasswordPage())),
                              child: Text(
                                'Şifremi Unuttum',
                                style: TextStyle(
                                  color: Colors.red,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
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
    );
  }
}


