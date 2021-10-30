import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';

class Data{
  final String opUID;
  final DateTime date;
  final String UID;
  final double loc_lat,loc_long,add_lat,add_long;
  final int error_distance_m;
  final List gps_address,document_address,final_address;
  final String proof_file_name;
  final String txnId;
  final Uint8List filedata;

  const Data({
    required this.opUID,
    required this.date,
    required this.filedata,
    required this.txnId,
    required this.UID,
    required this.add_lat,
    required this.add_long,
    required this.loc_lat,
    required this.loc_long,
    required this.error_distance_m,
    required this.proof_file_name,
    required this.gps_address,
    required this.document_address,
    required this.final_address,
  });
Future<Map<String, dynamic>> toJson()async {
  var prefs = await SharedPreferences.getInstance();
  var opuid = prefs.getString('OpUID');
  return {
        "date":date.toIso8601String(),
        "UID":UID,
        "OpUID":opUID,
        "security":txnId,
        // "filedata":filedata,
        "final_address":final_address,
        "document_address":document_address,
        "gps_address":gps_address,
        "proof_file_name":proof_file_name,
        "error_distance_m":error_distance_m,
        "loc_long":loc_long,
        "loc_lat":loc_lat,
        "add_lat":add_lat,
        "add_long":add_long,
};
}

}
