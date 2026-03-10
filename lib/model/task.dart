import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Task extends Equatable{
  final String title;
  final String desc;
  final DateTime? createdAt;
  final bool completed;


  const Task({required this.desc,required this.title,required this.createdAt,    required this.completed,
  });
factory Task.fromMap(Map<String,dynamic> map){
  final createdAt = map['createdAt'];
  return Task(
      desc: map['description'] as String,
      title: map['title'] as String,
  createdAt: createdAt != null ? (createdAt as Timestamp).toDate() : null,
    completed: map['completed'] ?? false,
  );
}
Map<String,dynamic> toMap() => {
  'title':title,
  'description':desc,
  if(createdAt != null) 'createdAt': Timestamp.fromDate(createdAt!),
  'completed': completed,

};
@override
  List<Object?> get props =>  [title,desc,createdAt];

}