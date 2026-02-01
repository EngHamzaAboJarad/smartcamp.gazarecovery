import 'package:flutter/material.dart';

class LabeledField extends StatelessWidget {
  final String label;
  final Widget child;

  const LabeledField({Key? key, required this.label, required this.child}) : super(key: key);

  static const _darkCard = Color(0xFF0F1720);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: _darkCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: child,
        ),
      ],
    );
  }
}

