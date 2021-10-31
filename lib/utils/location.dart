import 'package:geolocator/geolocator.dart';//compile_sdk to 31
import 'package:geocoding/geocoding.dart';
class location{

  static double add_lat=0,add_long=0,loc_lat=0,loc_long=0;
  static List doc_address =[] ,gps_address=[];

  static Future<List<String>> getPlace() async {

    try{
      Position p = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);//get best accuracy location
      List<Placemark> placemarks = await placemarkFromCoordinates(p.latitude,p.longitude);//get address from coordiantes
      location.loc_lat = p.latitude;
      location.loc_long = p.longitude;
      location.gps_address = [placemarks[0].name.toString(),placemarks[0].subThoroughfare.toString(),placemarks[0].thoroughfare.toString()+placemarks[0].subLocality.toString(),placemarks[0].locality.toString(),placemarks[0].subAdministrativeArea.toString(),placemarks[0].administrativeArea.toString()+", "+placemarks[0].postalCode.toString()];
      return [[placemarks[0].name!,placemarks[0].subThoroughfare!.isNotEmpty,placemarks[0].thoroughfare!].join(', '),[placemarks[0].subLocality!,placemarks[0].locality,placemarks[0].subAdministrativeArea!,placemarks[0].administrativeArea!,placemarks[0].postalCode!].join(', ')];
    }

    catch(e)
    {
      return Future.error(e);
    }

  }
  static Future<int> check(address) async {
    try {
      Position p = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);//coordinates of gps
      List<Location> locations = await locationFromAddress(address);
      print(locations[0].toString());
      address.toString().split(',').removeWhere((element)=>
      element.toString()== ' ');
      location.doc_address = address.toString().split(',');
      location.add_lat = locations[0].latitude;
      location.add_long = locations[0].longitude;//get coordinates of the address
      return Geolocator.distanceBetween(p.latitude,p.longitude,locations[0].latitude,locations[0].longitude).toInt();
    } on Exception catch (e) {
      print("Error = "+e.toString());
      return Future.error(e);
    }
//distance bw two cordinates

  }
  static void clear()
  {
    location.add_lat = 0;
    location.add_long =0;
    location.doc_address = [];
    location.gps_address =[];
    location.loc_lat = 0;
    location.loc_long = 0;
  }
}