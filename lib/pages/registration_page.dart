
import 'package:ecom_users/pages/phone_verification_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth/auth_service.dart';
import 'launcher_page.dart';


class RegistrationPage extends StatefulWidget {
  static const String routeName = '/registration';
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isObscureText = true;
  String errMsg = '';

  @override
  void didChangeDependencies() {
    phoneController.text = ModalRoute.of(context)!.settings.arguments as String;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    phoneController.dispose();
    nameController.dispose();
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
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Enter full Name',
                  prefixIcon: Icon(Icons.person,
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
                enabled: false,
                controller: phoneController,
                decoration: InputDecoration(
                  hintText: 'Mobile Number',
                  prefixIcon: Icon(Icons.phone,
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
                  child: const Text('REGISTER'),
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
