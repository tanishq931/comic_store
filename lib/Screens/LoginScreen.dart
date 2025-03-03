import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comic_store/Components/CommonInput.dart';
import 'package:comic_store/Components/CustomButton.dart';
import 'package:comic_store/Components/Toast.dart';
import 'package:comic_store/Utils/BaseLayout.dart';
import 'package:comic_store/constant/FirebaseErrors.dart';
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
  bool showPass = false;
  bool showConfirmPass = false;
  bool isBtnDisabled = true;
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference<Map<String, dynamic>> fireStore =
      FirebaseFirestore.instance.collection('users');

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Add listeners so that every time the text changes, we update the state.
    email.addListener(_updateButtonState);
    password.addListener(_updateButtonState);
    confirmPassword.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    // Check if any required field is empty.
    bool shouldDisable = email.text.isEmpty ||
        password.text.isEmpty ||
        (!isLogin && confirmPassword.text.isEmpty) ||
        (!isLogin && (confirmPassword.text != password.text));

    // Only update if the state has changed.
    if (shouldDisable != isBtnDisabled) {
      setState(() {
        isBtnDisabled = shouldDisable;
      });
    }
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  void onLogin() {
    setState(() {
      isLoading = true;
    });
    if (isLogin) {
      auth
          .signInWithEmailAndPassword(
              email: email.text, password: password.text)
          .then((val) {
        setState(() {
          isLoading = false;
        });
        showToastMsg(context, 'Login Success', Colors.blue);
        Navigator.pushReplacementNamed(context, '/homeScreen');
      }).onError((e, _) {
        setState(() {
          isLoading = false;
        });
        if (e
            .toString()
            .contains(firebaseErrorCodes['invalidCreds'].toString())) {
          showToastMsg(context, firebaseErrorMsg['invalidCreds'].toString(),
              Colors.red);
        } else {
          showToastMsg(context, 'Something went wrong!', Colors.red);
        }
      });
    } else {
      if (password.text != confirmPassword.text) {
        setState(() {
          isLoading = false;
        });
        showToastMsg(context, 'Password don\'t match', Colors.red);
      } else {
        auth
            .createUserWithEmailAndPassword(
                email: email.text, password: password.text)
            .then((val) {
          fireStore
              .doc(val.user!.uid)
              .set({'id': val.user!.uid, 'email': email.text, 'role': 'USER'});
          setState(() {
            isLoading = false;
            isLogin = true;
          });
          showToastMsg(context, 'SignUp Success! Please Login', Colors.blue);
        }).onError((e, _) {
          if (e
              .toString()
              .contains(firebaseErrorCodes['userAlreadyExists'].toString())) {
            showToastMsg(context,
                firebaseErrorMsg['userAlreadyExists'].toString(), Colors.red);
          } else {
            showToastMsg(context, 'Something went wrong!', Colors.red);
          }
          setState(() {
            isLoading = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: Scaffold(
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
                      CommonInput(
                          controller: password,
                          label: 'Enter Password',
                          hideText: !showPass,
                          icon: IconButton(
                              onPressed: () {
                                setState(() {
                                  showPass = !showPass;
                                });
                              },
                              icon: Icon(
                                  showPass
                                      ? Icons.remove_red_eye
                                      : Icons.remove_red_eye_outlined,
                                  color: Colors.white))),
                      if (!isLogin)
                        Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: CommonInput(
                                controller: confirmPassword,
                                label: 'Confirm Password',
                                icon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showConfirmPass = !showConfirmPass;
                                      });
                                    },
                                    icon: Icon(
                                        showConfirmPass
                                            ? Icons.remove_red_eye
                                            : Icons.remove_red_eye_outlined,
                                        color: Colors.white)),
                                hideText: !showConfirmPass)),
                      if (!isLogin && (confirmPassword.text != password.text))
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Password and Confirm Password should match!',
                              style: heading(size: 14, color: Colors.red),
                              textAlign: TextAlign.left,
                            )),
                      const SizedBox(height: 40),
                      CustomButton(
                        disabled: isBtnDisabled,
                        child: Container(
                          height: 50,
                          margin: const EdgeInsets.symmetric(horizontal: 80),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 0.5),
                            borderRadius: BorderRadius.circular(8),
                            color: isBtnDisabled ? Colors.grey : Colors.red,
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
                                  isLogin = !isLogin;
                                });
                              })
                        ],
                      )
                    ],
                  ),
                ),
              ),
              if (isLoading)
                const Center(
                    child: CircularProgressIndicator(color: Colors.blue))
            ],
          ),
        ),
      )),
    );
  }
}
