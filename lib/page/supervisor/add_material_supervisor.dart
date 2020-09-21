import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:direct_select/direct_select.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/page/supervisor/schedule_supervisor.dart';
import 'package:learn_flutter/page/teacher/schedule_page.dart';
import 'package:learn_flutter/services/material_services.dart';
import 'package:learn_flutter/services/schedule_services.dart';

class AddMaterialSupervisorPage extends StatefulWidget {
  FirebaseUser user;
  final String a;

  AddMaterialSupervisorPage({this.user, this.a});

  @override
  _AddMaterialSupervisorPageState createState() => _AddMaterialSupervisorPageState(user: user, a: a);
}

class _AddMaterialSupervisorPageState extends State<AddMaterialSupervisorPage> {
  FirebaseUser user;
  final String a;

  _AddMaterialSupervisorPageState({this.user, this.a});

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
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('users')
                  .where('role', whereIn: ['SUPERVISOR', 'CURRICULUM'])
                  .snapshots(),
              // ignore: missing_return
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  Text("Loading...");
                } else {
                  List<DropdownMenuItem> superItems = [];
                  for (int i = 0; i < snapshot.data.documents.length; i++) {
                    DocumentSnapshot snap = snapshot.data.documents[i];
                    superItems.add(DropdownMenuItem(
                      child: Text(
                        "${snap['name']}",
                      ),
                      value: snap['name'],
                    ));
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Supervisor : "),
                      SizedBox(width: 50.0),
                      new DropdownButton(
                        items: superItems,
                        onChanged: (superValue) {
                          final snackBar = SnackBar(
                            content: Text("Selected Supervisor is ${superValue}"),
                          );
                          Scaffold.of(context).showSnackBar(snackBar);
                          setState(() {
                            selectedSuper = superValue;
                            print(selectedSuper);
                          });
                        },
                        value: selectedSuper,
                        isExpanded: false,
                        hint: new Text("Choose the Supervisor"),
                      )
                    ],
                  );
                }
              },
            ),
            RaisedButton(
                child: Text('Tambahkan'),
                onPressed: () async {
                  await MaterialServices.createMaterial(lessonController.text.trim(), materialNameController.text.trim(), DateTime.now(), materialController.text.trim(), data['name'], "NOT APPROVED", "tidak ada komentar", selectedSuper );
                  await ScheduleServices.inputedData(a);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ScheduleSupervisorPage(this.user)));
                }
            )
          ],
        ),
      ),
    );
  }
}
