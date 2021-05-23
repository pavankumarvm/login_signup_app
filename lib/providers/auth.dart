import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:login_signup_app/models/user.dart';
import 'package:login_signup_app/util/app_url.dart';
import 'package:login_signup_app/util/rest_data.dart';
import 'package:login_signup_app/util/shared_preference.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

abstract class AuthContract {
  void onSuccess(User user);
  void onError(String error);
}

class AuthProvider with ChangeNotifier {
  AuthContract _auth;
  RestData api = new RestData();

  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;

  Future<Map<String, dynamic>> login(String email, String password) async {
    var result, response;

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    await api
        .login(email, password)
        .then((user) => {
              _auth.onSuccess(user),
              response["user"] = user,
              response["status"] = true,
            })
        .catchError((onError) => {
              _auth.onError(onError),
              response["status"] = false,
            });
    if (response) {
      _loggedInStatus = Status.LoggedIn;
      notifyListeners();
      result = {
        'status': true,
        'message': 'Successful',
        'user': response["user"]
      };
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {'status': false, 'message': "Not Logged In"};
    }
    return result;
  }

  Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    var result, response;

    _registeredInStatus = Status.Registering;
    notifyListeners();

    await api
        .register(name, email, password)
        .then((user) => {
              _auth.onSuccess(user),
              response["user"] = user,
              response["status"] = true,
            })
        .catchError((onError) => {
              _auth.onError(onError),
              response["status"] = false,
            });
    if (response) {
      _registeredInStatus = Status.Registered;
      notifyListeners();
      result = {
        'status': true,
        'message': 'Successful',
        'user': response["user"]
      };
    } else {
      _loggedInStatus = Status.NotRegistered;
      notifyListeners();
      result = {'status': false, 'message': "Not Registered"};
    }
    return result;
  }
}
