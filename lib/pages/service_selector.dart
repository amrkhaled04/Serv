import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:homiee/l10n/locale_keys.g.dart';
import 'package:homiee/pages/cart_page.dart';
import 'package:homiee/pages/history.dart';
import 'package:scoped_model/scoped_model.dart';

import '../constants/firebase_auth_constants.dart';
import '../constants/often_used.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../models/cart_model.dart';
import 'companies.dart';

class ServiceSelector extends StatefulWidget {
  const ServiceSelector({super.key});

  @override
  State<ServiceSelector> createState() => _ServiceSelectorState();
}

String? servicesDocId;
List<Product> _products = [];

class _ServiceSelectorState extends State<ServiceSelector> {
  List? servicesList;

  Future<void> getServicesListData() async {
    QuerySnapshot data = await firebaseFirestore
        .collection('services')
        .doc(docId)
        .collection('companies')
        .doc(servicesDocId)
        .collection("servicesList")
        .orderBy("name",descending: true)
        .get();
    setState(() {
      servicesList = List.from(data.docs.map((doc) => doc.data()).toList());
      _products = [];
      for (int i = 0; i < servicesList!.length; i++) {
        _products.add(
          Product(
              id: i + 1,
              title: servicesList?[i]['name'],
              titleAr: servicesList?[i]['name_ar'],
              price: servicesList?[i]['price'],
              qty: 1),
        );
      }
    });
  }

  @override
  void initState() {
    getServicesListData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return servicesList == null
        ? loading(context)
        : Scaffold(
            backgroundColor: Colors.white,
          body:
          NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 60.0, right: 20.0, left: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap:(){Navigator.pop(context);},
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: MediaQuery.sizeOf(context).width * 0.08,
                              )),
                          Text(
                            LocaleKeys.serviceSelectorTitle.tr(),
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
                  children: [
                    const Divider(height: 0, thickness: 1),
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                          thickness: 0.8,
                          indent: 15,
                          endIndent: 15,
                        ),
                        // itemExtent: 80,
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          return ScopedModelDescendant<CartModel>(
                              builder: (context, child, model) {
                            return ListTile(
                                title: Text(context.locale.languageCode == 'en' ?
                                _products[index].title :
                                  _products[index].titleAr
                                  ,style: const TextStyle(fontWeight: FontWeight.w600),),
                                subtitle: Text("E£ ${_products[index].price}",style: const TextStyle(fontWeight: FontWeight.w500),),
                                trailing: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.black,
                                        shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                    child: const Icon(
                                        Icons.add_shopping_cart_rounded),
                                    onPressed: () {
                                      CherryToast.success(
                                          animationDuration:  const Duration(milliseconds:  500),
                                          toastDuration:  const Duration(milliseconds:  800),
                                          toastPosition: Position.bottom,
                                          title:  Text(LocaleKeys.addedToCart.tr(), style: const TextStyle(color: Colors.black))
                                      ).show(context);
                                        model.addProduct(_products[index]);}));
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomSheet: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return CartPage();
                        }));
                  },
                  child: Text(
                    LocaleKeys.goToCart.tr(),
                    style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width *0.053),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: FlutterFlowTheme.of(context).primary,
                      fixedSize: Size(MediaQuery.of(context).size.width*0.85, MediaQuery.of(context).size.height*0.065),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ),
          );
  }
}
