
import 'package:aadharupdater/models/Auth.dart';
import 'package:aadharupdater/screens/authenticateOperator.dart';
import 'package:aadharupdater/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'screens/demoScreen.dart';

Future<void> main()async{
    WidgetsFlutterBinding.ensureInitialized();
    runApp(MyApp());
    await MyHomePageState.getLocation();// initially get the location

  // print("Inside main()");
  // Future<http.Response> res = Authentication.sendOTP("999936311166", "0acbaa8b-b3ae-433d-a5d2-51250ea8e970");
  }
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aadhar Updater',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.orange),
      home: AuthOperatorScreen(),
    );
  }
}
