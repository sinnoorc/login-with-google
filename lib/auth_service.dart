import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class AuthService {
  StreamBuilder handleAuthState() => StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      );

  Future<UserCredential> signWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: <String>['email'],
      ).signIn();

      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      return Future.error(e);
    }
  }

  Future<UserCredential> signWithGithub() async {
    try {
      final GithubAuthProvider githubProvider = GithubAuthProvider();
      if (kIsWeb) {
        return await FirebaseAuth.instance.signInWithPopup(githubProvider);
      } else {
        return throw UnimplementedError('Github login is not supported on mobile');
      }
    } on Exception catch (e) {
      return Future.error(e);
    }
  }

  Future<UserCredential> signWithFacebook() async {
    try {
      final FacebookAuthProvider facebookProvider = FacebookAuthProvider();
      return await FirebaseAuth.instance.signInWithPopup(facebookProvider);
    } on Exception catch (e) {
      return Future.error(e);
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } on Exception catch (e) {
      return Future.error(e);
    }
  }
}
