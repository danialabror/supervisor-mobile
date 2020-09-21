import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'page/auth/login_page.dart';
import 'page/welcome_page.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseUser firebaseUser = Provider.of<FirebaseUser>(context);

    return (firebaseUser == null) ? LoginPage() : Welcome(firebaseUser);

  }
}
