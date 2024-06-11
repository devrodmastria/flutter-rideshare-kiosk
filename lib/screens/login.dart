import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firebase = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // key holds form data
  var _isLoginMode = true;
  var _newEmail = '';
  var _newPwd = '';
  var _creatingUser = false;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid || !_isLoginMode) {
      // show error message
      return;
    }

    _formKey.currentState!.save();

    try {
      setState(
        () {
          _creatingUser = true;
        },
      );
      if (_isLoginMode) {
        await _firebase.signInWithEmailAndPassword(
            email: _newEmail, password: _newPwd);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _newEmail, password: _newPwd);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'email': _newEmail,
        });
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email' || err.code == 'email_already_in_use') {
        // email is taken/invalid
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.message ?? 'Login denied')));

      setState(
        () {
          _creatingUser = false;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade400,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                width: 200,
                child: const Icon(Icons.chat_bubble_outline_sharp),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter valid email';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _newEmail = newValue!;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            style: const TextStyle(color: Colors.white),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password min length is 6 digits';
                              }
                              return null;
                            },
                            onSaved: (newValue) {
                              _newPwd = newValue!;
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          if (_creatingUser) const CircularProgressIndicator(),
                          if (!_creatingUser)
                            ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer),
                                child: Text(_isLoginMode ? 'Login' : 'Signup')),
                          if (!_creatingUser)
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLoginMode = !_isLoginMode;
                                  });
                                },
                                child: Text(_isLoginMode
                                    ? 'Create account'
                                    : 'Login with my account'))
                        ],
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
