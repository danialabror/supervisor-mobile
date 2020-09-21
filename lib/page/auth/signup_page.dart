import 'package:flutter/material.dart';
import 'package:learn_flutter/services/auth_services.dart';

import '../../main.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar user"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 170.0),
              width: 300,
              height: 100,
              child: TextField(
                decoration: InputDecoration(hintText: 'email'),
                controller: emailController,
              ),
            ),
            Container(
              width: 300,
              height: 100,
              child: TextField(
                decoration: InputDecoration(hintText: 'password'),
                controller: passwordController,
              ),
            ),
            RaisedButton(
              child: Text('Sign Up'),
              onPressed: () async {
                await AuthServices.signUp(
                    emailController.text.trim(),
                    passwordController.text.trim());

                await AuthServices.signOut();
              }
            )
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {
          await AuthServices.signOut();
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MyApp()));
        },
        tooltip: 'Increment',
        child: new Icon(Icons.power_settings_new),
      ),
    );
  }
}
