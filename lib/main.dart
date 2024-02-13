import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:homiee/pages/cart_page.dart';
import 'package:homiee/pages/splash.dart';
import 'package:scoped_model/scoped_model.dart';

import 'models/cart_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  runApp(
      EasyLocalization(
      supportedLocales: const [ Locale('en'),Locale('ar')],
      path: 'assets/translations',
      saveLocale: true,
      startLocale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      child: MyApp(model: CartModel())));
}

class MyApp extends StatelessWidget {
  final CartModel model;

  const MyApp({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModel<CartModel>(
      model: model,
      child: GetMaterialApp(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: false),
        title: 'Shopping Cart',
        home: const SplashScreen(),
        localizationsDelegates:context.localizationDelegates ,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        routes: {'/cart': (context) => CartPage()},
      ),
    );
  }
}
