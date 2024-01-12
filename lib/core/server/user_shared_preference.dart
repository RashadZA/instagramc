import 'package:flutter/cupertino.dart';
import 'package:instagramc/core/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveUserDetailsLocally {
  final String _userUID = "userUID";
  final String _userEmail = "userEmail";

  Future setUserDetails({required String uid,required String email,}) async {
    await removeUserDetails();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userUID, uid);
    await prefs.setString(_userEmail, email);
    await getUserUIDFromLocal();
    await getUserEmailFromLocal();
  }

  Future getUserUIDFromLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String uid = prefs.getString(_userUID) ?? "";
    debugPrint("User UID From Local: $uid");
  }

  Future getUserEmailFromLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String email = prefs.getString(_userEmail) ?? "";
    debugPrint("User Email From Local: $email");
  }

  Future removeUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userUID);
    await prefs.remove(_userEmail);
  }


}
