import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartcamp_gazarecovery/shared/utils/size_config.dart';

class DonationCard extends StatelessWidget {
  final int quantity;
  final String title;
  final String organization;
  final DateTime date;
  final String status; // 'completed' or 'in_progress'
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  const DonationCard({
    Key? key,
    required this.quantity,
    required this.title,
    required this.organization,
    required this.date,
    required this.status,
    required this.color,
    this.icon = Icons.food_bank,
    this.onTap,
  }) : super(key: key);

  String _formatDate(DateTime d) {
    // Simple yyyy-MM-dd representation; the screen can localize as needed.
    return '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = const Color(0xFF111B20);
    final isCompleted = status == 'completed' || status == 'مكتمل';
    final statusText = isCompleted ? 'مكتمل' : 'قيد التوزيع';
    final statusColor = isCompleted ? const Color(0xFF4CAF50) : const Color(0xFFFFA726);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(SizeConfig.sw(context, 12)),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color.fromRGBO(255, 255, 255, 0.03)),
        ),
        child: Row(
          textDirection: TextDirection.ltr, // keep quantity on the left side visually
          children: [
            // Quantity box
            Container(
              width: SizeConfig.sw(context, 68),
              height: SizeConfig.sw(context, 68),
              decoration: BoxDecoration(
                color: Color.fromRGBO((color.r * 255).round(), (color.g * 255).round(), (color.b * 255).round(), 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                quantity.toString(),
                style: GoogleFonts.cairo(
                  color: color,
                  fontSize: SizeConfig.sp(context, 18),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(width: SizeConfig.sw(context, 12)),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(title, style: GoogleFonts.cairo(color: Colors.white, fontSize: SizeConfig.sp(context, 15), fontWeight: FontWeight.w700)),
                            SizedBox(height: SizeConfig.sh(context, 6)),
                            Text(organization, style: GoogleFonts.cairo(color: Colors.white54, fontSize: SizeConfig.sp(context, 12))),
                          ],
                        ),
                      ),

                      // Small icon circle and status badge column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: SizeConfig.sw(context, 36),
                            height: SizeConfig.sw(context, 36),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO((color.r * 255).round(), (color.g * 255).round(), (color.b * 255).round(), 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, color: color, size: SizeConfig.sp(context, 18)),
                          ),
                          SizedBox(height: SizeConfig.sh(context, 8)),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: SizeConfig.sw(context, 8), vertical: SizeConfig.sh(context, 6)),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO((statusColor.r * 255).round(), (statusColor.g * 255).round(), (statusColor.b * 255).round(), 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(statusText, style: GoogleFonts.cairo(color: statusColor, fontSize: SizeConfig.sp(context, 12), fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: SizeConfig.sh(context, 8)),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.calendar_today, color: Colors.white24, size: SizeConfig.sp(context, 12)),
                      SizedBox(width: SizeConfig.sw(context, 6)),
                      Text(_formatDate(date), style: GoogleFonts.cairo(color: Colors.white54, fontSize: SizeConfig.sp(context, 12))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
