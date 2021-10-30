
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthAPI {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      return false;
    }
  }

  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();

    if(!isAvailable) {
      print("returning false from isAvailable Method");
      return false;
    }
    try {
      return await _auth.authenticate(
          localizedReason: "Authenticate",
          useErrorDialogs: true,
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      print("Returning false from Platfrom Exception $e");
      return false;
    }
  }
}