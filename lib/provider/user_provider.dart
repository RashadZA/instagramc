import 'package:flutter/material.dart';
import 'package:instagramc/core/models/user_model.dart';
import 'package:instagramc/core/server/auth_methods.dart';

class UserProvider with ChangeNotifier{

  UserModel? _userModel;

  final AuthMethods _authMethods = AuthMethods();

  UserModel get getUserModel => _userModel ?? UserModel.defaultModel();


  Future<void> refreshUser() async {

    UserModel user = await _authMethods.getUserDetails();
    _userModel = user;
    notifyListeners();

  }

}