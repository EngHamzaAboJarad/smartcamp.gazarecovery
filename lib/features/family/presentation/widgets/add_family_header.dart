import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddFamilyHeader extends StatelessWidget {
  final VoidCallback? onBack;
  const AddFamilyHeader({Key? key, this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack ?? () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_forward, color: Colors.white),
        ),
        const Spacer(),
        Column(
          children: [
            Text('إضافة عائلة',
                style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('مخيم النور المنطقة الشمالية',
                style: GoogleFonts.cairo(color: Colors.white70, fontSize: 13)),
          ],
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}

