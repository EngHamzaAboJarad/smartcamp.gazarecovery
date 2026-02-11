import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartcamp_gazarecovery/shared/utils/size_config.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String delta;
  final Color deltaColor;
  final IconData icon;

  const SummaryCard({
    Key? key,
    required this.title,
    required this.value,
    required this.delta,
    this.deltaColor = Colors.green,
    this.icon = Icons.pie_chart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardColor = const Color(0xFF111B20);
    final accent = const Color(0xFF2196F3);
    return Container(
      padding: EdgeInsets.all(SizeConfig.sw(context, 12)),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(SizeConfig.sw(context, 12)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.35),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(title, style: GoogleFonts.cairo(color: Colors.white70, fontSize: SizeConfig.sp(context, 12))),
                SizedBox(height: SizeConfig.sh(context, 6)),
                Text(value, style: GoogleFonts.cairo(color: Colors.white, fontSize: SizeConfig.sp(context, 20), fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(width: SizeConfig.sw(context, 12)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: SizeConfig.sw(context, 40),
                height: SizeConfig.sw(context, 40),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(33, 150, 243, 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: accent, size: SizeConfig.sp(context, 18)),
              ),
              SizedBox(height: SizeConfig.sh(context, 8)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.sw(context, 8), vertical: SizeConfig.sh(context, 6)),
                decoration: BoxDecoration(
                  color: Color.fromRGBO((deltaColor.red * 255).round(), (deltaColor.green * 255).round(), (deltaColor.blue * 255).round(), 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(delta, style: GoogleFonts.cairo(color: deltaColor, fontWeight: FontWeight.w600, fontSize: SizeConfig.sp(context, 12))),
              )
            ],
          )
        ],
      ),
    );
  }
}
