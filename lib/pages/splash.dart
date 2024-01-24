import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../controllers/getx_splash.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SplashScreenViewModel>(
        init: SplashScreenViewModel(),
        builder: (controller) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Container(
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/logo.png',
                      width: controller.animation.value * MediaQuery.of(context).size.width,
                      height: controller.animation.value * MediaQuery.of(context).size.height,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

