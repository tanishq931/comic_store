import 'package:comic_store/Components/InternetSheet.dart';
import 'package:flutter/material.dart';

class BaseLayout extends StatelessWidget {
  final Widget child;
  const BaseLayout({super.key,required this.child});

  @override
  Widget build(BuildContext context) {
    return InternetSheet(child:child);
  }
}
