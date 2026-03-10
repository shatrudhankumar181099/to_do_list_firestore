import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:herody/views/user_tab.dart';

import '../views/custom_profile_screen.dart';
import '../views/custom_sign_in.dart';
import 'go_router_refresh_stream.dart';

enum AppRoute{
  signIn,
  main,
  profile
}
final firebaseAuthProvider = Provider<FirebaseAuth>((ref){
  return FirebaseAuth.instance;
});
final goRouterProvider = Provider<GoRouter>((ref){
  final firebaseAuth = ref.watch(firebaseAuthProvider);
   return GoRouter(
     initialLocation: '/sign-in',
       debugLogDiagnostics: true,
       redirect: (context,state){
       final isLoggedIn = firebaseAuth.currentUser != null;
       if(isLoggedIn){
         if(state.uri.path == '/sign-in'){
           return '/main';
         }
       } else{
         if(state.uri.path.startsWith('/main')){
           return '/sign-in';
         }
       }
       return null;
       },
       refreshListenable: GoRouterRefreshStream(firebaseAuth.authStateChanges()),
       routes: [
         GoRoute(path: '/sign-in',
         name: AppRoute.signIn.name,
         builder: (context,state)=> const CustomSignIn()),
         GoRoute(path: '/main',
             name: AppRoute.main.name,
             builder: (context,state)=> const UsersTab(),
         routes: [
           GoRoute(path: '/profile',
               name: AppRoute.profile.name,
               builder: (context,state)=> const CustomProfileScreen())
         ]),
       ]);
});