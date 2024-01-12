import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagramc/core/server/file_upload_in_firebase.dart';
import 'package:instagramc/core/server/user_shared_preference.dart';
import 'package:instagramc/core/utils/design_utils.dart';
import 'package:instagramc/core/models/user_model.dart';

class AuthMethods{
  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserModel _userModel = UserModel();
  dynamic _signUp;

  Future<UserModel> getUserDetails() async {
    User _currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection("users").doc(_currentUser.uid).get();

    return UserModel.fromSnapshotToModel(snap);

  }

  Future<String> registrationInFirebase({
    required String userName,
    required String userBio,
    required String userEmail,
    required String userPassword,
    required Uint8List file,
  }) async {

    try {
      _signUp = await _auth.createUserWithEmailAndPassword(
          email: userEmail, password: userPassword);
    } catch (error) {
      return error.toString();
    }
    debugPrint("signUp: $_signUp");
    debugPrint("User ID: ${_signUp.user!.uid}");
    String photoUrl =
    await FileUploadInFirebase().uploadImageToStorage(profilePics, file, false);
    if (_signUp.user.uid != null) {
      _userModel.email = _signUp.user.email;
      _userModel.userImageURL = _signUp.user.uid;
      _userModel.uid = photoUrl;
      _userModel.userName = userName;
      _userModel.userBio = userBio;
      _userModel.signIn = true;
      _userModel.followers = [];
      _userModel.following = [];
      await firebaseFireStore
          .collection("users")
          .doc(_signUp.user!.uid)
          .set(_userModel.toMap());
      await SaveUserDetailsLocally().setUserDetails(uid: _signUp.user.uid, email: _signUp.user.email ?? "", );
      return success;
    } else {
      return _signUp.toString();
    }
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
        // logging in user with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      debugPrint("UserCredential While Login : ${userCredential.user!}");
      debugPrint("User UID While Login : ${userCredential.user!.uid}");
      debugPrint("User Email While Login : ${userCredential.user!.email}");
        await SaveUserDetailsLocally().setUserDetails(uid: userCredential.user?.uid ?? "", email: userCredential.user?.email ?? "", );
        return success;
    } catch (err) {
      return err.toString();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await SaveUserDetailsLocally().removeUserDetails();
  }

}