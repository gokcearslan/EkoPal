import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ekopal/colors.dart';
import 'package:ekopal/validator.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Şifreni Sıfırla!',
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
              SizedBox(height:15),
              Container(
                width: double.infinity,
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'E-posta adresi boş olamaz';
                    }
                    return Validator.validateEmail(email: value);
                  },
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Şifrenizi sıfırlamak için mail adresinizi giriniz.',
                    labelText: 'E-posta Adresiniz',
                    labelStyle: TextStyle(
                      fontSize: 20,
                      color: textColor,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: textColor,
                    ),
                    fillColor: backgroundColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                  ),
                ),
              ),
              SizedBox(height: 60),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _isProcessing = true;
                    });
                    try {
                      await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: _emailController.text,
                      );
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Şifre Sıfırlama İsteği Gönderildi'),
                          content: Text(
                            'E-posta adresinize şifre sıfırlama talimatları gönderildi. Lütfen e-postanızı kontrol edin.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: Text('Tamam'),
                            ),
                          ],
                        ),
                      );
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Hata'),
                          content: Text('Şifre sıfırlama isteği gönderilemedi: $e'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Tamam'),
                            ),
                          ],
                        ),
                      );
                    } finally {
                      setState(() {
                        _isProcessing = false;
                      });
                    }
                  }
                },
                child: _isProcessing
                    ? CircularProgressIndicator(color: bej)
                    : Text('Şifre Sıfırlama Talebi Gönder'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: backgroundColor,
                  foregroundColor: textColor,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  elevation: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}