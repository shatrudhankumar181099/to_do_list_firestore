import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:herody/service/ui_auth_provider.dart';

import '../utils/exports.dart';

class CustomSignIn extends ConsumerWidget{
  const CustomSignIn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProviders = ref.watch(authProvidersProvider);
    return Scaffold(
      body: SignInScreen(
        providers: authProviders,
      ),
    );
  }
}