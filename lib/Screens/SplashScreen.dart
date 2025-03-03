import 'dart:async';
import 'package:comic_store/Utils/BaseLayout.dart';
import 'package:comic_store/theme/TextStyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  FirebaseAuth auth = FirebaseAuth.instance;
  late AnimationController controller;
  late Animation animation;
  StreamSubscription? _internetSubscriber;

  @override
  void initState() {
    super.initState();
    _internetSubscriber = InternetConnection().onStatusChange.listen((InternetStatus status){
      switch (status) {
        case InternetStatus.connected:
        // The internet is now connected
          break;
        case InternetStatus.disconnected:
        // The internet is now disconnected
          break;
      }
    });
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(
          context, auth.currentUser != null ? '/homeScreen' : '/loginScreen');
    });
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.bounceOut,
      ),
    );

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();

  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    _internetSubscriber?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: animation.value * 50,
                  width: animation.value * 300,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.red,
                  child: Center(child: Text('Comic Store',style: heading(size:animation.value * 24,weight: FontWeight.bold ),)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
