import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartcamp_gazarecovery/shared/utils/size_config.dart';

class BigCard extends StatelessWidget {
  final String label;
  final String value;
  final String? nameImage;
  final Color? accent;

  const BigCard({
    Key? key,
    required this.label,
    required this.value,
    this.nameImage,
    this.accent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color bg = const Color(0xFF111B20);
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.sh(context, 18),
          horizontal: SizeConfig.sw(context, 16)),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withAlpha((0.02 * 255).round())),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.cairo(fontSize: 14, color: Colors.white70)),
                SizedBox(height: SizeConfig.sh(context, 6)),
                Text(value,
                    style: GoogleFonts.cairo(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ],
            ),
          ),
          if (nameImage != null)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                'images/$nameImage.png',
                width: SizeConfig.sw(context, 46),
                height: SizeConfig.sw(context, 46),
              ),
            ),
        ],
      ),
    );
  }
}
