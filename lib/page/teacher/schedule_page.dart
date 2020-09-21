import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/page/teacher/show_schedule.dart';
import 'package:learn_flutter/page/teacher/teacher_page.dart';
import 'package:learn_flutter/services/auth_services.dart';
import 'package:learn_flutter/services/schedule_services.dart';

import '../../main.dart';

class SchedulePage extends StatefulWidget {
  FirebaseUser user;

  SchedulePage(this.user);

  @override
  _SchedulePageState createState() => _SchedulePageState(this.user);
}

class _SchedulePageState extends State<SchedulePage> {
  FirebaseUser user;

  _SchedulePageState(this.user);

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
        title: Text('Schedules'),
      ),
      drawer: SizedBox(
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(data!=null?data['name']:''),
                accountEmail: Text(data!=null?data['role']:''),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image.asset("assets/logo/user.png"),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                leading: Icon(Icons.bookmark_border),
                title: Text("Schedule"),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SchedulePage(this.user)),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.apps),
                title: Text("RPP"),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TeacherPage(this.user)),
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
          stream:
          Firestore.instance.collection("schedules").where('teacher_name', isEqualTo: data!=null?data['name']:'').where('status', isEqualTo: "NOT FINISHED").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text("Tidak ada jadwal"),
              );
            } else{
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
                            Text(document['activity']!=null?document['activity']:''),
                            SizedBox(
                              width: 16.0,
                            ),
                          ],
                        ),
                        subtitle:
                        Text(document['date']!=null?document['date'].toDate().toString():''),
                        trailing: FlatButton(
                            child: Text(
                              document['status']!=null?document['status']:'',
                              style: TextStyle(color: Colors.black54),
                            ),
                            onPressed: () async {
                              await ScheduleServices.finishSchedule(document.documentID);
                            }),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowSchedulePage(a: document.documentID, user: this.user)
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }).toList(),
              );
            }
          }),
    );
  }
}
