import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:direct_select/direct_select.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/page/teacher/schedule_page.dart';
import 'package:learn_flutter/services/material_services.dart';
import 'package:learn_flutter/services/schedule_services.dart';

class AddMaterialPage extends StatefulWidget {
  FirebaseUser user;
  final String a;
  final String spr;

  AddMaterialPage({this.user, this.a, this.spr});

  @override
  _AddMaterialPageState createState() => _AddMaterialPageState(user: user, a: a, spr: spr);
}

class _AddMaterialPageState extends State<AddMaterialPage> {
  FirebaseUser user;
  final String a;
  final String spr;

  _AddMaterialPageState({this.user, this.a, this.spr});

  TextEditingController lessonController = TextEditingController(text: " ");
  TextEditingController materialNameController =
      TextEditingController(text: " ");
  TextEditingController materialController = TextEditingController(text: " ");

  dynamic data;
  var selectedSuper;

  Future<dynamic> getData() async {
    final DocumentReference document =
        Firestore.instance.collection("users").document(user.uid);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        data = snapshot.data;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Input RPP"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 100.0),
              width: 300,
              height: 70,
              child: TextField(
                decoration: new InputDecoration(labelText: "Mata Pelajaran"),
                controller: lessonController,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              width: 300,
              height: 70,
              child: TextField(
                decoration: InputDecoration(labelText: 'Materi'),
                controller: materialNameController,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              width: 300,
              height: 70,
              child: TextField(
                decoration: InputDecoration(labelText: 'Link Document'),
                controller: materialController,
              ),
            ),
            RaisedButton(
                child: Text('Tambahkan'),
                onPressed: () async {
                  await MaterialServices.createMaterial(lessonController.text.trim(), materialNameController.text.trim(), DateTime.now(), materialController.text.trim(), data['name'], "NOT APPROVED", "tidak ada komentar", spr );
                  await ScheduleServices.inputedData(a);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => SchedulePage(this.user)));
                }
            )
          ],
        ),
      ),
    );
  }
}
