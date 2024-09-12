// lib/controllers/auth_controller.dart
import 'package:flutter/material.dart';
import '../models/auth_model.dart';

class AuthController {
  final AuthModel _authModel;

  AuthController(this._authModel);

  Future<void> register(
    BuildContext context, 
    String email, 
    String password, 
    Function(String) onSuccess, 
    Function(String) onError
  ) async {
    try {
      var user = await _authModel.register(email, password);
      if (user != null) {
        onSuccess("Registration successful");
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  Future<void> login(
    BuildContext context, 
    String email, 
    String password, 
    Function(String) onSuccess, 
    Function(String) onError
  ) async {
    try {
      var user = await _authModel.login(email, password);
      if (user != null) {
        onSuccess("Login successful");
      }
    } catch (e) {
      onError(e.toString());
    }
  }
}
