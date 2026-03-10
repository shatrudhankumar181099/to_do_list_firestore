import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:herody/service/ui_auth_provider.dart';

import '../utils/app_route.dart';
import '../utils/exports.dart';

class CustomProfileScreen extends ConsumerWidget{
  const CustomProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProvider = ref.watch(authProvidersProvider);
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Profile"),),
      body: ProfileScreen(
        showUnlinkConfirmationDialog: false,
        providers: authProvider,
        actions: [
          SignedOutAction((context){
            context.goNamed(AppRoute.signIn.name);
          })
        ],
      ),
    );
  }
}