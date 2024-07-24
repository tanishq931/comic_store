import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comic_store/provider/AuthProvider.dart';
import 'package:comic_store/provider/ComicProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    // TODO: implement initState
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
    // TODO: implement dispose
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
                color: Colors.red)
          ],
        ),
      ),
    );
  }
}
