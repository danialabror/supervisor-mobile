import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/services/material_services.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckMaterialPage extends StatefulWidget {
  final String m;

  CheckMaterialPage({this.m});

  @override
  _CheckMaterialPageState createState() => _CheckMaterialPageState(m: this.m);
}

class _CheckMaterialPageState extends State<CheckMaterialPage> {
  TextEditingController commentController = TextEditingController(text: "");
  final String m;

  _CheckMaterialPageState({this.m});

  dynamic dataMaterial;

  Future<dynamic> getData() async {
    final DocumentReference document =
    Firestore.instance.collection("materials").document(m);

    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        dataMaterial = snapshot.data;
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
        title: Text(dataMaterial != null
            ? dataMaterial['material_name']
            : ''),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Builder(
        builder: (context) =>
            Container(
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
                          child: Image.asset('assets/logo/document.png'),
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
                                    dataMaterial != null
                                        ? dataMaterial['material_name']
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
                                    "Diapload oleh: ${dataMaterial !=
                                        null ? dataMaterial['name'] : ''}",
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
                                child: Text(dataMaterial != null
                                    ? dataMaterial['created_at']
                                    .toDate()
                                    .toString()
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
                    height: 60.0,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          width: 200,
                          height: 70,
                          child: TextField(
                            decoration: InputDecoration(labelText: 'Komentar'),
                            controller: commentController,
                          ),
                        ),
                        ButtonTheme(
                          minWidth: 50.0,
                            child: RaisedButton(
                              color: Colors.lightBlueAccent,
                              elevation: 4.0,
                              splashColor: Colors.blueGrey,
                              child: Text(
                                'komentar',
                                style: TextStyle(color: Colors.white,
                                    fontSize: 16.0),
                              ),
                              onPressed: () async {
                                await MaterialServices.commentMaterial(m, comment: commentController.text.trim());
                                Navigator.pop(context);
                              },
                            )
                        ),
                      ]
                  ),
                  SizedBox(
                    height: 80.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.blue,
                        onPressed: () async {
                          await launch(dataMaterial != null
                              ? dataMaterial['material']
                              : '');
                        },
                        elevation: 4.0,
                        splashColor: Colors.blueGrey,
                        child: Text(
                          'Open RPP',
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                      SizedBox(width: 4.0,),
                      RaisedButton(
                        color: Colors.blue,
                        onPressed: () async {
                          await MaterialServices.approveMaterial(
                              m, status: "APPROVED");
                          Navigator.pop(context);
                        },
                        elevation: 4.0,
                        splashColor: Colors.blueGrey,
                        child: Text(
                          'APPROVE',
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
      ),
    );
  }
}
