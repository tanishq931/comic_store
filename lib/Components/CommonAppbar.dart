import 'package:comic_store/theme/TextStyles.dart';
import 'package:flutter/material.dart';

dynamic CommonAppbar({String title=''}){
  return AppBar(
    iconTheme:const IconThemeData(
      color: Colors.white
    ),
    backgroundColor: Colors.transparent,
    title: Text(
      title,
      style: heading(size: 18),
    ),
    centerTitle: true,
  );
}