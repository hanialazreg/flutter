import 'package:community/pages/homePage.dart';
import 'package:community/pages/signup_page.dart';
import 'package:community/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);
  static const routeName = '/login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _authData = {
    'username': '',
    'password': '',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'User Name'),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some User Name';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authData['username'] = val;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty || value.length < 6) {
                      return 'Please enter some password';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authData['password'] = val;
                  },
                ),
                RaisedButton(
                  child: Text('Save'),
                  onPressed: () {
                    saveForm();
                  },
                ),
                RaisedButton(
                    child: Text('Create Account'),
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed(SignUp.routeName);
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveForm() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    print(_authData);
    try {
      await Provider.of<UserProvider>(context, listen: false)
          .login(_authData['username'], _authData['password']);
      Navigator.of(context).pushReplacementNamed(Home.routeName);
    } catch (e) {
      throw e;
    }

    // final userHeader = {"Content-type": "application/json"};
    // try {
    //   await http
    //       .post(new Uri.http("192.168.3.93:8080", "api/users/authenticate"),
    //           body: json.encode(bodyUser), headers: userHeader)
    //       .then((value) => print(json.decode(value.body)));
    // } catch (e) {
    //   print(e);
    // }
  }
}
