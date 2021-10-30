import 'dart:ui';

import 'package:aadharupdater/api/LocalAuthAPI.dart';
import 'package:aadharupdater/screens/home.dart';
import 'package:aadharupdater/screens/screen2.dart';
import 'package:flutter/material.dart';

import 'demoScreen.dart';

class AuthOperatorScreen extends StatefulWidget {
  const AuthOperatorScreen({Key? key}) : super(key: key);

  @override
  _AuthOperatorScreenState createState() => _AuthOperatorScreenState();
}

class _AuthOperatorScreenState extends State<AuthOperatorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              "assets/bgImg.jpg",
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            // Container(
            //   decoration: BoxDecoration(color: Colors.black38),
            // ),
            ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5,sigmaY: 3),
                child: Container(
                  height: 20,
                  width: 20,
                  alignment: Alignment.center,
                  color: Colors.grey.withOpacity(0.1),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 350,),
                      Container(
                        child: Text(
                          "Welcome",
                          style: TextStyle(
                          textBaseline: TextBaseline.alphabetic,
                          fontSize: 34,
                          color: Colors.greenAccent,
                          )
                        ),
                      ),
                      SizedBox(height: 15,),
                      Container(
                          margin: EdgeInsets.all(50),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent)
                          ),
                          child: Center(
                            child: InkWell(
                              onTap: () async {
                                print("Inside Authenticate method button");
                                final isAuthenticated = await LocalAuthAPI.authenticate();
                                print("IsAuthenticated Value = ${isAuthenticated}");
                                if(isAuthenticated) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>DemoScreen()));
                                }
                              },
                              child: Container(
                                child: Text(
                                    "Authenticate Yourself",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.greenAccent,
                                    )
                                ),
                              ),

                            ),
                          )
                      ),
                    ]
                  )
                )
            )),
            SizedBox(height: 8,),
          ],
        ),
      ),
    );
  }
}
