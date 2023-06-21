
import 'package:ecom_users/auth/auth_service.dart';
import 'package:ecom_users/pages/registration_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../utils/helper_function.dart';

class PhoneVerificationPage extends StatefulWidget {
  static const String routeName= '/verification';
  const PhoneVerificationPage({super.key});

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {

  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  bool isFirst = true;
  String vId = '';

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedCrossFade(
            duration: const Duration(seconds: 1),
            firstChild: phoneVerificationSection(),
            secondChild: otpSection(),
            crossFadeState: isFirst ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          ),
        ),
      ),
    );
  }

  Column phoneVerificationSection() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: 'Enter Mobile Number',
              filled: true,
            ),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
              onPressed: (){
                if(phoneController.text.isEmpty){
                  showMsg(context, 'Invalid phone Number');
                  return;
                }
                setState(() {
                  isFirst = false;
                });
                _verifyphone();
              },
              child: const Text('SUBMIT'),
          )
        ],
      );
  }

  Column otpSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(phoneController.text,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        const SizedBox(height: 10,),
        PinCodeTextField(
          appContext: context,
          length: 6,
          obscureText: false,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(5),
            fieldHeight: 50,
            fieldWidth: 40,
            activeFillColor: Colors.white,
          ),
          animationDuration: Duration(milliseconds: 300),
          backgroundColor: Colors.blue.shade50,
          enableActiveFill: true,
          //errorAnimationController: errorController,
          controller: otpController,

          onChanged: (value) {
            if(value.length == 6 ){
              EasyLoading.show(status: 'Please Wait');
              sendOtp();
            }
          },

        ),
        const SizedBox(height: 20,),
        ElevatedButton(
          onPressed: (){

          },
          child: const Text('SUBMIT'),
        )
      ],
    );
  }

  void _verifyphone() async{
    await FirebaseAuth.instance.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      phoneNumber: phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        showMsg(context, 'Code did not match');
      },
      codeSent: (String verificationId, int? resendToken) {
        vId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {

      },
    );
  }

  void sendOtp() {
    PhoneAuthCredential credential = PhoneAuthProvider
        .credential(verificationId: vId, smsCode: otpController.text);
    FirebaseAuth.instance.signInWithCredential(credential)
        .then((credentialUser) {
          if(credentialUser != null){
            EasyLoading.dismiss();
            AuthService.logout();
            Navigator.pushReplacementNamed(context, RegistrationPage.routeName,arguments: phoneController.text);
          }
    });
  }
}
