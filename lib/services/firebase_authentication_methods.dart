import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:missing_child/utils/moveToHomePage.dart';

import '../utils/showSnackBar.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth; //FirebaseAuth instance
  FirebaseAuthMethods(this._auth);
  // User get user => _auth.currentUser!; //this

  //Function to sign up using email
  Future<void> signUpUsingEmail({
    required String email,
    required String password,
    required BuildContext context, //used to display a snackbar or store data in firestore firebase
    required String fname,
    required String lname,
    required String phoneno,

  }) async { //async since firebase is going to be contacted
    try{
      await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
      );
      moveToHomePage(context);

      final data = {'first_name': fname, 'last_name': lname, 'email': email,'password': password, 'phone_number': phoneno,};

      FirebaseFirestore.instance.collection('users').add(data); //adding user data to firebase


      // Navigator.of(context, rootNavigator: true).pushNamed("/homepg");
    } on FirebaseAuthException catch(e){
      if (e.code == "invalid-email") {
        showSnackBar(context,"Please enter a valid email address.");
      }
      else if (e.code == "email-already-in-use") {
        showSnackBar(context,"The account with this email already exists.");
      }
      // else if (e.code == "unknown") {
      //   showSnackBar(context,"This a required field. Please enter the data.");
      // }
      // else if (e.code == "user-not-found") {
      //   showSnackBar(context,"User not found. Please sign up to proceed.");
      // }
      // else if (e.code == "wrong-password") {
      //   showSnackBar(context,"The password is invalid. Please enter the correct password.");
      // }
      else {
        // print(e.code);
        showSnackBar(context, e.message!);
      }
    }

  }

  //Function to login using email
  Future<void>logInUsingEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try{
      await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      moveToHomePage(context);
      // Navigator.of(context, rootNavigator: true).pushNamed("/homepg");
      // if(!_auth.currentUser!.emailVerified){ //if current user is not verified send an email verification
      //   await sendEmailVerification(context);
      // }
    } on FirebaseAuthException catch(e){

      if (e.code == "invalid-email") {
        showSnackBar(context,"Please enter a valid email address.");
      }
      // else if (e.code == "email-already-in-use") {
      //   showSnackBar(context,"The account with this email already exists.");
      // }
      // else if (e.code == "unknown") {
      //   showSnackBar(context,"This a required field. Please enter the data.");
      // }
      else if (e.code == "user-not-found") {
        showSnackBar(context,"User not found. Please sign up to proceed.");
      }
      else if (e.code == "wrong-password") {
        showSnackBar(context,"The password is invalid. Please enter the correct password.");
      }
      else {
        // print(e.code);
        showSnackBar(context, e.message!);
      }
    }
  }

  //Function to sign out
  Future<void> signOut(BuildContext context) async {
    try{
      await _auth.signOut();
    } on FirebaseAuthException catch(e){
      showSnackBar(context, e.message!);
    }

  }

  //Function to delete account
  Future<void> deleteAccount(BuildContext context) async {
    try{
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch(e){
      showSnackBar(context, e.message!);
    }

  }


}