import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';



abstract class MyUtils {
  static void hideKeyboard(){
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  static msg(List<dynamic>? msgs){
    if(msgs == null || msgs.isEmpty) return;
    Get.snackbar(msgs[0].title, msgs[0].msg,backgroundColor: msgs[0].msgType == "0"?const Color.fromARGB(255, 177, 46, 46):null,colorText: Colors.white);
  }

  static List<T> getListFromJson<T>(dynamic str){
    return List<T>.from(str.rdata.map((T) => T.fromJson(T)));
  }
}