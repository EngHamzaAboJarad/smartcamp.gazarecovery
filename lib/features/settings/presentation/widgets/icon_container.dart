import 'package:flutter/material.dart';

class IconContainer extends StatelessWidget {
  final IconData icon;
  final double size;

  const IconContainer({Key? key, required this.icon, this.size = 44}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(icon, color: const Color(0xFF2F80ED), size: 20),
      ),
    );
  }
}

