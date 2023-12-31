
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_users/models/user_model.dart';
import 'package:ecom_users/pages/phone_verification_page.dart';
import 'package:ecom_users/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../auth/auth_service.dart';
import 'launcher_page.dart';


class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isObscureText = true;
  String errMsg = '';

  
  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 100,horizontal: 20),
            children: [
               Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      child: CircleAvatar(
                        backgroundImage: AssetImage('images/bag_for_login_page.png',),

                      ),
                    ),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.only(left: 8,top: 8,bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Happy',style: TextStyle(fontSize: 48,color: Colors.deepPurple.shade300),),
                    Text('Shopping',style: TextStyle(fontSize: 40,color: Colors.deepPurple.shade300),),
                  ],
                ),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Email Address',
                  prefixIcon: Icon(Icons.email,
                  color: Theme.of(context).primaryColor,),
                  filled: true,
                ),
                validator: (value){
                  if(value==null || value.isEmpty){
                    return 'please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10,),
              TextFormField(
                controller: passController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock,
                    color: Theme.of(context).primaryColor,),
                  suffixIcon: IconButton(
                    icon: Icon(isObscureText ? Icons.visibility_off:Icons.visibility),
                    onPressed: (){
                      setState(() {
                        isObscureText = !isObscureText;
                      });
                    },
                  ),
                  filled: true,
                ),
                validator: (value){
                  if(value==null || value.isEmpty){
                    return 'please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                  onPressed: (){
                    authenticate();
                  }, 
                  child: const Text('LOGIN'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Forgot Password?',style: TextStyle(fontSize: 12),),
                  TextButton(
                    onPressed: (){}, 
                    child: const Text('Click here...'),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('New User?',style: TextStyle(fontSize: 12),),
                  TextButton(
                    onPressed: (){
                      Navigator.pushNamed(context, PhoneVerificationPage.routeName);
                    },
                    child: const Text('REGISTER'),
                  )
                ],
              ),
              const Center(child: Text('OR',style: TextStyle(fontSize: 14,color: Colors.deepPurple),)),
              const SizedBox(height: 10,),
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      child: IconButton(
                          onPressed: (){
                            AuthService.signInWithGoogle().then((credential) async{
                              if(credential.user != null){
                                if(!await Provider.of<UserProvider>(context,listen: false)
                                    .doesUserExist(credential.user!.uid)){

                                  EasyLoading.show(status: 'please wait',dismissOnTap: false);
                                  final userModel = UserModel(
                                      uid: credential.user!.uid,
                                      email: credential.user!.email!,
                                      name: credential.user!.displayName,
                                      user_creationTime: Timestamp.fromDate(credential.user!.metadata.creationTime!));
                                  await Provider.of<UserProvider>(context,listen: false)
                                      .addUser(userModel);
                                  EasyLoading.dismiss();
                                }
                                Navigator.pushReplacementNamed(context, LauncherPage.routeName);

                              }
                            });
                          },
                          icon: Image.asset('images/icons_google.png'),

                      ),
                    ),
                    Card(
                      child: IconButton(
                          onPressed: (){

                          },
                          icon: Image.asset('images/icons_facebook.png'),

                      ),
                    ),
                    Card(
                      child: IconButton(
                          onPressed: (){

                          },
                          icon: Image.asset('images/icons_twitter.png'),
                      ),
                    ),
                  ],
                ),

              Text(errMsg,style: TextStyle(color: Theme.of(context).errorColor),)
            ],
          ),
        )
      ),
    );
  }

  void authenticate() async{
    if(formKey.currentState!.validate()){
      try{
        final status = await AuthService.login(emailController.text,passController.text);
        if(status){
          if(!mounted) return;
          Navigator.pushReplacementNamed(context, LauncherPage.routeName);
        }else{
          await AuthService.logout();
          setState(() {
            errMsg = 'This Email does not belong to an admin account';
          });
        }
      }on FirebaseAuthException catch (e) {
        setState(() {
          errMsg = e.message!;/*1.1 email ba pass vul hole ei line e chole asbet*/
        });

      }
    }
  }
}
