import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final taskId = FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask({
    required String taskName,
    required DateTime taskDate,
    required String fromTime,
    required String toTime,
    required String periodFrom,
    required String periodTo,
  }) async {
    try {
      await _firestore.collection('tasks').add({
        'taskName': taskName,
        'taskDate': taskDate.toIso8601String(),
        'fromTime': fromTime,
        'toTime': toTime,
        'periodFrom': periodFrom,
        'periodTo': periodTo,
        'isCompleted': false, // Set isCompleted to false by default
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error adding task: $e");
      rethrow;
    }
  }

  Future<void> updateTaskCompletion(taskId, bool isCompleted) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'isCompleted': isCompleted,
      });
    } catch (e) {
      print("Error updating task: $e");
      rethrow;
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      print("Error deleting task: $e");
      rethrow;
    }
  }
}
