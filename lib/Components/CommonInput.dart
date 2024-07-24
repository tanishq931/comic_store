import 'package:comic_store/theme/TextStyles.dart';
import 'package:flutter/material.dart';

Widget CommonInput(
    {required TextEditingController controller,
    String label = '',
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
    Icon? icon,
      var onChangeText,
      bool hideText=false
    }) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: TextField(
      controller: controller,
      style: heading(size: 14),
      maxLines:hideText?1:null,
      keyboardType: keyboard,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue)),
        label: Text(label, style: heading(size: 14)),
        suffixIcon: icon??const SizedBox(),
          suffixIconColor: Colors.white
      ),
      onChanged: onChangeText,
      obscureText: hideText,
    ),

  );
}
