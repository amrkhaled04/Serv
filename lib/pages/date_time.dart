import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:homiee/flutter_flow/flutter_flow_util.dart';
import 'package:homiee/l10n/locale_keys.g.dart';
import 'package:homiee/models/cart_model.dart';
import 'package:homiee/pages/add_address_widget.dart';
import 'package:homiee/pages/done_lottie.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../constants/firebase_auth_constants.dart';
import '../flutter_flow/flutter_flow_theme.dart';

class DateAndTime extends StatefulWidget {
  const DateAndTime({Key? key}) : super(key: key);

  @override
  _DateAndTimeState createState() => _DateAndTimeState();
}

String companyName = "";

String companyImage = "";

List<String> Dservices = [];

List<String> Dprices = [];

int groupValue = -1;

Position? currentPosition;

FToast? fToast;

class _DateAndTimeState extends State<DateAndTime> {
  int _selectedDay = 0;
  // int _selectedRepeat = 0;
  String _selectedHour = '10:00 PM';
  // List<int> _selectedExteraCleaning = [];

  ItemScrollController _scrollController = ItemScrollController();

  final user = auth.currentUser;
  
  bool clicked = false;
  int addressCount = 0;

  final List<dynamic> _days = [
    [1, 'Fri'],
    [2, 'Sat'],
    [3, 'Sun'],
    [4, 'Mon'],
    [5, 'Tue'],
    [6, 'Wed'],
    [7, 'Thu'],
  ];

  DateTime today = DateTime.now();

  final List<String> _hours = <String>[
    '08:00 AM',
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
    '06:00 PM',
    '07:00 PM',
    '08:00 PM',
    '09:00 PM',
    '10:00 PM',
    '11:00 PM',
    '12:00 PM',
  ];

  int _orderCounter = 1;

  String? _dayWord;
  int? _dayNum;

  List<int> radioCount = [];
  int _selectedRepeat = 0;
  final List<String> _repeat = [
    'No repeat',
    'Every day',
    'Every week',
    'Every month'
  ];


  int length = CartModel().cart.length;

  List? addresses;

  Future<void> getAddressesData() async {
    QuerySnapshot data = await firebaseFirestore
        .collection("users")
        .doc(user?.uid)
        .collection("addresses")
        .get();
    setState(() {
      addresses = List.from(data.docs.map((doc) => doc.data()).toList());
      for(int i = 0; i<addresses!.length;i++){
        radioCount.add(i);
      }
    });
  }

  @override
  void initState() {
    for (int i = 1; i < 8; i++) {
      _dayNum = int.parse(DateFormat.d().format(today.add(Duration(days: i))));
      _dayWord = DateFormat.E().format(today.add(Duration(days: i)));
      for (int c = 0; c < 2; c++) {
        _days[i - 1][0] = _dayNum;
        _days[i - 1][1] = _dayWord;
      }
    }
    _selectedDay = _days[3][0];
    Future.delayed(const Duration(milliseconds: 500), () {
      _scrollController.scrollTo(
        index: 24,
        duration: const Duration(seconds: 3),
        curve: Curves.easeInOut,
      );
    });
    getAddressesData();
    super.initState();
    fToast = FToast();
    fToast?.init(context);
  }

  String? _currentAddress;


  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        currentPosition!.latitude, currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => currentPosition = position);
      _getAddressFromLatLng(currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: Container(
            width: 62,
            height: 62,
            child: FloatingActionButton(
              onPressed: () {
                if(groupValue == -1) {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.noHeader,
                    animType: AnimType.scale,
                    btnOkColor: Colors.black,
                    transitionAnimationDuration: const Duration(milliseconds: 200),
                    title: LocaleKeys.error.tr(),
                    desc: LocaleKeys.addressError.tr(),
                    btnOkOnPress: () {},
                  )..show();
                }
                else{
                  firebaseConnection();
                  _showToast();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return const DoneLottie();
                      },
                    ),
                  );
                }
              },
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 30,
              ),
              backgroundColor: Colors.black,
            )),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1, right: 10.0, left: 10.0),
                  child: Text(
                    LocaleKeys.selectDateTimeTitle.tr(),
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width*0.1,
                      color: Colors.grey.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ];
          },
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height*0.02,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Text(DateFormat('MMMM yyyy').format(DateTime.now()),style: TextStyle(color: Colors.blue,fontSize: MediaQuery.of(context).size.width *0.045),),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.width*0.2,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(width: 1.5, color: Colors.grey.shade200),
                    ),
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _days.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDay = _days[index][0];
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: MediaQuery.of(context).size.width*0.23,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: _selectedDay == _days[index][0]
                                    ? Colors.blue.shade100.withOpacity(0.5)
                                    : Colors.blue.withOpacity(0),
                                border: Border.all(
                                  color: _selectedDay == _days[index][0]
                                      ? Colors.blue
                                      : Colors.white.withOpacity(0),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _days[index][0].toString(),
                                    style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width*0.055,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    _days[index][1],
                                    style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.055),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width*0.16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(width: 1.5, color: Colors.grey.shade200),
                    ),
                    child: ScrollablePositionedList.builder(
                        itemScrollController: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: _hours.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedHour = _hours[index];
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: MediaQuery.of(context).size.width* 0.23,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: _selectedHour == _hours[index]
                                    ? Colors.orange.shade100.withOpacity(0.5)
                                    : Colors.orange.withOpacity(0),
                                border: Border.all(
                                  color: _selectedHour == _hours[index]
                                      ? Colors.orange
                                      : Colors.white.withOpacity(0),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _hours[index],
                                    style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width*0.055,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _repeat.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedRepeat = index;
                              });
                            },
                            child:Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: _selectedRepeat == index ? Colors.blue.shade400 : Colors.grey.shade100,
                              ),
                              margin: EdgeInsets.only(right: 20),
                              child: Center(child: Text(_repeat[index],
                                style: TextStyle(fontSize: 18, color: _selectedRepeat == index ? Colors.white : Colors.grey.shade800),)
                              ),
                            ));
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.04,left: 10,bottom: 8),
                    child: Text(LocaleKeys.address.tr(),
                      style: TextStyle(fontWeight: FontWeight.w400,fontSize: MediaQuery.of(context).size.width *0.045,color: Colors.orange),),
                  ),
                  addresses == null ? Container() : Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: (addresses?.length ?? 0) * MediaQuery.of(context).size.height * 0.125,
                      child: MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: ListView.builder(
                          itemCount:addresses?.length,
                          itemBuilder: (context, index){
                            return Container(
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1.5, color: Colors.grey.shade200),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.125,
                              child: Padding(
                                padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.005),
                                child: Row(
                                  children: [
                                    Radio(
                                      activeColor: Colors.black,
                                      groupValue: groupValue,
                                      value: radioCount[index],
                                      onChanged: (newValue) =>
                                          setState(() => groupValue = newValue as int),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(addresses?[index]['Full name'],
                                              style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.height *0.035
                                              ),
                                              softWrap: false,
                                              overflow: TextOverflow.fade),
                                          Text(addresses?[index]['City'],
                                              style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.height *0.016,
                                                  color: Colors.grey
                                              ),
                                              softWrap: false,
                                              overflow: TextOverflow.fade),
                                          Text(addresses?[index]['Area'],
                                              style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.height *0.016,
                                                  color: Colors.grey
                                              ),
                                              softWrap: false,
                                              overflow: TextOverflow.fade),
                                          Text(addresses?[index]['Compound/Building name'],
                                              style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.height *0.016,
                                                  color: Colors.grey
                                              ),
                                              softWrap: false,
                                              overflow: TextOverflow.fade),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.5, color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.065,
                      child: ElevatedButton(
                        onPressed: (){
                          _getCurrentPosition();
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return const AddAddress();
                          }));
                        },
                        child: Text(
                          LocaleKeys.addAddress.tr(),
                          style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width *0.053),
                        ),
                      style: ElevatedButton.styleFrom(
                          primary: FlutterFlowTheme.of(context).primary,
                          fixedSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height*0.05),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ));
  }

  void firebaseConnection() {
    firebaseFirestore
        .collection("users")
        .doc(user?.uid)
        .collection("history")
        .doc(DateTime.now().microsecond.toString())
        .set({
      "companyName": companyName,
      "companyImage": companyImage,
      "services": Dservices.toList(),
      "prices": Dprices.toList(),
      "date": DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()
    });
    firebaseFirestore
        .collection("orders")
        .doc("${user!.uid + DateTime.now().microsecond.toString()}_$_orderCounter")
        .set({
      "companyName": companyName,
      "companyImage": companyImage,
      "services": Dservices.toList(),
      "prices": Dprices.toList(),
      "day": _selectedDay,
      "hour": _selectedHour,
      "repeat": _selectedRepeat,
      "location": addresses?[groupValue]
    });
    setState(() {
      _orderCounter++;
      ScopedModel.of<CartModel>(context).clearCart();
      Dservices.clear();
      Dprices.clear();
    });
  }
}

_showToast() {
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.grey[200],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check),
        const SizedBox(
          width: 12.0,
        ),
        Text(LocaleKeys.confirmationToast.tr()),
      ],
    ),
  );


  fToast?.showToast(
    child: toast,
    gravity: ToastGravity.TOP,
    toastDuration: const Duration(milliseconds: 2500),
  );

}
