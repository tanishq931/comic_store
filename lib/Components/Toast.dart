import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

dynamic showToastMsg(BuildContext context,String title,Color color){
  return showToast(
    title,
    context: context,
    position: StyledToastPosition.top,
    animation: StyledToastAnimation.slideFromTop,
    animDuration: const Duration(seconds: 1),
    duration: const Duration(seconds: 4),
    curve: Curves.fastEaseInToSlowEaseOut,
    backgroundColor: color,
    reverseCurve: Curves.linear,
    reverseAnimation: StyledToastAnimation.slideToTop
  );
}