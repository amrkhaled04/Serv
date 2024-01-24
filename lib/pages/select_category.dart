
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:homiee/pages/companies.dart';
import 'package:homiee/pages/login_page.dart';

import '../constants/firebase_auth_constants.dart';
import '../constants/often_used.dart';
import '../l10n/locale_keys.g.dart';
import 'history.dart';

class SelectService extends StatefulWidget {
  const SelectService({ Key? key }) : super(key: key);


  @override
  _SelectServiceState createState() => _SelectServiceState();
}

class _SelectServiceState extends State<SelectService> {
  List? services;
  List<String> idList = [];

  final TextEditingController _numberCtrl = TextEditingController();

  Future<void> getData() async{
    QuerySnapshot data = await firebaseFirestore.collection('services').get();
    setState(() {
      for (var snapshot in data.docs) {
        idList.add(snapshot.id);
      }
      services = List.from( data.docs.map((doc) => doc.data()).toList());
    });
  }

  @override
  void initState(){
    getData();
    _numberCtrl.text = "01555588986";
    super.initState();
  }

  int selectedService = -1;

  @override
  Widget build(BuildContext context) {
    return services != null?
      Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: selectedService >= 0 ?
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.07),
            child: SizedBox(
              width: 62,
              height: 62,
              child: FloatingActionButton(
                onPressed: () {
                  FlutterPhoneDirectCaller.callNumber(_numberCtrl.text);
                },
                backgroundColor: Colors.black,
                child: const Icon(Icons.support_agent_outlined, size: 30,),
              ),
            ),
          ),
          SizedBox(
            width: 62,
            height: 62,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      docId = idList[selectedService];
                      return const SelectCompany();
                    },
                  ),
                );
              },
              backgroundColor: Colors.black,
              child: const Icon(Icons.arrow_forward_ios, size: 30,),
            ),
          ),
        ],
      ) : null,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 60.0, right: 5.0, left: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.categorySelectorTitle.tr(),
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width*0.09,
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                        onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context){
                          return const HistoryPage();
                        }));},
                        child: Icon(Icons.history_outlined,size: MediaQuery.sizeOf(context).width*0.1,)),
                    GestureDetector(
                        onTap: ()async{
                          if(context.locale.languageCode == 'en'){
                            await (context.setLocale(const Locale('ar')));
                            Get.updateLocale(const Locale('ar'));
                          }else{
                            await (context.setLocale(const Locale('en')));
                            Get.updateLocale(const Locale('en'));
                          }
                        },
                        child: Icon(Icons.language_rounded,size: MediaQuery.sizeOf(context).width*0.09,)),
                    GestureDetector(
                        onTap: ()async{
                          await auth.signOut();
                          Navigator.of(context).popUntil((route) => route.isFirst);
                          Navigator.push(context, MaterialPageRoute(builder: (_){
                            return const LoginPage();
                          }));
                        },
                        child: Icon(Icons.logout_outlined,size: MediaQuery.sizeOf(context).width*0.09,)),
                  ],
                ),
              ),
            )
          ];
        },
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Divider(height: 0,thickness: 1),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: services?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return serviceContainer(services?[index]['image'] ?? "",
                        context.locale.languageCode == 'en'?
                        services![index]['name'] ?? "":
                        services?[index]['name_ar'] ?? "", index);
                  }
                ),
              ),
            ]
          ),
        ),
      ),
    )
    :loading(context);
  }

  serviceContainer(String image, String name, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selectedService == index)
            selectedService = -1;
          else
            selectedService = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: selectedService == index ? Colors.blue.shade50 : Colors.grey.shade100,
          border: Border.all(
            color: selectedService == index ? Colors.blue : Colors.blue.withOpacity(0),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(image, height: MediaQuery.of(context).size.width*0.18),
            const SizedBox(height: 20,),
            Text(name, style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.06),)
          ]
        ),
      ),
    );
  }

}
