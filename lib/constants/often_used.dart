import 'package:flutter/material.dart';




Widget loading(BuildContext context){
  return Stack(
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          color: Colors.white,
        ),
        Center(
            child:Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 8,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: const Color(0xFFFAFBFD)),
              child: const CircularProgressIndicator(
                color: Colors.black,
              ),
            )
        ),
      ]
  );
}
