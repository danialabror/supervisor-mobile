import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:learn_flutter/services/schedule_services.dart';

class AddSchedulePage extends StatefulWidget {
  FirebaseUser user;

  AddSchedulePage(this.user);

  @override
  _AddSchedulePageState createState() => _AddSchedulePageState(this.user);
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  TextEditingController activityController = TextEditingController(text: '');
  FirebaseUser user;

  String _date;
  var selectedUser = null, selectedSuper, selectedType;

  _AddSchedulePageState(this.user);

  @override
  Stream dataList;

  // Stream dataListt;

  void initState() {
    dataList = Firestore.instance
        .collection('users')
        .where('role', isEqualTo: 'TEACHER')
        .snapshots();
    //
    // dataListt = Firestore.instance
    //     .collection('users')
    //     .where('role', isEqualTo: 'SUPERVISOR')
    //     .snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Jadwal'),
      ),
      body: Center(
          child: Column(children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 100.0),
          width: 300,
          height: 70,
          child: TextField(
            decoration: new InputDecoration(labelText: "Kegiatan / RPP"),
            controller: activityController,
          ),
        ),
        FlatButton(
            onPressed: () {
              DatePicker.showDateTimePicker(context,
                  showTitleActions: true,
                  minTime: DateTime.now(),
                  maxTime: DateTime(2020, 12, 12), onChanged: (date) {
                print('change $date');
              }, onConfirm: (date) {
                print('confirm $date');
                _date = '$date';
              }, currentTime: DateTime.now(), locale: LocaleType.en);
            },
            child: Text(
              'Pilih Waktu / Deadline',
              style: TextStyle(color: Colors.blue),
            )),
        StreamBuilder<QuerySnapshot>(
          stream: dataList,
          // ignore: missing_return
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              Text("tidak ada data");
            } else {
              List<DropdownMenuItem> userItems = [];
              for (int i = 0; i < snapshot.data.documents.length; i++) {
                DocumentSnapshot snap = snapshot.data.documents[i];
                userItems.add(DropdownMenuItem(
                  child: Text(
                    snap['name'],
                  ),
                  value: snap['name'],
                ));
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Guru : "),
                  SizedBox(width: 70.0),
                  DropdownButton(
                    items: userItems,
                    onChanged: (userValue) {
                      final snackBar = SnackBar(
                        content: Text("Selected Teacher is ${userValue}"),
                      );
                      Scaffold.of(context).showSnackBar(snackBar);
                      setState(() {
                        selectedUser = userValue;
                        print(snapshot.data.documents.length);
                      });
                    },
                    value: selectedUser,
                    isExpanded: false,
                    hint: new Text("Choose the teacher"),
                  )
                ],
              );
            }
          },
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
              await ScheduleServices.addSchedule(
                  activityController.text.trim(),
                  DateTime.parse(_date),
                  "NOT FINISHED",
                  selectedUser,
                  selectedSuper);
              Navigator.pop(context);
            }),
      ])),
    );
  }
}
