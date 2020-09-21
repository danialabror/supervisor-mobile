import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/page/curriculum/user_process.dart';
import 'package:learn_flutter/services/auth_services.dart';
import 'package:learn_flutter/services/schedule_services.dart';

import '../../main.dart';
import 'add_schedule.dart';
import 'curriculum_supervision.dart';

class CurriculumPage extends StatefulWidget {
  FirebaseUser user;

  CurriculumPage(this.user);

  @override
  _CurriculumPageState createState() => _CurriculumPageState(user);
}

class _CurriculumPageState extends State<CurriculumPage> {
  FirebaseUser user;

  _CurriculumPageState(this.user);

  dynamic data;

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
        title: Text("Schedules"),
      ),
      drawer: SizedBox(
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(data != null ? data['name'] : ''),
                accountEmail: Text(data != null ? data['role'] : ''),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image.asset("assets/logo/user.png"),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                leading: Icon(Icons.apps),
                title: Text("All Schedules"),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CurriculumPage(this.user)),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.bookmark_border),
                title: Text("My Supervision"),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CurriculumScheduleSupervisionPage(this.user)),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.supervised_user_circle),
                title: Text("Kelola Supervisor"),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserProcessPage(this.user)),
                  );
                },
              ),
              Divider(
                height: 2.0,
              ),
              ListTile(
                leading: Icon(Icons.input),
                title: Text("Logout"),
                onTap: () async {
                  await AuthServices.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MyApp()));
                },
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection("schedules").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return ListView(
              children: snapshot.data.documents.map((document) {
                return Column(
                  children: <Widget>[
                    Divider(
                      height: 2.0,
                      color: Colors.grey,
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        radius: 21.0,
                        child: Image.asset('assets/logo/schedule.png'),
                        backgroundColor: Colors.white,
                      ),
                      title: Row(
                        children: <Widget>[
                          Text(document != null
                              ? "${document['activity']} ( ${document['teacher_name']} ) "
                              : ''),
                          SizedBox(
                            width: 16.0,
                          ),
                        ],
                      ),
                      subtitle: Text(document['date'] != null
                          ? document['date'].toDate().toString()
                          : ''),
                      trailing: FlatButton(
                        child: Text(
                          document['status'] != null ? document['status'] : '',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            );
          }),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSchedulePage(this.user)),
          );
        },
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
