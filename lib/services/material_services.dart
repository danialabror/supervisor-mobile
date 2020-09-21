import 'package:cloud_firestore/cloud_firestore.dart';

class MaterialServices{
  static CollectionReference materialCollection = Firestore.instance.collection("materials");

  static Future<void> createMaterial(String lesson, String material_name, DateTime created_at, String material, String name, String status, String comment, String supervisor_name) async {
    await materialCollection.document().setData({
      'lesson': lesson,
      'material_name': material_name,
      'created_at': created_at,
      'material': material,
      'name': name,
      'status': status,
      'comment': comment,
      'supervisor_name': supervisor_name
    });
  }

  static Future<void> updateMaterial(String id, {String lesson, String material_name, String created_at, String material, String name, String status, String comment}) async {
    await materialCollection.document(id).setData({
      'lesson': lesson,
      'material_name': material_name,
      'created_at': created_at,
      'material': material,
      'name': name,
      'status': status,
      'comment': comment,
    }, merge: true);
  }

  static Future<DocumentSnapshot> getMaterial(String id) async {
    return await materialCollection.document(id).get();
  }

  static Future<void> deleteMaterial(String id) async {
   return await materialCollection.document(id).delete();
  }

  static Future<DocumentSnapshot> getAllMaterial() async {
    QuerySnapshot querySnapshot = await materialCollection.getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];
      print(a.data['material']);
      print(a.data['name']);
      print(a.data['lesson']);
    }
  }

  static Future<void> approveMaterial(String id, {String status}) async {
    await materialCollection.document(id).setData({
      'status': status
    }, merge: true);
  }

  static Future<void> commentMaterial(String id, {String comment}) async {
    await materialCollection.document(id).setData({
      'comment': comment
    }, merge: true);
  }

}