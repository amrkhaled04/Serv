import 'dart:async';
import 'dart:math';
import 'package:get/get.dart' hide Trans;
import 'package:homiee/models/service.dart';
import 'package:homiee/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../l10n/locale_keys.g.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  List<Service> services = [
    Service('Cleaning',
        'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-cleaning-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png'),
    Service('Plumber',
        'https://img.icons8.com/external-vitaliy-gorbachev-flat-vitaly-gorbachev/2x/external-plumber-labour-day-vitaliy-gorbachev-flat-vitaly-gorbachev.png'),
    Service('Electrician',
        'https://img.icons8.com/external-wanicon-flat-wanicon/2x/external-multimeter-car-service-wanicon-flat-wanicon.png'),
    Service('Painter',
        'https://img.icons8.com/external-itim2101-flat-itim2101/2x/external-painter-male-occupation-avatar-itim2101-flat-itim2101.png'),
    Service('Carpenter', 'https://img.icons8.com/fluency/2x/drill.png'),
    Service('Gardener',
        'https://img.icons8.com/external-itim2101-flat-itim2101/2x/external-gardener-male-occupation-avatar-itim2101-flat-itim2101.png'),
    Service('Tailor', 'https://img.icons8.com/fluency/2x/sewing-machine.png'),
    Service('Maid', 'https://img.icons8.com/color/2x/housekeeper-female.png'),
    Service('Driver',
        'https://img.icons8.com/external-sbts2018-lineal-color-sbts2018/2x/external-driver-women-profession-sbts2018-lineal-color-sbts2018.png'),
  ];

  int selectedService = 4;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showGeneralDialog(barrierColor: Colors.black.withOpacity(0.75),
          transitionBuilder: (BuildContext context, a1, a2, widget) {
            return Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  title: Center(
                    child: Text("Choose language",
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width *0.055,fontWeight: FontWeight.bold),),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                        style:ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            primary: Colors.black,
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.12, vertical: MediaQuery.of(context).size.height *0.0165),),
                        onPressed: () async {
                          await (context.setLocale(const Locale('en')));
                          Get.updateLocale(const Locale('en'));
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: Text('English',style:TextStyle(fontSize: MediaQuery.of(context).size.width *0.042) ,)),
                    ElevatedButton(
                        style:ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            primary: Colors.black,
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width *0.135, vertical: MediaQuery.of(context).size.height *0.0115),),
                        onPressed: () async {
                          await (context.setLocale(const Locale('ar')));
                          Get.updateLocale(const Locale('ar'));
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: Text('عربي',style: TextStyle(fontSize: MediaQuery.of(context).size.width *0.042),)),
                  ],
                ),
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 425),
          barrierDismissible: true,
          barrierLabel: '',
          context: context,
          pageBuilder: (context, animation1, animation2) {return Container();});
    });
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        selectedService = Random().nextInt(services.length);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
          SizedBox(
        height: MediaQuery.of(context).size.height * 0.08,
          ),
          Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1),
        height: MediaQuery.of(context).size.height * 0.45,
        width: MediaQuery.of(context).size.width,
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: MediaQuery.of(context).size.height *0.0012,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            itemBuilder: (BuildContext context, int index) {
              return serviceContainer(
                  services[index].imageURL, services[index].name, index);
            }),
          ),
          Expanded(
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(80),
                topRight: Radius.circular(80),
              )),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1,vertical: MediaQuery.of(context).size.height * 0.007),
                child: Center(
                  child: Text(
                    LocaleKeys.getStartedTitle.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.1,
                    right: MediaQuery.of(context).size.width * 0.1,
                    bottom: context.locale.languageCode == 'en' ?
                      MediaQuery.of(context).size.height * 0.192:
                        MediaQuery.of(context).size.height * 0.141),
                child: Center(
                  child: Text(
                    LocaleKeys.getStartedHint.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.036,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width * 0.05,vertical: MediaQuery.of(context).size.height * 0.04),
                child: MaterialButton(
                  elevation: 2,
                  color: Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  height: 55,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      LocaleKeys.getStarted.tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width *0.053,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
          )
      ],
    ));
  }

  serviceContainer(String image, String name, int index) {
    return GestureDetector(
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: selectedService == index ? Colors.white : Colors.grey.shade100,
          border: Border.all(
            color: selectedService == index
                ? Colors.blue.shade100
                : Colors.grey.withOpacity(0),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.network(image,
                  height: MediaQuery.of(context).size.height * 0.05),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.0009,
              ),
              Text(
                name,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              )
            ]),
      ),
    );
  }
}
