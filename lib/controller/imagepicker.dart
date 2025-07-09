import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
class ImagepickerController extends GetxController{
  File? fileImage;
  Future<void> Image() async {
    final ImagePicker picker = ImagePicker();
     final xFiles=await picker.pickImage(source: ImageSource.gallery);
     if(xFiles==null){
       return;
     }else{
       fileImage=File(xFiles.path);
       print("Image=${fileImage}");
       update();
     }
  }
}