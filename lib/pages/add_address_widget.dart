
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:homiee/pages/date_time.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../constants/firebase_auth_constants.dart';
import '../l10n/locale_keys.g.dart';
import '../models/add_address_model.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  late AddAddressModel _model;

  String phonenum = '';
  int addresscount = 0;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddAddressModel());

    _model.namecontroller ??= TextEditingController();
    _model.textController2 ??= TextEditingController();
    _model.areacontroller ??= TextEditingController();
    _model.buildingcontroller ??= TextEditingController();
    _model.streetcontroller ??= TextEditingController();
    _model.apartcontroller ??= TextEditingController();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          leading: GestureDetector(
              onTap:(){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                return const DateAndTime();
              }));},
              child: Icon(
                Icons.arrow_back_ios,
                size: MediaQuery.sizeOf(context).width * 0.08,
              )),
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            LocaleKeys.addAddress.tr(),
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width *0.065,
                ),
          ),
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: const AlignmentDirectional(0.0, -1.0),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(0.0, 25.0, 0.0, 0.0),
                    child: FlutterFlowDropDown<String>(
                      controller: _model.dropDownValueController ??=
                          FormFieldController<String>(null),
                      options: const [
                        'Cairo',
                        'Giza',
                        'Al Qalyubya',
                        'Alexandria',
                        'Fayoum',
                        'North Coast',
                        'Ash Sharqia',
                        'Kafr El Sheikh',
                        'Suez',
                        'Damnhour',
                        'Assuit',
                        'Port Said',
                        'Hurghada',
                        'Monufia',
                        'Tanta',
                        'Sohag',
                        'El Minya',
                        'Aswan',
                        'Qwesna',
                        'Menouf',
                        'Shebeen El koom',
                        'Kafr El Dawar',
                        'Ras El Bar',
                        'El Mansoura',
                        'Ismailia',
                        'Ain Sokhna',
                        'Damietta',
                        'Banha',
                        'Al Mahallah Al Kubra',
                        'Kafr El Zayat',
                        'Mit Ghamr',
                        'Rashid',
                        'Baltim',
                        'Mallawi',
                        'Qena',
                        'Luxor',
                        'Janoub Sinai',
                        'Marsa Matrouh',
                        'Beni Suef',
                        'New Damietta'
                      ],
                      onChanged: (val) =>
                          setState(() => _model.dropDownValue = val),
                      width: 350.0,
                      height: 50.0,
                      searchHintTextStyle:
                          FlutterFlowTheme.of(context).labelMedium,
                      textStyle: FlutterFlowTheme.of(context).bodyMedium,
                      hintText: LocaleKeys.city.tr(),
                      searchHintText: LocaleKeys.searchCity.tr(),
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24.0,
                      ),
                      fillColor: FlutterFlowTheme.of(context).primaryBackground,
                      elevation: 2.0,
                      borderColor: FlutterFlowTheme.of(context).alternate,
                      borderWidth: 2.0,
                      borderRadius: 8.0,
                      margin:
                          const EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 16.0, 4.0),
                      hidesUnderline: true,
                      isSearchable: true,
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(8.0, 25.0, 8.0, 0.0),
                    child: SizedBox(
                      width: 350.0,
                      child: TextFormField(
                        controller: _model.namecontroller,
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.fullName.tr(),
                          labelStyle: FlutterFlowTheme.of(context).labelMedium,
                          hintStyle: FlutterFlowTheme.of(context).labelMedium,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium,
                        validator: _model.textController1Validator
                            .asValidator(context),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 350,
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(0.0, 25.0, 0.0, 0.0),
                    child: Align(
                        alignment: const AlignmentDirectional(0.0, 0.0),
                        child: IntlPhoneField(
                          keyboardType: const TextInputType.numberWithOptions(),
                          controller: _model.phonecontroller,
                          decoration: InputDecoration(
                            labelText: LocaleKeys.phoneNumber.tr(),
                            labelStyle:
                                FlutterFlowTheme.of(context).labelMedium,
                            hintStyle: FlutterFlowTheme.of(context).labelMedium,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          initialCountryCode: 'EG',
                          onChanged: (phone) {
                            phonenum = phone.completeNumber;
                            print(phone.completeNumber);
                          },
                        )),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(8.0, 25.0, 8.0, 0.0),
                    child: SizedBox(
                      width: 350.0,
                      child: TextFormField(
                        controller: _model.areacontroller,
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.area.tr(),
                          labelStyle: FlutterFlowTheme.of(context).labelMedium,
                          hintStyle: FlutterFlowTheme.of(context).labelMedium,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium,
                        validator: _model.textController3Validator
                            .asValidator(context),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(8.0, 25.0, 8.0, 0.0),
                    child: SizedBox(
                      width: 350.0,
                      child: TextFormField(
                        controller: _model.buildingcontroller,
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.buildingName.tr(),
                          labelStyle: FlutterFlowTheme.of(context).labelMedium,
                          hintStyle: FlutterFlowTheme.of(context).labelMedium,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium,
                        validator: _model.textController4Validator
                            .asValidator(context),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(8.0, 25.0, 8.0, 0.0),
                    child: SizedBox(
                      width: 350.0,
                      child: TextFormField(
                        controller: _model.streetcontroller,
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.streetName.tr(),
                          labelStyle: FlutterFlowTheme.of(context).labelMedium,
                          hintStyle: FlutterFlowTheme.of(context).labelMedium,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium,
                        validator: _model.textController5Validator
                            .asValidator(context),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(8.0, 25.0, 8.0, 0.0),
                    child: SizedBox(
                      width: 350.0,
                      child: TextFormField(
                        controller: _model.apartcontroller,
                        autofocus: false,
                        obscureText: false,
                        decoration: InputDecoration(
                          labelText: LocaleKeys.floorNo.tr(),
                          labelStyle: FlutterFlowTheme.of(context).labelMedium,
                          hintStyle: FlutterFlowTheme.of(context).labelMedium,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium,
                        validator: _model.textController6Validator
                            .asValidator(context),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1),
                  child: ElevatedButton(
                    onPressed: () {
                      if(
                      _model.apartcontroller == null ||
                      _model.dropDownValue == null ||
                      _model.namecontroller == null ||
                      _model.areacontroller == null ||
                      _model.buildingcontroller == null ||
                      _model.streetcontroller == null ||
                      phonenum.isEmpty
                      ){
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.noHeader,
                          animType: AnimType.scale,
                          transitionAnimationDuration: const Duration(milliseconds: 175),
                          title: LocaleKeys.warning.tr(),
                          btnOkColor: Colors.black,
                          desc: LocaleKeys.fillWarning.tr(),
                          btnOkOnPress: () {},
                        )..show();
                      }
                      else {
                        final user = auth.currentUser;
                        setState(() {
                          ++addresscount;
                        });
                        firebaseFirestore
                            .collection("users")
                            .doc(user?.uid)
                            .collection("addresses")
                            .doc("${user!.uid}_${DateTime.now()}")
                            .set({
                          "City": _model.dropDownValue,
                          "Full name": _model.namecontroller.text,
                          "Phone": phonenum,
                          "Area": _model.areacontroller.text,
                          "Compound/Building name":
                          _model.buildingcontroller.text,
                          "Street": _model.streetcontroller.text,
                          "Floor,apartment,or villa no.":
                          _model.apartcontroller.text,
                          "latitude":currentPosition?.latitude ?? "",
                          "longitude":currentPosition?.longitude ?? ""
                        });
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                              return const DateAndTime();
                            }));
                      }
                    },
                    child: Text(
                      LocaleKeys.save.tr(),
                      style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width *0.053),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: FlutterFlowTheme.of(context).primary,
                        fixedSize: Size(MediaQuery.of(context).size.width*0.85, MediaQuery.of(context).size.height*0.065),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
