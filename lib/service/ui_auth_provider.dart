import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';


final authProvidersProvider = Provider<List<AuthProvider>>((ref) {
  return [
    EmailAuthProvider(),
  ];
});