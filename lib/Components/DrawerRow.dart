import 'package:comic_store/Components/CustomButton.dart';
import 'package:comic_store/theme/TextStyles.dart';
import 'package:flutter/material.dart';

class DrawerRow extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData? icon;
  const DrawerRow({super.key,required this.title,required this.onTap,required this.icon });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onTap:onTap,
      child: Row(
        children: [
          Icon(
           icon,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: heading(),
          )
        ],
      ),
    );
  }
}
