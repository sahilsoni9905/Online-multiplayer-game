import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mega_app_project/authentication/screens/profile_setup_screen.dart';
import 'package:mega_app_project/authentication/screens/signin_screen.dart';
import 'package:mega_app_project/common/store_file_to_firebase.dart';
import 'package:mega_app_project/home/screens/home_screen.dart';
import 'package:mega_app_project/models/users_models.dart';
import 'package:mega_app_project/utils.dart';

final AuthRepositoryProvider = Provider(
  (ref) => AuthRepository(ref: ref),
);
final userDataAuthProvider = FutureProvider((ref) {
  return ref.watch(AuthRepositoryProvider).getCurrentUserData();
});

class AuthRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final ProviderRef ref;

  AuthRepository({required this.ref});

  void signUpwithEmailandPassword(BuildContext context, String email,
      String password, String username) async {
    try {
      UserCredential cred =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel user = UserModel(
          uid: cred.user!.uid,
          userName: username,
          email: email,
          password: password,
          profilePic: '',
          netPoints: 100000);
      await firestore.collection('users').doc(user.uid).set(user.toMap());
      showSnackBar(context: context, content: 'Account created successfully');
      Navigator.pushNamed(context, SignInScreen.routeName);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showSnackBar(
            context: context,
            content: 'The email address is already in use by another account.');
      } else if (e.code == 'weak-password') {
        showSnackBar(
            context: context, content: 'The password provided is too weak.');
      } else if (e.code == 'invalid-email') {
        showSnackBar(
            context: context, content: 'The email address is not valid.');
      } else {
        showSnackBar(context: context, content: e.message.toString());
      }
    } catch (e) {
      print('sign in karte wakt kuch error aa gya hai');
    }
  }

  void signIn(BuildContext context, String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      showSnackBar(context: context, content: 'Sign in successful');
      Navigator.pushNamed(context, ProfileSetupScreen.routeName);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar(
            context: context, content: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showSnackBar(
            context: context,
            content: 'Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        showSnackBar(
            context: context, content: 'The email address is not valid.');
      } else {
        showSnackBar(context: context, content: e.message.toString());
      }
    } catch (e) {
      print('An error occurred during sign in: $e');
      showSnackBar(
          context: context,
          content: 'An unexpected error occurred. Please try again later.');
    }
  }

  void profileSetup(
      File? profilePic, String userDisplayName, BuildContext context) async {
    var listOfallUsers = await firestore.collection('users').get();
    bool found = false;
    String dp;
    for (var i in listOfallUsers.docs) {
      if (i['userName'] == userDisplayName) {
        found = true;
        break;
      }
    }
    var userUid = auth.currentUser!.uid;
    if (found == true) {
      showSnackBar(
          context: context, content: 'User with this Username already exist');
      return;
    }
    if (profilePic != null) {
      dp = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
            'profilePic/$userUid',
            profilePic,
          );
    } else {
      dp =
          'https://th.bing.com/th/id/OIP.TjajcM7s_iUvKp8jQFODoAHaPO?rs=1&pid=ImgDetMain';
    }
    try {
      await firestore
          .collection('users')
          .doc(userUid)
          .update({'userName': userDisplayName, 'profilePic': dp});
      showSnackBar(context: context, content: 'Info Updated successfully');
      Navigator.pushNamed(context, HomePage.routeName);
    } catch (e) {
      showSnackBar(
          context: context,
          content: 'There was error in updatin info ${e.toString()}');
    }
  }

  Future<UserModel?> getCurrentUserData() async {
    UserModel? user;
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();

    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  Stream<UserModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (event) => UserModel.fromMap(
            event.data()!,
          ),
        );
  }
}
