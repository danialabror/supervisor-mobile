import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  static CollectionReference userCollection = Firestore.instance
      .collection("users"); // yang mengarahkan kepada table (users)

  static Future<void> createOrUpdateUser(String id,
      {String name, String role}) async {
    await userCollection
        .document(id)
        .setData({'name': name, 'role': role}, merge: true);
  }

  static Future<DocumentSnapshot> getUser(String id) async {
    return await userCollection.document(id).get();
  }

  static Future<void> deleteUser(String id) async {
    await userCollection.document(id).delete();
  }

  static Future<void> updateTeacherOrSupervisor(String id, String role) async {
    await userCollection.document(id).setData({'role': role}, merge: true);
  }
}
