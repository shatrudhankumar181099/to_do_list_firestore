
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:herody/utils/app_strings.dart';
import '../service/api_service_provider.dart';
import '../utils/app_route.dart';
import '../utils/exports.dart';
import '../service/firestore_repository.dart';
import '../model/task.dart';
import '../utils/widget.dart';

class UsersTab extends ConsumerWidget {
  const UsersTab({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final firestoreRepository = ref.watch(firestoreRepositoryProvider);
    final title = ref.watch(titleNameControllerProvider);
    final description = ref.watch(descNameControllerProvider);
    final updateTitle = ref.watch(updateTitleNameControllerProvider);
    final updateDescriptionName = ref.watch(updateDescNameControllerProvider);
    final user = ref.watch(firebaseAuthProvider).currentUser;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          AppStrings.myTasks,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          InkWell(onTap:(){
         context.pushNamed(AppRoute.profile.name);
          },child:const Icon(Icons.person)),
         const SizedBox(width: 10,)
        ],
      ),
      backgroundColor: Colors.white,
      body: FirestoreListView<Task>(
          query: firestoreRepository.jobsQuery(user!.uid),
          emptyBuilder: (context) => const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.task_alt, size: 60, color: Colors.grey),
                SizedBox(height: 10),
                Text(
                  AppStrings.noTasksYet,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                )
              ],
            ),
          ),
          errorBuilder: (context,error,stackTrace)=> Center(child: Text(error.toString()),),
          itemBuilder: (BuildContext context,QueryDocumentSnapshot<Task> doc){
        final task = doc.data();
        return Dismissible(
          key: Key(doc.id),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction){
            final user = ref.read(firebaseAuthProvider).currentUser;
            ref.read(firestoreRepositoryProvider).deleteJob(user!.uid, doc.id,ref);
          },
          background: const ColoredBox(color: Colors.red),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: ListTile(
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  formatSmartDate(task.createdAt),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              onTap: (){
                HapticFeedback.heavyImpact();
                bottomSheetWidget(context, Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 5,),
                    const Text(AppStrings.enterTask,style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500,),),
                    const SizedBox(height: 8,),
                    textFieldWidget(15, 16, AppStrings.enterTitle, updateTitle, TextInputType.text),
                    const SizedBox(height: 10,),
                    textFieldWidget(15, 16, AppStrings.enterDescription, updateDescriptionName, TextInputType.text),
                    const SizedBox(height: 10,),
                    elevatedButtonWidget(AppStrings.update, (){
                      final user = ref.read(firebaseAuthProvider).currentUser;
                      ref.read(firestoreRepositoryProvider).updateJob(user!.uid,doc.id,updateTitle.text, updateDescriptionName.text,ref);
                      Navigator.pop(context);
                      updateTitle.clear();
                      updateDescriptionName.clear();
                    }, 15, 20),
                    const SizedBox(height: 15,)
                  ],
                ));
              },
              leading: Checkbox(
                value: task.completed,
                onChanged: (value) {
                  final user = ref.read(firebaseAuthProvider).currentUser;
                  ref.read(firestoreRepositoryProvider)
                      .completeTask(user!.uid, doc.id, value!,ref);
                },
              ),
              title: Text(task.title,style:  TextStyle(
                decoration: task.completed ? TextDecoration.lineThrough : null,
                fontWeight: FontWeight.w600,
                  ),maxLines: 1,),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  task.desc,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        );
      }) ,

      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton:Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: FloatingActionButton(
            backgroundColor: Colors.blueAccent,
            shape: const CircleBorder() ,
            onPressed: (){
              HapticFeedback.heavyImpact();
              bottomSheetWidget(context, Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 5,),
                  const Text(AppStrings.enterTitle,style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500,),),
                  const SizedBox(height: 8,),
                  textFieldWidget(15, 16, AppStrings.enterTitle, title, TextInputType.text),
                  const SizedBox(height: 10,),
                  textFieldWidget(15, 16, AppStrings.enterDescription, description, TextInputType.text),
                  const SizedBox(height: 10,),
                  elevatedButtonWidget(AppStrings.add, (){
                    final user = ref.read(firebaseAuthProvider).currentUser;
                    ref.read(firestoreRepositoryProvider).addJob(user!.uid, title.text, description.text,ref);
                    Navigator.pop(context);
                    title.clear();
                    description.clear();
                  }, 15, 20),
                  const SizedBox(height: 15,)
                ],
              ));
            },
            child: const Icon(Icons.add,color: Colors.white,)),
      ) ,
    );
  }
}
