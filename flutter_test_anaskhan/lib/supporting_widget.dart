import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:lottie/lottie.dart';

class SupportWidget {
  static Widget Seperator({double size = 10.0}) {
    return SizedBox(
      height: size,
    );
  }

  static Widget SeperatorWidth({double size = 10.0}) {
    return SizedBox(
      width: size,
    );
  }

  void myLoader() async {
    Future.delayed(Duration(milliseconds: 500), () {
      Get.dialog(
        AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Container(
                child: SizedBox(
              child: Lottie.asset("assets/loader.json"),
              width: 100,
              height: 100,
            ))),
        barrierDismissible: false,
        barrierColor: Colors.transparent,
      );
    });
  }

  void closeLoaders() {
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.of(Get.overlayContext!, rootNavigator: true).pop();
    });
  }
}
