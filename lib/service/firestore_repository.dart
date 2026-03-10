import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:herody/service/api_service_provider.dart';

import '../utils/exports.dart';
import '../model/task.dart';

class FirestoreRepository {
  FirestoreRepository(this._firestore);
  final FirebaseFirestore _firestore;

  Future<void> addJob(String uid,String title,String desc,WidgetRef ref)async{
    try{
      final docRef = await _firestore.collection('users/$uid/tasks').add({
        'title':title,
        'description':desc,
        'createdAt':FieldValue.serverTimestamp()
      });
      debugPrint(docRef.id);
      ref.read(apiServiceProvider).showToast("Task Added Successfully");
    }catch(e){
      ref.read(apiServiceProvider).showToast("Failed to add task $e");
    }
  }
  Future<void> updateJob(String uid,String taskId, String title,String desc,WidgetRef ref)async {
    try{
      await _firestore.doc('users/$uid/tasks/$taskId').update({
        'title':title,
        'description':desc
      });
      ref.read(apiServiceProvider).showToast("Task Updated Successfully");
    }catch(e){
      ref.read(apiServiceProvider).showToast("Failed to update task $e");
    }
  }

  Future<void> deleteJob(String uid,String taskId,WidgetRef ref)async{
    try{
      await _firestore.doc('users/$uid/tasks/$taskId').delete();
      ref.read(apiServiceProvider).showToast("Task Deleted Successfully");
    }catch(e){
      ref.read(apiServiceProvider).showToast("Failed to delete task $e");
    }
  }

  Future<void> completeTask(String uid,String taskId,bool value,WidgetRef ref)async{
    try{
      await _firestore.doc('users/$uid/tasks/$taskId').update({'completed':value});
      if(value){
        ref.read(apiServiceProvider).showToast("Task Completed Successfully");
      }
    }catch(e){
      ref.read(apiServiceProvider).showToast("Failed to complete task $e");
    }
  }

  Query<Task> jobsQuery(String uid){
    return _firestore.collection('users/$uid/tasks').withConverter(
        fromFirestore: (snapshot,_)=> Task.fromMap(snapshot.data()!),
        toFirestore: (task,_)=> task.toMap()).orderBy('createdAt',descending: true);
  }
}
final firestoreRepositoryProvider = Provider<FirestoreRepository>((ref){
  return FirestoreRepository(FirebaseFirestore.instance);
});