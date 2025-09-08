import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasky_app/features/home/data/data_sources/remote_data_source/task_remote_data_source.dart';
import 'package:tasky_app/features/home/data/models/task.dart';

class TaskRemoteDataSourceImplementation implements TaskRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _tasksCollection() =>
      _db.collection('users').doc(_auth.currentUser!.uid).collection('tasks');

  @override
  Future<void> addTask(TaskModel task) async =>
      await _tasksCollection().add(task.toMap());

  @override
  Future<List<TaskModel>> getAllTasks() async {
    final snapshot = await _tasksCollection()
        .orderBy('priority', descending: false)
        .get();
    if (snapshot.docs.isEmpty) {
      return [];
    }
    return snapshot.docs.map((doc) {
      return TaskModel.fromMap(doc.data(), doc.id);
    }).toList();
  }

  @override
  Future<void> editTask(TaskModel task) async =>
      await _tasksCollection().doc(task.id).update(task.toMap());

  @override
  Future<void> deleteTask(String taskId) async =>
      await _tasksCollection().doc(taskId).delete();
}
