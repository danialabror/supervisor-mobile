import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/services/auth_services.dart';
import 'package:learn_flutter/services/database_services.dart';

import '../../main.dart';
import 'curriculum_page.dart';
import 'curriculum_supervision.dart';

class UserProcessPage extends StatefulWidget {
  FirebaseUser user;

  UserProcessPage(this.user);

  @override
  _UserProcessPageState createState() => _UserProcessPageState(this.user);
}

class _UserProcessPageState extends State<UserProcessPage> {
  FirebaseUser user;

  _UserProcessPageState(this.user);

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
    getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kelola Guru"),
      ),
      drawer: SizedBox(
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName:
                    Text(dataUser != null ? dataUser['name'] : ''),
                accountEmail:
                    Text(dataUser != null ? dataUser['role'] : ''),
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
                        builder: (context) =>
                            CurriculumScheduleSupervisionPage(this.user)),
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
          stream: Firestore.instance
              .collection("users")
              .where('role', whereIn: ["TEACHER", "SUPERVISOR"]).snapshots(),
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
                        child: Icon(Icons.supervised_user_circle),
                        backgroundColor: Colors.white,
                      ),
                      title: Row(
                        children: <Widget>[
                          Text(document['name'] != null
                              ? "${document['name']} "
                              : ''),
                          SizedBox(
                            width: 16.0,
                          ),
                        ],
                      ),
                      // subtitle: Text(document['date'] != null
                      //     ? document['date'].toDate().toString()
                      //     : ''),
                      trailing: FlatButton(
                        child: Text(
                          document['role'] != null ? document['role'] : '',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Stack(
                                  overflow: Overflow.visible,
                                  children: <Widget>[
                                    Positioned(
                                      right: -40.0,
                                      top: -40.0,
                                      child: InkResponse(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: CircleAvatar(
                                          child: Icon(Icons.close),
                                          backgroundColor: Colors.red,
                                        ),
                                      ),
                                    ),
                                    Form(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Center(
                                              child:
                                                  Text("${document['name']}"),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Text(
                                                  "Role : ${document['role']}"),
                                            ),
                                          ),
                                          Center(
                                            child: _btnn(
                                                a: document['role'],
                                                b: document.documentID),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                    ),
                  ],
                );
              }).toList(),
            );
          }),
    );
  }
}

Widget _btnn({a, b}) {
  if (a == "TEACHER") {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        child: Text("Ubah menjadi SUPERVISOR"),
        onPressed: () async {
          await DatabaseServices.updateTeacherOrSupervisor(b, "SUPERVISOR");
        },
      ),
    );
  } else {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        child: Text("Ubah menjadi TEACHER"),
        onPressed: () async {
          await DatabaseServices.updateTeacherOrSupervisor(b, "TEACHER");
        },
      ),
    );
  }
}
