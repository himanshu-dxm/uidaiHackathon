import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:aadharupdater/api/LocalAuthAPI.dart';
import 'package:aadharupdater/models/Auth.dart';
import 'package:aadharupdater/screens/demoScreen.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/location.dart';
import '../utils/capture.dart';
import '../models/data.dart';
import '../utils/compare.dart';
import 'package:uuid/uuid.dart';
import '../provider/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  bool isLoading = false; //Loading of page
  final _controller = CropController(); // controller for Image Cropper
  bool show = false; // show the image
  var data; // image data
  var address, perm;
  bool uid = false;
  var len = 1000;
  static var pos1, pos2;
  bool otpsent = false;
  bool enter = true;
  bool showotp = false;
  bool caneditUID = true;
  static String output = 'null';
  static TextEditingController c1 =
      new TextEditingController(); // field1 contoller
  static TextEditingController c2 =
      new TextEditingController(); //field 2 controller
  static TextEditingController UIDTextContoller =
      new TextEditingController(); //for UID
  static TextEditingController OTPTextContoller =
      new TextEditingController(); //for OTP

  static String generateTxnId() {
    var uuid = Uuid();
    print("txnID = "+uuid.v4());
    return(uuid.v4());
  }
  String txnId = generateTxnId();
  String backEndOTP = "";
  static Future<void> getLocation() async {
    //function to get the location of the mobile using gps
    List<String> i = await location.getPlace();
    pos1 =
        (i[0] != null) ? i[0].toString() : "NA"; // editable  like house number
    pos2 = (i[1] != null) ? i[1].toString() : "NA"; // non editable like state
    print("Pos1 = " + pos1);
    print("Pos2 = " + pos2);
  }

  Widget build(context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : //if loading return Progress indicator
        Scaffold(
            appBar: AppBar(
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(80),
                      bottomRight: Radius.circular(80),)),
              backgroundColor: Colors.black,
              title: Center(child: Text(AppLocalizations.of(context)!.details,style: TextStyle(color: Colors.white),)),
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  !uid
                      ? Container(
                          margin: EdgeInsets.all(2),
                          padding: EdgeInsets.all(2),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                margin: EdgeInsets.all(8),
                                padding: EdgeInsets.all(2),
                                child: TextField(
                                  controller: UIDTextContoller, // UID
                                  maxLength: 12,

                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                            Icons.qr_code_scanner_outlined),
                                        onPressed: () async {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          var val;
                                          try {
                                            val = await ImageProcessing
                                                .qrCodeCapture();
                                          } catch (e) {
                                            print(e);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Error in getting barcode")));
                                          }
                                          setState(() {
                                            UIDTextContoller.text =
                                                val.toString();
                                            isLoading = false;
                                          });
                                        },
                                      ),
                                      hintText: AppLocalizations.of(context)!.uid,
                                      labelText: AppLocalizations.of(context)!.uid,
                                      enabled: caneditUID),
                                  keyboardType: TextInputType.number,
                                  onSubmitted: (val) async {
                                    if (val.length == 12) {
                                      setState(() {
                                        showotp = true;
                                      });
                                    } else {
                                      setState(() {
                                        showotp = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text("Enter Valid UID")));
                                    }
                                  },
                                ),
                              ),

                              // SizedBox(height: 8,),

                              showotp
                                  ? Container(
                                      margin: EdgeInsets.all(8),
                                      padding: EdgeInsets.all(2),
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.black),
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.yellowAccent),
                                          ),
                                          onPressed: () async {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            // Response res =
                                                await Authentication.sendOTP(
                                                    UIDTextContoller.text,
                                                    txnId).then((res) async {
                                                      setState(() {
                                                        otpsent = true;
                                                      });
                                              if (res.status == 'y') {
                                              setState(() {
                                                 //otp sending
                                                isLoading = false;
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          'OTP Sent to Number')));
                                            } else if (res.status == 'n') {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "OTP Not Sent")));
                                              isLoading = false;
                                            } else if(res.status==null) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "OTP Not Sent")));
                                              isLoading = false;
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content:
                                                          Text("Sending OTP")));
                                            }
                                            setState(() {
                                              isLoading = false;
                                            });
                                          });
                                        },
                                          child: Text("Get OTP")),
                                    )
                                  : SizedBox(),

                              SizedBox(
                                height: 15,
                              ),

                              otpsent
                                  ? Container(
                                      margin: EdgeInsets.all(8),
                                      padding: EdgeInsets.all(2),
                                      child: TextField(
                                        obscureText: true,
                                        controller: OTPTextContoller,
                                        decoration: InputDecoration(
                                            hintText: 'Enter OTP',
                                            labelText: 'OTP',
                                            border: OutlineInputBorder()),
                                        keyboardType:
                                            TextInputType.numberWithOptions(
                                                decimal: false, signed: false),
                                        onSubmitted: (val) async {
                                          Response res =
                                              await Authentication.verifyOTp(
                                                  UIDTextContoller.text,
                                                  txnId,
                                                  OTPTextContoller.text);
                                          if (res.status == 'y') {
                                            //proceed
                                            setState(() {
                                              enter = true;
                                              showotp = false;
                                              otpsent = false;
                                              caneditUID = false;
                                            });
                                          } else if (OTPTextContoller
                                                  .text.length >
                                              6) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'OTP should be 6 characters in length!')));
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'OTP is Wrong !')));
                                          }
                                        },
                                      ),
                                    )
                                  : SizedBox(
                                      height: 0,
                                    )
                            ],
                          ),
                        )
                      : SizedBox(
                          height: 0,
                        ),
                  enter && !show
                      ? Container(
                          margin: EdgeInsets.all(2),
                          padding: EdgeInsets.all(2),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                margin: EdgeInsets.all(8),
                                padding: EdgeInsets.all(2),
                                child: TextField(
                                  //flatno/houseno
                                  controller: c1,
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)!.localaddress,
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                margin: EdgeInsets.all(8),
                                padding: EdgeInsets.all(2),
                                child: TextField(
                                  //street
                                  controller: c2,
                                  maxLines: 2,
                                  decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)!.mainaddress,
                                      enabled: false,
                                      border: OutlineInputBorder()),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          height: 0,
                        ),
                  (enter)
                      ? Container(
                          margin: EdgeInsets.all(2),
                          padding: EdgeInsets.all(2),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 8,
                              ),

                              output != 'null'
                                  ? Container(
                                      margin: EdgeInsets.all(2),
                                      padding: EdgeInsets.all(2),
                                      child: Text(
                                          output), // error length as output
                                    )
                                  : SizedBox(),
                              //button to capture image
                              Center(
                                child: ElevatedButton(
                                  child: Text(AppLocalizations.of(context)!.capture_image.toString()),
                                  onPressed: () async {
                                    //get image from camera
                                    //edited
                                    setState(() {
                                      isLoading = true;
                                    });
                                    try {
                                      data = await ImageProcessing
                                          .getImage(); //get image from  camera
                                      setState(() {
                                        show = true; //show the editor
                                        isLoading = false;
                                      });
                                    } catch (e) {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "error in getting image")));
                                    }
                                  },
                                ),
                              ),
                              //image editor
                              show == true
                                  ? Container(
                                      margin: EdgeInsets.all(1),
                                      padding: EdgeInsets.all(1),
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      child: Crop(
                                        image: data, //crop the image data
                                        controller: _controller,
                                        onCropped: (imageCropped) async {
                                          //imageCropped holds the cropped image
                                          try {
                                            setState(() {
                                              show = false;
                                              isLoading = true;
                                            });
                                            await MyHomePageState.getLocation();
                                            setState(() {
                                              c2.text = MyHomePageState.pos2;
                                            });
                                            var ans = await ImageProcessing
                                                .extractText(
                                                    imageCropped); //process text
                                            var s = await Compare.compareDetails(
                                                ans.toString(),
                                                MyHomePageState.pos2
                                                    .toString()); // Compare and filter the details
                                            setState(() {
                                              c1.text = s;
                                              isLoading = false;
                                              c2.text = MyHomePageState.pos2.toString();
                                            });
                                          } on Exception catch (e) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Error in Text Extraction")));
                                          }
                                        },
                                      ),
                                    )
                                  : SizedBox(),

                              show == true
                                  ? ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          _controller
                                              .crop(); //cropped image is callbacked

                                          //  setState(() {
                                          //    isLoading = false;
                                          //  });
                                        } catch (e) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          //  print(e);
                                        }
                                      },
                                      child: Text(AppLocalizations.of(context)!.extract))
                                  : SizedBox(),

                              show == false
                                  ? ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          setState(() {
                                            isLoading = true;
                                          });

                                          len = await location.check(c1.text
                                                  .toString() +
                                              ', ' +
                                              c2.text
                                                  .toString()); // check the error distance
                                          if (len > 200) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Error distance is more than 200m")));
                                          }
                                          setState(() {
                                            output = "${AppLocalizations.of(context)!.errordistance}:" +
                                                len.toString() +
                                                "m";
                                            print("Output = " +
                                                output.toString());
                                            show = false;
                                            isLoading = false;
                                          });
                                        } catch (e) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          //  print(e);
                                        }
                                      },
                                      child: Text(AppLocalizations.of(context)!.validate))
                                  : SizedBox(),

                              // output!="null"?Container(child: Text(output.toString()),):SizedBox(),

                              if (!show && len <= 200)
                                Container(
                                  margin: EdgeInsets.all(8),
                                  padding: EdgeInsets.all(8),
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        var prefs = await SharedPreferences
                                            .getInstance();
                                        var OpID = prefs.getString('OpID');
                                        List fa = (c1.text.toString() +
                                                "," +
                                                c2.text.toString())
                                            .split(',');
                                        Data data = new Data(
                                          date: DateTime.now(),
                                          txnId: txnId.toString(),
                                          OpID: OpID.toString(),
                                          UID: UIDTextContoller.text.toString(),
                                          add_lat: location.add_lat,
                                          add_long: location.add_long,
                                          loc_lat: location.loc_lat,
                                          loc_long: location.loc_long,
                                          error_distance_m: len,
                                          proof_file_name:
                                              ImageProcessing.savePath,
                                          filedata: ImageProcessing.saveData,
                                          gps_address: location.gps_address,
                                          document_address:
                                              location.doc_address,
                                          final_address: fa,
                                        );
                                        setState(() {
                                          isLoading = true;
                                        });
                                        try {
                                          var jsonData = await jsonEncode(
                                              await data.toJson());

                                          ///encode to json
                                          var d =
                                              await getExternalStorageDirectory();
                                          await File(d!.path.toString() +
                                                  "IMP_FILES.json")
                                              .exists()
                                              .then((value) async {
                                            if (value) {
                                              print("yes");
                                              var prev = await File(
                                                      d.path.toString() +
                                                          "IMP_FILES.json")
                                                  .readAsString();
                                              print(prev);
                                              prev = prev.replaceFirst(
                                                  new RegExp(r'}]'),
                                                  "}," +
                                                      jsonData.toString() +
                                                      "]"); //convert into valid json format by appending to list
                                              File(d.path.toString() +
                                                      "IMP_FILES.json")
                                                  .writeAsStringSync(prev);
                                            } else {
                                              File(d.path.toString() +
                                                      "IMP_FILES.json")
                                                  .writeAsStringSync("[" +
                                                      jsonData.toString() +
                                                      "]");
                                            }
                                            setState(() {
                                              //clear to defaults
                                              show =
                                                  false; // dont show the image
                                              address = null;
                                              perm = null;
                                              uid = false;
                                              len = 0;
                                              pos1 = null;
                                              pos2 = null;
                                              otpsent = false;
                                              enter = false;
                                              showotp = false;
                                              caneditUID = true;
                                              output = 'null';
                                              c1.clear();
                                              c2.clear();
                                              UIDTextContoller.clear();
                                              OTPTextContoller.clear();
                                              location.clear();
                                              ImageProcessing.clear();
                                              isLoading =
                                                  false; //Loading of page
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text("saved")));
                                          });
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text("error")));
                                          print("error" + e.toString());
                                        }
                                        setState(() {
                                          isLoading = false;
                                        });
                                      },
                                      child: Text(AppLocalizations.of(context)!.confirm)),
                                )
                              else
                                SizedBox(),
                            ],
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          );
  }
}
