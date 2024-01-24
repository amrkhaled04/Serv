
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:homiee/l10n/locale_keys.g.dart';
import 'package:homiee/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:homiee/pages/service_selector.dart';
import 'package:scoped_model/scoped_model.dart';

import '../constants/firebase_auth_constants.dart';
import '../constants/often_used.dart';
import 'date_time.dart';
import 'history.dart';

class SelectCompany extends StatefulWidget {
  const SelectCompany({ Key? key }) : super(key: key);

  @override
  _SelectCompanyState createState() => _SelectCompanyState();
}
  String? docId;

class _SelectCompanyState extends State<SelectCompany> {
  List? companies;
  List<String> idList = [];

  Future<void> getCompaniesData() async{
    QuerySnapshot data = await firebaseFirestore.collection('services').doc(docId).collection('companies').get();
    setState(() {
      for (var snapshot in data.docs) {
        idList.add(snapshot.id);
      }
      companies = List.from( data.docs.map((doc) => doc.data()).toList());
    });
  }

  @override
  void initState(){
    getCompaniesData();
    super.initState();
  }

  int selectedService = -1;

  @override
  Widget build(BuildContext context) {
    return companies != null?
      WillPopScope(
        onWillPop: ()async{
          if(ScopedModel.of<CartModel>(context).cart.isEmpty) {
            Navigator.pop(context);
          }
          else {
            AwesomeDialog(
              context: context,
              dialogType: DialogType.noHeader,
              animType: AnimType.scale,
              transitionAnimationDuration: Duration(
                  milliseconds: 200),
              title: LocaleKeys.warning.tr(),
              desc: LocaleKeys.clearWarning.tr(),
              btnCancelOnPress: () {},
              btnCancelColor: Colors.red,
              btnOkColor: Colors.black,
              btnOkOnPress: () {
                ScopedModel.of<CartModel>(context)
                    .clearCart();
                Navigator.pop(context);
              },
            )
              .show();
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: selectedService >= 0 ? Container(
            width: 62,
            height: 62,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                        servicesDocId = idList[selectedService];
                        companyName = companies?[selectedService]['name'];
                        companyImage = companies?[selectedService]['image'];
                      return const ServiceSelector();
                    },
                  ),
                );
              },
              child: Icon(Icons.arrow_forward_ios, size: 30,),
              backgroundColor: Colors.black,
            ),
          ) : null,
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60.0, right: 20.0, left: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap:(){
                              if(ScopedModel.of<CartModel>(context).cart.isEmpty) {
                                Navigator.pop(context);
                              }
                              else {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.noHeader,
                                  animType: AnimType.scale,
                                  transitionAnimationDuration: Duration(
                                      milliseconds: 200),
                                  title: LocaleKeys.warning.tr(),
                                  desc: LocaleKeys.clearWarning.tr(),
                                  btnCancelColor: Colors.red,
                                  btnOkColor: Colors.black,
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {
                                    ScopedModel.of<CartModel>(context)
                                        .clearCart();
                                    Navigator.pop(context);
                                  },
                                )
                                  ..show();
                              }
                              },
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: MediaQuery.sizeOf(context).width * 0.08,
                            )),
                        Text(
                          LocaleKeys.companiesTitle.tr(),
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width*0.085,
                            color: Colors.grey.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                            onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context){
                              return const HistoryPage();
                            }));},
                            child: Icon(Icons.history_outlined,size: MediaQuery.sizeOf(context).width*0.11,))
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
                          itemCount: companies?.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            return companyContainer(companies?[index]['image'] ?? "", companies?[index]['name'] ?? "", index);
                          }
                      ),
                    ),
                  ]
              ),
            ),
          )
    ),
      ):
        loading(context);
  }

  companyContainer(String image, String name, int index) {
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
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(10.0),
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
              Image.network(image, height: MediaQuery.of(context).size.width*0.22),
              const SizedBox(height: 20,),
              Text(name, style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.06),)
            ]
        ),
      ),
    );
  }
}
