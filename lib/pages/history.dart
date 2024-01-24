import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:homiee/l10n/locale_keys.g.dart';

import '../constants/firebase_auth_constants.dart';
import '../constants/often_used.dart';


class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

List? history;

class _HistoryPageState extends State<HistoryPage> {

  Future<void> getHistoryData() async{
    QuerySnapshot data = await firebaseFirestore.collection("users").doc(auth.currentUser?.uid).collection("history").get();
    setState(() {
      history = List.from( data.docs.map((doc) => doc.data()).toList());
    });
  }

  @override
  void initState(){
    getHistoryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return history != null ? Scaffold(
      body:   NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding:
                const EdgeInsets.only(top: 60.0, right: 20.0, left: 20.0),
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
                      LocaleKeys.history.tr(),
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width *0.048,
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(width: MediaQuery.sizeOf(context).width * 0.11,)
                  ],
                ),
              ),
            )
          ];
        },
        body: history?.length == 0 ? Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.368,vertical:MediaQuery.of(context).size.height*0.37 ),
          child: Text(LocaleKeys.noOrdersYet.tr(),style: TextStyle(fontSize: MediaQuery.of(context).size.width *0.053),),
        ) :Padding(
          padding: const EdgeInsets.all(10),
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
                  itemCount: history?.length ?? 0,
                  itemBuilder: (context, index) {
                          return ListTile(
                              leading: Image.network(history?[index]['companyImage']),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(history?[index]['companyName'],style: const TextStyle(fontWeight: FontWeight.w600),),
                                  Text(history?[index]['date'],style: const TextStyle(fontWeight: FontWeight.w300),),
                                ],
                              ),
                              // trailing: Icon(Icons.arrow_forward_ios_outlined),
                              );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ) : loading(context);
  }

}
