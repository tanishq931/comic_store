import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  CustomButton({super.key, required this.child, required this.onTap});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  double _opacity = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _opacity = 0.5;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _opacity = 1.0;
    });
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() {
      _opacity = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}
