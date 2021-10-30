import 'package:aadharupdater/screens/authenticateOperator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpAuth extends StatefulWidget{
  OpAuthState createState() => OpAuthState();
}

class OpAuthState extends State<OpAuth>{
  TextEditingController opUID = new TextEditingController();
  TextEditingController opOTP = new TextEditingController();
  bool showOTPButton = false;
  bool canEditUid = true;
  bool isLoading = false;
  bool showOTPField = false;
  Widget build(context){
    return isLoading?Center(child: CircularProgressIndicator(),):Scaffold(
      appBar: AppBar(title: Text("Register Operator's UID"),),
      body: Container(
        decoration: BoxDecoration(border: Border.all(width: 1)),
        padding: EdgeInsets.all(3),
        margin: EdgeInsets.all(3),
        child: Column(children: [
          TextField(
            controller: opUID,
            maxLength: 12,
            decoration: InputDecoration(enabled: canEditUid,hintText: 'UID',border: OutlineInputBorder()),
            keyboardType: TextInputType.numberWithOptions(signed: false,decimal: false),
            onSubmitted: (val)async{
              if(val.length==12)
              {
                setState(() {
                  canEditUid = false;
                  showOTPButton = true;
                });
              }
              else
              {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("UID is invaild")));
              }
            },
          ),
          showOTPButton?ElevatedButton(onPressed: ()async{
            //send otp
            setState(() {
              showOTPField = true;
            });
          }, child: Text("Get OTP")):SizedBox(),
          showOTPField?TextField(
            controller: opOTP,
            decoration: InputDecoration(hintText: 'OTP',border: OutlineInputBorder()),
            keyboardType: TextInputType.numberWithOptions(signed: false,decimal: false),
            onSubmitted: (val)async{
              //validation is in if statement
              if(val.isNotEmpty)//see if correct
              {
                //edit sharedpref
                var prefs = await SharedPreferences.getInstance();
                prefs.setString('OpUID',opUID.text.toString());
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("UID saved")));
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>AuthOperatorScreen()));
              }
              else
              {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("OTP is wrong")));
              }
            },
          ):SizedBox(),
        ],),
      ),
    );
  }
}