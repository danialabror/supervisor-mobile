import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:learn_flutter/page/teacher/add_material.dart';
import 'package:learn_flutter/page/teacher/teacher_page.dart';
import 'package:learn_flutter/services/material_services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import 'add_material_supervisor.dart';

class ShowScheduleSupervisorPage extends StatefulWidget {
  FirebaseUser user;
  final String a;

  ShowScheduleSupervisorPage({this.a,  this.user});

  @override
  _ShowScheduleSupervisorPageState createState() => _ShowScheduleSupervisorPageState(a: this.a, user: user);
}

class _ShowScheduleSupervisorPageState extends State<ShowScheduleSupervisorPage> {
  final String a;
  FirebaseUser user;

  _ShowScheduleSupervisorPageState({this.a, this.user});

  dynamic data;

  Future<dynamic> getData() async {
    final DocumentReference document =
    Firestore.instance.collection("schedules").document(a);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        data = snapshot.data;
      });
    });
  }

  dynamic dataUser;
  Future<dynamic> getDataUser() async {
    final DocumentReference document =
    Firestore.instance.collection("users").document(user.uid);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        dataUser = snapshot.data;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text("Detail Schedule"),
      ),
      body: Builder(
        builder: (context) => Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 80.0,
                      child: Image.asset('assets/logo/schedule.png'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 60.0),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                data != null
                                    ? data['activity']
                                    : '',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(right: 140.0),
                  // )
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                data != null
                                    ? data['date'].toDate().toString()
                                    : '',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                data != null ? data['status'] : '',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                    top: 60.0, bottom: 30.0, left: 60.0, right: 60.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Supervisor :',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold)),
                    SizedBox(width: 20.0),
                    Text(
                        data != null
                            ? data['supervisor_name']
                            : '',
                        style:
                        TextStyle(color: Colors.blueGrey, fontSize: 16.0)),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.blue,
                    onPressed: () async {
                      await launch(
                          data != null ? data['material'] : '');
                    },
                    elevation: 4.0,
                    splashColor: Colors.blueGrey,
                    child: Text(
                      'Open RPP',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.red,
                    onPressed: () async {
                      await MaterialServices.deleteMaterial(a);
                      Navigator.pop(context);
                    },
                    elevation: 4.0,
                    splashColor: Colors.blueGrey,
                    child: Text(
                      'Delete RPP',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.green,
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddMaterialSupervisorPage(user: this.user, a: this.a)),
                      );
                    },
                    elevation: 4.0,
                    splashColor: Colors.green,
                    child: Text(
                      'Add RPP',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
