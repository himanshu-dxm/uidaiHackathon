import 'dart:io';
import 'dart:typed_data';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
class ImageProcessing{

  static var savePath,saveData,path,data;//path of image and data of image
  static void clear()
  {
    ImageProcessing.saveData = null;
    ImageProcessing.savePath = null;
    ImageProcessing.path = null;
    ImageProcessing.data = null;
  }
  static Future<Uint8List> getImage()async
  {
    //image picking
    try {

      final image = await ImagePicker().pickImage(source: ImageSource.camera,preferredCameraDevice: CameraDevice.rear);
      final d = await getExternalStorageDirectory(); //get extranal directory for saving images
      var relpath='';
      for(var i in d!.path.split('/'))
      {
        if(i.toString()=='Android')
        {
          break;
        }
        else relpath+=i.toString()+'/';
      }
      relpath+='AadharUpdater';
      print(relpath);

      if (image != null && d!=null) //filter null values
          {
        final time = DateTime.now().microsecondsSinceEpoch; //unique name for file from date and time
        await image.saveTo(d.path+"/$time.jpg");//save the image
        //need to verify
        // await Directory(relpath).create(recursive: true).then((value) async{
        //   print("created");
        //   await File(relpath+'/$time.jpg').create().then((value)async{
        //   await image.saveTo(value.path);
        // }).catchError((e){print(e);});
        // }).catchError((e){print(e);});

        path  = d.path+"/$time";
        savePath = path+".jpg"; //for final purpose
        data =await image.readAsBytes();//get the byte data
        saveData = data; // for final purpose
        return data;
      }
      else
      {
        return Future.error('Error in getting image');
      }
    }
    on Exception catch (e) {
      return Future.error("Error in Image Capturing");
    }

  }


  static Future<String> extractText(Uint8List data)async
  {
    try {
      //data is in bytes and is cropped image
      await File(path+'cropped.jpg').writeAsBytes(data);//save the cropped image
      final input = InputImage.fromFilePath(path+'cropped.jpg');//get the cropped image
      final textDetector = GoogleMlKit.vision.textDetector();//init the detector
      final response = await textDetector.processImage(input);//process input

      textDetector.close();//close the detector

      var l= [];

      for(var i in response.blocks)
      {
        i.lines.forEach((element) {//get the blocks of text
          l.add(i.text.toString());//add each word to list
        });
      }

      path = null;//change the image path to null

      return l.join(' ').toString();

    } on Exception catch (e) {
      path = null;
      return Future.error('Error in extracting text:$e');
    }finally{
      path = null;
    }
  }
}