import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasky_app/features/home/data/data_sources/remote_data_source/task_remote_data_source.dart';
import 'package:tasky_app/features/home/data/models/task.dart';

class TaskRemoteDataSourceImplementation implements TaskRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<TaskModel> _tasksCollection() => FirebaseFirestore
      .instance
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('tasks')
      .withConverter<TaskModel>(
        fromFirestore: (snapshot, _) => TaskModel.fromJson(snapshot.data()!),
        toFirestore: (task, _) => task.toJson(),
      );

  @override
  Future<void> addTask(TaskModel task) async {
    String taskId = _tasksCollection().doc().id;
    task.id = taskId;
    await _tasksCollection().doc(taskId).set(task);
  }

  @override
  Future<List<TaskModel>> getAllTasks() async {
    final snapshot = await _tasksCollection().orderBy('priority').get();
    if (snapshot.docs.isEmpty) {
      return [];
    }
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Future<void> editTask(TaskModel task) async =>
      await _tasksCollection().doc(task.id).update(task.toJson());

  @override
  Future<void> deleteTask(String taskId) async =>
      await _tasksCollection().doc(taskId).delete();

  @override
  Future<List<TaskModel>> search(String name) async {
    return await _tasksCollection()
        .where("name", isGreaterThanOrEqualTo: name)
        .where("name", isLessThanOrEqualTo: '$name\uf8ff')
        .get()
        .then((value) => value.docs.map((e) => e.data()).toList());
  }
}
