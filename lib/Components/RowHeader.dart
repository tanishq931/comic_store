import 'package:comic_store/Components/CustomButton.dart';
import 'package:comic_store/theme/TextStyles.dart';
import 'package:flutter/material.dart';

Widget RowHeader(
    {String title = '', String btnText = '', required VoidCallback onPress,bool showButton =true}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5).copyWith(top: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: heading(size: 18),
        ),
        showButton ? CustomButton(
            onTap: onPress,
            child: Row(
              children: [
                Text(
                  btnText,
                  style: heading(size: 14, color: Colors.blue),
                ),
                const Icon(
                  Icons.arrow_right,
                  color: Colors.blue,
                )
              ],
            )):const SizedBox()
      ],
    ),
  );
}
