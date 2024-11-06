import 'dart:async';
import 'package:comic_store/theme/TextStyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
  @override
  void initState() {
    super.initState();
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

    // animation =
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
