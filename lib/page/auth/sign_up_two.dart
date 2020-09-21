import 'package:flutter/material.dart';
import 'package:learn_flutter/page/welcome_page.dart';
import 'package:learn_flutter/services/auth_services.dart';
import 'package:learn_flutter/services/database_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../main.dart';

class SignUpTwo extends StatelessWidget {

  final FirebaseUser user;

  SignUpTwo(this.user);

  List _roles = ["TEACHER", "SUPERVISOR", "CURRICULUM", "PRINCIPAL"];
    //==============================================================
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController roleController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Isi Identitas")),
      body: Center(
        child: Column(children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 170.0),
            width: 300,
            height: 100,
            child: TextField(
              decoration: InputDecoration(hintText: 'Full Name'),
              controller: nameController,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 170.0),
            width: 300,
            height: 100,
            child: TextField(
              decoration: InputDecoration(hintText: 'Your role'),
              controller: roleController,
            ),
          ),
          // DropdownButton(
          //   hint: Text("Your Role"),
          //   value: _valRole,
          //   items: _roles.map((value) {
          //     return DropdownMenuItem(
          //       child: Text(value),
          //       value: value,DAi
          //     );
          //   }).toList(),
          //   onChanged: (value) {
          //     setState();
          //   },
          // ),
          RaisedButton(
              child: Text('Selesai'),
              onPressed: () async {
                await DatabaseServices.createOrUpdateUser(user.uid, name: nameController.text.trim(), role: roleController.text.trim());
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Welcome(this.user)),
                );
              })
        ]),
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
