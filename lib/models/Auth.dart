import 'dart:convert';

import 'package:http/http.dart' as http;

class Authentication {
  static final _otpURL = Uri.parse("https://stage1.uidai.gov.in/onlineekyc/getOtp/");
  static final _authURL = Uri.parse("https://stage1.uidai.gov.in/onlineekyc/getAuth/");

  static Future<Response> sendOTP(vid,txnId) async {
    print("Inside sendOtp func\ncid = $vid \n txnId = $txnId");
    Response res = new Response(status: "n", errCode: "");
    var response;
    Map data = {
      "vid":vid,
      "txnId":txnId
    };
    //encode Map to JSON
    var body = json.encode(data);
    try {
      response = await http.post(_otpURL,
          headers: {"Content-Type": "application/json"},
          body: body
      );
    } on Exception catch (e) {
      // response = null;
      print(e);
    }
    if(response.statusCode == 200 ) {
      res = Response.fromJSON(jsonDecode(response.body));
      print("Response.statusCode = "+res.status);
      print("Response.errorCode = ${res.errCode}");
    } else {
      print("Error Occurred");
    }
    return res;
  }

  static Future<Response> verifyOTp(vid,txnId,otp) async {
    print("Inside verifyOtp func");
    Response res = new Response(status: "n", errCode: "");
    var response;
    Map data = {
      "vid":vid,
      "txnId":txnId,
      "otp":otp
    };
    //encode Map to JSON
    var body = json.encode(data);
    try {
      response = await http.post(_authURL,
          headers: {"Content-Type": "application/json"},
          body: body
      );
    } on Exception catch (e) {
      response = null;
      print(e);
    }
    if(response.statusCode == 200 ) {
      res = Response.fromJSON(jsonDecode(response.body));
      print("Verify Response.statusCode = "+res.status);
      print("Verify Response.errorCode = ${res.errCode}");
    } else {
      print("Error Occurred");
    }
    return res;
  }
}

class Response {
  String status = "n";
  String? errCode = "";

  Response({
    required this.status,
    required this.errCode
  });

  factory Response.fromJSON(Map<String,dynamic> json) {
    return Response(
      status: json["status"],
      errCode: json["errCode"]
    );
  }
}
