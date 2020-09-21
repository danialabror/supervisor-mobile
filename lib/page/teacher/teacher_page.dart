import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/main.dart';
import 'package:learn_flutter/page/teacher/add_material.dart';
import 'package:learn_flutter/page/teacher/schedule_page.dart';
import 'package:learn_flutter/page/teacher/show_material_page.dart';
import 'package:learn_flutter/services/auth_services.dart';

class TeacherPage extends StatefulWidget {
  final FirebaseUser user;

  TeacherPage(this.user);

  @override
  _TeacherPageState createState() => _TeacherPageState(this.user);
}

class _TeacherPageState extends State<TeacherPage> {
  final FirebaseUser user;

  _TeacherPageState(this.user);

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
        title: Text("RPP"),
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
          Firestore.instance.collection("materials").where('name', isEqualTo: data!=null?data['name']:'').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text("Tidak ada data"),
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
                          radius: 17.0,
                          child: Image.asset('assets/logo/document.png'),
                          backgroundColor: Colors.white,
                        ),
                        title: Row(
                          children: <Widget>[
                            Text("${document['material_name']!=null?document['material_name']:''}"),
                            SizedBox(
                              width: 16.0,
                            ),
                          ],
                        ),
                        subtitle:
                        Text("Supervisor : ${document['supervisor_name']!=null?document['supervisor_name']:''}"),
                        trailing: Text(
                          "${document['status']}",
                          style: TextStyle(fontSize: 12.0),
                        ),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowMaterialPage(a: document.documentID,)
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
