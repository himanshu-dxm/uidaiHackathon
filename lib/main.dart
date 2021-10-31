
import 'dart:math';

import 'package:aadharupdater/models/Auth.dart';
import 'package:aadharupdater/screens/authenticateOperator.dart';
import 'package:aadharupdater/screens/home.dart';
import 'package:aadharupdater/utils/operatorauth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/demoScreen.dart';

Future<void> main()async{
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();//need to be commented
    var Is = prefs.containsKey('OpID');
    var s = prefs.getString('OpID');
    if(!Is || s==null || s.length ==0 )
    {
      MyApp.isAuth = false;
    }
    else{
      MyApp.isAuth = true;
    }
    runApp(MyApp());
    await MyHomePageState.getLocation();// initially get the location

  // print("Inside main()");
  // Future<http.Response> res = Authentication.sendOTP("999936311166", "0acbaa8b-b3ae-433d-a5d2-51250ea8e970");
  }
class MyApp extends StatelessWidget {
  static bool isAuth = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aadhar Updater',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.orange),
      // home: AuthOperatorScreen(),
      home: isAuth?AuthOperatorScreen():OpAuth(),
    );
  }
}
