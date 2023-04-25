
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ocr_app/screen/phone_auth/verify_otp.dart';

class SignInWithPhone extends StatefulWidget {
  const SignInWithPhone({ Key? key }) : super(key: key);

  @override
  State<SignInWithPhone> createState() => _SignInWithPhoneState();
}

class _SignInWithPhoneState extends State<SignInWithPhone> {

  TextEditingController phoneController = TextEditingController();

  void sendOTP() async{
    String phone = "+84" + phoneController.text.trim();
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (credential){

        },
        verificationFailed: (ex){
          log(ex.code.toString());
        },
        codeSent: (verificationId,resendToken){
          Navigator.push(context, CupertinoPageRoute(builder: (context)=>VerifyOtpScreen(
            verificationId: verificationId,
          )));
        },
        codeAutoRetrievalTimeout: (verificationId){

        },
        timeout: Duration(seconds: 30)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Sign In with Phone"),
      ),
      body: SafeArea(
        child: ListView(
          children: [

            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Phone Number"
                    ),
                    controller: phoneController,
                  ),

                  SizedBox(height: 20,),

                  CupertinoButton(
                    onPressed: () {
                      sendOTP();
                    },
                    color: Colors.blue,
                    child: Text("Sign In"),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}