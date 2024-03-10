import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ekopal/colors.dart'; // Import your color constants
import 'package:ekopal/validator.dart'; // Import your validator class

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
        backgroundColor: kahve,
        title: Text('Şifre Sıfırla'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'E-posta adresi boş olamaz';
                  }
                  return Validator.validateEmail(email: value);
                },
                decoration: InputDecoration(
                  labelText: 'E-posta Adresiniz',
                ),
              ),
              SizedBox(height: 20),
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
                  primary: kahve, // Set button color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
