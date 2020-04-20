import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:hello_world/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/auth.dart';
// import 'package:pantry/data/connect_repository.dart';

// import '../data/connect_repository.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  static const routeName = '/auth';
  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 3000);
  final Auth auth = new Auth();

  @override
  Widget build(BuildContext context) {

    return FlutterLogin(
      title: 'pantryio',
      messages: LoginMessages(
          usernameHint: 'Username',
          passwordHint: 'Password',
          confirmPasswordHint: 'Confirm password',
          loginButton: 'LOG IN',
          signupButton: 'REGISTER',
          goBackButton: 'GO BACK',
          confirmPasswordError: 'Passwords do not match!',
          // forgotPasswordButton: "The connection to the backend API is not secure.  Do not enter sensitive information."
          ),
      emailValidator: (value) {
        if (value.length < 1) {
          return "Username must not be blank";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value.isEmpty) {
          return 'Please enter a password';
        }
        /*if (value.length < 8) {
          return 'Your password must contain at least 8 characters.';
          // ignore: missing_return
        }*/
        return null;
      },
      onRecoverPassword: (_) => Future(null),
      onLogin: (loginData) async {
        print('Login info');
        print('email: ${loginData.name.trim()}');
        print('password: ${loginData.password}');
        var uid = await auth.login(loginData.name.trim(),loginData.password);
        print('uid done');
        // await _storeUID(uid);
        // print('store uid done');
        return uid;
      },
      onSubmitAnimationCompleted: () {
        // return null;
        // Navigator.of(context).pushReplacement(FadePageRoute(
        //   builder: (context) => HomePage(),
        // ));
        print('changing route');
        _loginSuccess(context);
      },
      onSignup: (loginData) async {
        print('Signup info');
        print('email: ${loginData.name.trim()}');
        print('password: ${loginData.password}');
        var uid = await auth.register(loginData.name.trim(),loginData.password);
        // await _storeUID(uid);
        return uid;
      },
      showDebugButtons: false,
    );
  }

  

  _loginSuccess(BuildContext context){
    // Navigator.of(context).pushReplacement(MaterialPageRoute(
    //       builder: (context) => HomePage(),
    //     ));
    Navigator.of(context).pushReplacementNamed('/admin');
  }
}
