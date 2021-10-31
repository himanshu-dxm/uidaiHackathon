import 'package:aadharupdater/screens/authenticateOperator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpAuth extends StatefulWidget {
  OpAuthState createState() => OpAuthState();
}

class OpAuthState extends State<OpAuth> {
  TextEditingController opID = new TextEditingController();
  bool isLoading = false;
  Widget build(context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(100))),
              backgroundColor: Colors.black,
              title: Text("Register Operator's UID"),
            ),
            body: Container(
              decoration: BoxDecoration(border: Border.all(width: 1)),
              padding: EdgeInsets.all(3),
              margin: EdgeInsets.all(3),
              child: Column(
                children: [
                  TextField(
                    controller: opID,
                    decoration: InputDecoration(
                        hintText: 'ID/NAME', border: OutlineInputBorder()),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        //send otp
                        setState(() {
                          isLoading = true;
                        });
                        var prefs = await SharedPreferences.getInstance();
                        prefs.setString('OpID', opID.text.toString());
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("saved")));
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AuthOperatorScreen()));
                      },
                      child: Text("Save")),
                ],
              ),
            ),
          );
  }
}
