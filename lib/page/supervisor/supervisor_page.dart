import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/page/supervisor/check_material_page.dart';
import 'package:learn_flutter/page/supervisor/schedule_supervisor.dart';
import 'package:learn_flutter/services/auth_services.dart';

import '../../main.dart';

class SupervisorPage extends StatefulWidget {
  FirebaseUser user;

  SupervisorPage(this.user);

  @override
  _SupervisorPageState createState() => _SupervisorPageState(this.user);
}

class _SupervisorPageState extends State<SupervisorPage> {
  FirebaseUser user;

  _SupervisorPageState(this.user);

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
        title: Text("Supervisi"),
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
                title: Text("Dashboard"),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SupervisorPage(this.user)),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.bookmark_border),
                title: Text("Schedule"),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScheduleSupervisorPage(this.user)),
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
            .collection("materials")
            .where('status', isEqualTo: 'NOT APPROVED')
            .where('supervisor_name', isEqualTo: dataUser != null ? dataUser['name'] : '')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text("Tidak ada data"),
            );
          } else {
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
                        radius: 17.0,
                        child: Image.asset('assets/logo/document.png'),
                        backgroundColor: Colors.white,
                      ),
                      title: Row(
                        children: <Widget>[
                          Text(document['material_name'] != null
                              ? document['material_name']
                              : ''),
                          SizedBox(
                            width: 16.0,
                          ),
                        ],
                      ),
                      subtitle: Text(
                          document['name'] != null ? document['name'] : ''),
                      trailing: Text(
                        document['created_at'] != null
                            ? document['created_at'].toDate().toString()
                            : '',
                        style: TextStyle(fontSize: 12.0),
                      ),
                      onTap: () async {
                        await Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => CheckMaterialPage(m: document.documentID,)
                        ),
                        );
                      },
                    ),
                  ],
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
