
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:homiee/pages/select_category.dart';

import '../l10n/locale_keys.g.dart';
import 'login_page.dart';




class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  

  
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _passwordTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextControllerChecker = TextEditingController();
  final _UsernameTextController = TextEditingController();
  final firestore = FirebaseFirestore.instance;
  

  

  @override
  void dispose(){
    super.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _UsernameTextController.dispose();
    _passwordTextControllerChecker.dispose();  
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
                  Text(LocaleKeys.signUp.tr(), style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width *0.12),),
                  const SizedBox(height: 10,),
                  Text(LocaleKeys.welcomeHere.tr(), style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width *0.04),),
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
                            boxShadow: const [BoxShadow(
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
                                  controller: _UsernameTextController,
                                  decoration: InputDecoration(
                                    hintText: LocaleKeys.username.tr(),
                                    hintStyle: const TextStyle(color: Colors.grey),
                                    border: InputBorder.none
                                  ),
                                ),
                              ),
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
                                decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.black26))
                                ),
                                child: TextField(
                                  obscureText: true,
                                  controller: _passwordTextController,
                                  decoration: InputDecoration(
                                    hintText: LocaleKeys.password.tr(),
                                    hintStyle: const TextStyle(color: Colors.grey),
                                    border: InputBorder.none
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: TextField(
                                  obscureText: true,
                                  controller: _passwordTextControllerChecker,
                                  decoration: InputDecoration(
                                    hintText: LocaleKeys.reTypePassword.tr(),
                                    hintStyle: const TextStyle(color: Colors.grey),
                                    border: InputBorder.none
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40,),
                        GestureDetector(
                          onTap: ()async{
                            if(_passwordTextControllerChecker.text == _passwordTextController.text) {
                              try {
                                await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                    email: _emailTextController.text.trim(),
                                    password: _passwordTextController.text
                                        .trim());
                                print("Created New Account");
                                final user = FirebaseAuth.instance.currentUser;
                                firestore.collection("users")
                                    .doc(user?.uid)
                                    .set(
                                    {
                                      "username": _UsernameTextController.text,
                                      "email": _emailTextController.text,
                                      "uid": user?.uid
                                    });
                                Navigator.pushReplacement(context, MaterialPageRoute(
                                    builder: (context) => const SelectService()));
                              } on FirebaseAuthException catch (e) {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.noHeader,
                                  animType: AnimType.scale,
                                  transitionAnimationDuration: const Duration(milliseconds: 200),
                                  title: 'Warning',
                                  desc: context.locale.languageCode == 'en'?
                                  e.message!:
                                  e.message! == "The email address is already in use by another account."?
                                  "تم استخدام هذا البريد":e.message!,
                                  btnOkColor: Colors.black,
                                  btnOkOnPress: () {},
                                )..show();
                              }
                            }
                            else{
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.noHeader,
                                animType: AnimType.scale,
                                transitionAnimationDuration: const Duration(milliseconds: 200),
                                title: 'Warning',
                                desc: LocaleKeys.passwordsNotMatch.tr(),
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
                            child: Center(child: Text(LocaleKeys.signUp.tr(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Spacer(flex: 15,),
                              Text(LocaleKeys.member.tr(), style: const TextStyle(color: Colors.grey),),
                              const Spacer(flex: 1,),
                              GestureDetector(
                                onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {return const LoginPage();})),
                                child: Text(LocaleKeys.login.tr(), style: const TextStyle(color: Colors.black),)),
                              const Spacer(flex: 15,),
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