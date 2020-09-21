import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleServices {
  static CollectionReference scheduleCollection =
      Firestore.instance.collection("schedules");

  static Future<void> finishSchedule(String id) async {
    await scheduleCollection
        .document(id)
        .setData({'status': "FINISHED"}, merge: true);
  }

  static Future<void> addSchedule(String activity, DateTime date, String status,
      String teacher_name, String supervisor_name) async {
    await scheduleCollection.document().setData({
      'activity': activity,
      'date': date,
      'status': status,
      'teacher_name': teacher_name,
      'supervisor_name': supervisor_name
    });
  }

  static Future<void> deleteSchedule(String id) async {
    await scheduleCollection.document(id).delete();
  }

  static Future<void> inputedData(String id) async {
    await scheduleCollection
        .document(id)
        .setData({'rpp': 'terisi', 'status': 'FINISHED'}, merge: true);
  }
}
