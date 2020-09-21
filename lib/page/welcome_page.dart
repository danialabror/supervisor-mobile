import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/page/auth/sign_up_two.dart';
import 'package:learn_flutter/page/auth/signup_page.dart';
import 'package:learn_flutter/page/teacher/schedule_page.dart';
import 'package:learn_flutter/services/auth_services.dart';
import 'package:learn_flutter/services/database_services.dart';
import 'package:learn_flutter/page/curriculum/curriculum_page.dart';
import 'principal/principal_page.dart';
import 'supervisor/supervisor_page.dart';
import 'teacher/teacher_page.dart';

class Welcome extends StatelessWidget {
  final FirebaseUser user;

  Welcome(this.user);

  Future<DocumentSnapshot> filterUser(String id) async {
    return await Firestore.instance.collection("users").document(id).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        children: <Widget>[
          Hero(
            tag: 'hero',
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 200.0,
              child: Image.asset('assets/image/welcome.png'),
            ),
          ),
          FlatButton(
              child: Text(
                'Next..',
                style: TextStyle(color: Colors.black54),
              ),
              onPressed: () async {
                DocumentSnapshot snapshot = await filterUser(user.uid);

                if (snapshot.data == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignUpTwo(this.user)),
                  );
                } else if (snapshot.data['role'] == "TEACHER") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SchedulePage(this.user)),
                  );
                } else if (snapshot.data['role'] == "SUPERVISOR") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SupervisorPage(this.user)),
                  );
                } else if (snapshot.data['role'] == "CURRICULUM") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CurriculumPage(this.user)),
                  );
                } else if (snapshot.data['role'] == "PRINCIPAL") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrincipalPage(this.user)),
                  );
                } else if (snapshot.data['role'] == "ADMIN") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SignUpPage()),
                  );
                }
              }),
        ],
      )),
    );
  }
}
