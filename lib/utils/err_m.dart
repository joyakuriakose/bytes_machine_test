import 'package:flutter/material.dart';
import 'package:get/get.dart';

void errM(Function() f, {String msg = "", String title = "Error"}) {
  try {
    f();
  } catch (e) {
    if (msg.isEmpty) {
      msg = e.toString();
    }

    showMsg(msg, title);
  }
}

Future errMAsync(Future<void> Function() f,
    {String msg = "",
    String title = "Error",
    isShowMsg = true,
    dialogDismiss = false}) async {
  try {
    await f();
  } catch (e) {
    if (msg.isEmpty) {
      msg = e.toString();
    }
    if (dialogDismiss) {
      Get.back();
    }
    if (isShowMsg) {
      showMsg(msg, title);
    }
  }
}

void showMsg(String msg, String title, {leadingIcon, isSuccess = false}) {
  Get.snackbar(
    title,
    msg,
    icon: leadingIcon,
    snackPosition: SnackPosition.TOP,
    backgroundColor:
        isSuccess ? Colors.green : const Color.fromARGB(255, 177, 46, 46),
    colorText: Colors.white,
    borderRadius: 5,
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.all(10),
  );
}
