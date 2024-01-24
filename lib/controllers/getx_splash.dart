
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:homiee/constants/firebase_auth_constants.dart';
import 'package:homiee/pages/login_page.dart';
import 'package:homiee/pages/select_category.dart';
import 'package:homiee/pages/start.dart';

User? user;
class SplashScreenViewModel extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;


  @override
  void onInit() {
    user = auth.currentUser;
    animationInitilization();
    super.onInit();
  }

  animationInitilization() async{
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut)
            .obs
            .value;
    animation.addListener(() => update());
    await animationController.forward();
    user == null ?
        Get.off(const StartPage()):
        Get.off(const SelectService());
  }
}