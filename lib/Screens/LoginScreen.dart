import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comic_store/Components/CommonInput.dart';
import 'package:comic_store/Components/CustomButton.dart';
import 'package:comic_store/Components/Toast.dart';
import 'package:comic_store/theme/TextStyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;
  bool isLoading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference<Map<String, dynamic>> fireStore = FirebaseFirestore.instance.collection('users');

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  void onLogin() {
    setState(() {
      isLoading = true;
    });
    if (isLogin) {
      auth.signInWithEmailAndPassword(
          email: email.text, password: password.text).then((val){
            setState(() {
               isLoading=false;
            });
            showToastMsg(context,'Login Success', Colors.blue);
            Navigator.pushReplacementNamed(context, '/homeScreen');
      }).onError((e,_){
        setState(() {
          isLoading=false;
        });
        showToastMsg(context,'Invalid Credentials', Colors.red);
      });
    } else {
      if (password.text != confirmPassword.text) {
        setState(() {
          isLoading=false;
        });
        showToastMsg(context, 'Password don\'t match', Colors.red);
      } else {
        auth
            .createUserWithEmailAndPassword(
                email: email.text, password: password.text)
            .then((val) {
         fireStore.doc(val.user!.uid).set({
           'id':val.user!.uid,
           'email':email.text,
           'role':'user'
         });
          setState(() {
            isLoading = false;
            isLogin = true;
          });
          showToastMsg(context, 'SignUp Success! Please Login', Colors.blue);
        }).onError((e, _) {
          showToastMsg(context, e.toString(), Colors.red);
          setState(() {
            isLoading = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Comic Pedia',
                      style: heading(size: 25, weight: FontWeight.bold),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      isLogin ? 'Login' : 'Signup',
                      style: heading(size: 25),
                    ),
                    const SizedBox(height: 20),
                    CommonInput(controller: email, label: 'Enter Email'),
                    const SizedBox(height: 10),
                    CommonInput(controller: password, label: 'Enter Password',hideText: true),
                    if (!isLogin)
                      Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: CommonInput(
                              controller: confirmPassword,
                              label: 'Confirm Password',hideText: true)),
                    const SizedBox(height: 40),
                    CustomButton(
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 80),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 0.5),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.red,
                        ),
                        child: Center(
                            child: Text(
                          isLogin ? 'Login' : 'Signup',
                          style: heading(),
                        )),
                      ),
                      onTap: () {
                        onLogin();
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                            isLogin
                                ? 'Don\'t have any account ?'
                                : 'Already have an account ?',
                            style: heading(size: 12)),
                        const SizedBox(width: 8),
                        CustomButton(
                            child: Text(isLogin ? 'SignUp' : 'Login',
                                style: heading(size: 12, color: Colors.blue)),
                            onTap: () {
                              setState(() {
                                setState(() {
                                  isLogin = !isLogin;
                                });
                              });
                            })
                      ],
                    )
                  ],
                ),
              ),
            ),
            if (isLoading)
              const Center(child: CircularProgressIndicator(color: Colors.blue))
          ],
        ),
      ),
    ));
  }
}
