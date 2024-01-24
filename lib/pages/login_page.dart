import 'package:easy_localization/easy_localization.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:homiee/l10n/locale_keys.g.dart';
import 'package:homiee/pages/select_category.dart';
import 'package:homiee/pages/sign_up_page.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}



class _LoginPageState extends State<LoginPage> {

  final _passwordTextController = TextEditingController();
  final _emailTextController = TextEditingController();

    @override
  void dispose(){
    super.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.black
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 80,),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(LocaleKeys.login.tr(), style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width *0.12),),
                  const SizedBox(height: 10,),
                  Text(LocaleKeys.welcomeBack.tr(), style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width *0.04),),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 60,),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [const BoxShadow(
                              color: Colors.black45,
                              blurRadius: 3,
                            )]
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.black26))
                                ),
                                child: TextField(
                                  controller: _emailTextController,
                                  decoration: InputDecoration(
                                    hintText: LocaleKeys.email.tr(),
                                    hintStyle: const TextStyle(color: Colors.grey),
                                    border: InputBorder.none
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: TextField(
                                  controller: _passwordTextController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: LocaleKeys.password.tr(),
                                    hintStyle: const TextStyle(color: Colors.grey),
                                    border: InputBorder.none
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40,),
                        const SizedBox(height: 40,),
                        GestureDetector(
                          onTap: () async{
                            try {
                              await FirebaseAuth.instance.signInWithEmailAndPassword(
                                  email: _emailTextController.text.trim(),
                                  password: _passwordTextController.text
                                      .trim());
                              Navigator.pushReplacement(context, MaterialPageRoute(
                                  builder: (context) => const SelectService()));
                            }on FirebaseAuthException catch (e) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.noHeader,
                                animType: AnimType.scale,
                                transitionAnimationDuration: const Duration(milliseconds: 200),
                                title: 'Warning',
                                desc: LocaleKeys.emailPasswordWrong.tr(),
                                btnOkColor: Colors.black,
                                btnOkOnPress: () {},
                              )..show();
                            }
                                },
                          child: Container(
                            height: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.black
                            ),
                            child: Center(child: Text(LocaleKeys.login.tr(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: MediaQuery.of(context).size.width*0.04),),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Spacer(flex: 10,),
                              Text(LocaleKeys.notMemberYet.tr(), style: const TextStyle(color: Colors.grey),),
                              const Spacer(flex: 1,),
                              GestureDetector(
                                onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {return const SignUpPage();})),
                                child: Text(LocaleKeys.signUp.tr(), style: TextStyle(color: Colors.black,fontSize: MediaQuery.of(context).size.width*0.04))),
                              const Spacer(flex: 10,),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}