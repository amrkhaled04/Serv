import 'package:flutter/material.dart';
import 'package:homiee/pages/select_category.dart';
import 'package:lottie/lottie.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/cart_model.dart';

class DoneLottie extends StatefulWidget {
  const DoneLottie({super.key});

  @override
  State<DoneLottie> createState() => _DoneLottieState();
}


class _DoneLottieState extends State<DoneLottie> {
  @override
  void initState(){

    Future.delayed(Duration(milliseconds: 3000),() {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return SelectService();
      }));
      ScopedModel.of<CartModel>(context).clearCart();
    },);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Lottie.asset("assets/lotties/done.json"),
        ),
      ),
    );
  }
}



