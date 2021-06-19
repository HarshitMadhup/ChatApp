import 'dart:io';

import 'package:flutter/material.dart';

import '../widgets/user_imagepicker.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String userName,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("hey-chat.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
      Container(
        height: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(begin: Alignment.topLeft, colors: [
              Colors.white,
              // Colors.white,
              Colors.white,
              Colors.white,
              Colors.blue[100],
              Colors.blue[50]
            ])),
        child: SingleChildScrollView(
          child: Column(children: [
            Row(children: [
              Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  margin: EdgeInsets.fromLTRB(10, 30, 0, 0),
                  padding: EdgeInsets.all(20),
                  child: Text("Secure Chat",
                      style: GoogleFonts.lato(
                          textStyle: TextStyle(
                              shadows: [
                            Shadow(
                              blurRadius: 7,
                              color: Colors.grey,
                            )
                          ],
                              fontSize: 80,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500)))),
              Container(
                  alignment: Alignment.bottomLeft,
                  // decoration: new BoxDecoration(
                  //     image: new DecorationImage(
                  //         image: new AssetImage("app.png"), fit: BoxFit.cover)),
                  width: 70,
                  child: Image.asset(
                    "app.png",
                    alignment: Alignment.bottomLeft,
                    fit: BoxFit.cover,
                  ))
            ]),
            // _isLogin
            //     ? Container(
            //         height: 70,
            //         child: Image(
            //           image: AssetImage('lib/3394897.jpg'),
            //           fit: BoxFit.scaleDown,
            //         ),
            //       )
            //     : Container(),
            Container(
              height: 500,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      gradient:
                          LinearGradient(begin: Alignment.center, colors: [
                        Colors.blue[50],
                        Colors.blue[50],
                        // // Colors.white,
                        // Colors.white,
                        // Colors.white,
                      ]),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset.zero,
                            spreadRadius: 0,
                            blurRadius: 20,
                            color: Colors.blue[900])
                      ]),
                  margin: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            if (!_isLogin) UserImagePicker(_pickedImage),
                            TextFormField(
                              key: ValueKey('email'),
                              validator: (value) {
                                if (value.isEmpty || !value.contains('@')) {
                                  return 'Please enter a valid email address.';
                                }
                                return null;
                              },
                              autocorrect: false,
                              strutStyle: StrutStyle(fontSize: 10),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  labelText: 'Email address',
                                  labelStyle: GoogleFonts.lato(
                                    textStyle: TextStyle(),
                                  )),
                              onSaved: (value) {
                                _userEmail = value;
                              },
                            ),
                            if (!_isLogin)
                              TextFormField(
                                key: ValueKey('username'),
                                validator: (value) {
                                  if (value.isEmpty || value.length < 4) {
                                    return 'Please enter at least 4 characters';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: 'Username',
                                    labelStyle: GoogleFonts.lato(
                                      textStyle: TextStyle(),
                                    )),
                                onSaved: (value) {
                                  _userName = value;
                                },
                              ),
                            TextFormField(
                              key: ValueKey('password'),
                              validator: (value) {
                                if (value.isEmpty || value.length < 7) {
                                  return 'Password must be at least 7 characters long.';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: GoogleFonts.lato(
                                    textStyle: TextStyle(),
                                  )),
                              obscureText: true,
                              onSaved: (value) {
                                _userPassword = value;
                              },
                            ),
                            SizedBox(height: 12),
                            if (widget.isLoading) CircularProgressIndicator(),
                            if (!widget.isLoading)
                              RaisedButton(
                                child: Text(_isLogin ? 'Login' : 'Signup'),
                                onPressed: _trySubmit,
                              ),
                            if (!widget.isLoading)
                              FlatButton(
                                textColor: Theme.of(context).primaryColor,
                                child: Text(_isLogin
                                    ? 'Create new account'
                                    : 'I already have an account'),
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    ]);
  }
}
