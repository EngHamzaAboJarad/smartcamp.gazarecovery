import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartcamp_gazarecovery/shared/utils/size_config.dart';

class AssistanceScreen extends StatefulWidget {
  const AssistanceScreen({Key? key}) : super(key: key);

  @override
  State<AssistanceScreen> createState() => _AssistanceScreenState();
}

class _AssistanceScreenState extends State<AssistanceScreen> {
  static const Color _bg = Color(0xFF0B1216);
  static const Color _card = Color(0xFF111B20);
  static const Color _accent = Color(0xFF2196F3);

  TextStyle _titleStyle() => GoogleFonts.cairo(
      fontSize: SizeConfig.sp(context, 18), fontWeight: FontWeight.w700, color: Colors.white);

  TextStyle _sectionTitleStyle() => GoogleFonts.cairo(
      fontSize: SizeConfig.sp(context, 16), fontWeight: FontWeight.w600, color: Colors.white);

  TextStyle _labelStyle() =>
      GoogleFonts.cairo(fontSize: SizeConfig.sp(context, 13), color: Colors.white70);

  TextStyle _unitStyle() =>
      GoogleFonts.cairo(fontSize: SizeConfig.sp(context, 11), color: Colors.white54);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          backgroundColor: _bg,
          elevation: 0,
          title: Text(
            'سجل التوزيعات',
            style: GoogleFonts.cairo(
              fontSize: SizeConfig.sp(context, 16),
              color: Colors.white70,
            ),
          ),
          centerTitle: false,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(SizeConfig.sw(context,16), SizeConfig.sh(context,16), SizeConfig.sw(context,16), SizeConfig.sh(context,160)),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.stretch,
                 children: [
                   // العنوان الرئيسي
                  Text(
                    'المساعدات',
                    style: _titleStyle(),
                  ),
                  SizedBox(height: SizeConfig.sh(context, 20)),

                   // شريط البحث
                   _buildSearchBar(),
                  SizedBox(height: SizeConfig.sh(context, 20)),

                   // الإحصائيات
                   Row(
                     children: [
                       Expanded(
                         child: _buildStatCard(
                           'إجمالي الأصناف',
                           '24',
                           Icons.inventory_2,
                           _accent,
                         ),
                       ),
                       SizedBox(width: SizeConfig.sw(context, 12)),
                       Expanded(
                         child: _buildStatCard(
                           'أصناف متخفضة',
                           '3',
                           Icons.warning_amber_rounded,
                           const Color(0xFFFFA726),
                         ),
                       ),
                     ],
                   ),
                  SizedBox(height: SizeConfig.sh(context, 24)),

                   // عنوان جميع الأصناف
                   Text(
                     'جميع الأصناف',
                     style: _sectionTitleStyle(),
                   ),
                  SizedBox(height: SizeConfig.sh(context, 16)),

                   // قائمة الأصناف
                   _buildAssistanceItem(
                     'سلات غذائية',
                     '1,250',
                     'الوحدة : صندوق',
                     Icons.restaurant,
                     _accent,
                     'available',
                   ),
                  SizedBox(height: SizeConfig.sh(context, 12)),

                   _buildAssistanceItem(
                     'مياه شرب',
                     '5,000',
                     'الوحدة : لتر',
                     Icons.water_drop,
                     _accent,
                     'available',
                   ),
                  SizedBox(height: SizeConfig.sh(context, 12)),

                   _buildAssistanceItem(
                     'أدوية ومستلزمات',
                     '340',
                     'الوحدة : طرد',
                     Icons.medical_services,
                     const Color(0xFFE91E63),
                     'low',
                   ),
                  SizedBox(height: SizeConfig.sh(context, 12)),

                   _buildAssistanceItem(
                     'أغطية شتوية',
                     '850',
                     'الوحدة : قطعة',
                     Icons.checkroom,
                     const Color(0xFF9C27B0),
                     'available',
                   ),
                  SizedBox(height: SizeConfig.sh(context, 12)),

                   _buildAssistanceItem(
                     'مستلزمات نظافة',
                     '600',
                     'الوحدة : حقيبة',
                     Icons.clean_hands,
                     const Color(0xFF00BCD4),
                     'available',
                   ),
                  SizedBox(height: SizeConfig.sh(context, 12)),

                   _buildAssistanceItem(
                     'خيم إيواء',
                     '120',
                     'الوحدة : خيمة',
                     Icons.warning_amber_rounded,
                     const Color(0xFFFFA726),
                     'critical',
                   ),
                 ],
               ),
             ),

             // الأزرار العائمة في الأسفل
             Positioned(
               bottom: 0,
               left: 0,
               right: 0,
               child: Container(
                padding: EdgeInsets.all(SizeConfig.sw(context, 16)),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _bg.withAlpha((0.0 * 255).round()),
                      _bg.withAlpha((0.8 * 255).round()),
                      _bg,
                    ],
                  ),
                ),
                 child: Row(
                   children: [
                     // زر +
                     Container(
                      width: SizeConfig.sw(context, 56),
                      height: SizeConfig.sw(context, 56),
                      decoration: BoxDecoration(
                        color: _accent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _accent.withAlpha((0.3 * 255).round()),
                            blurRadius: SizeConfig.sw(context, 12),
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: SizeConfig.sp(context, 28),
                      ),
                     ),
                     SizedBox(width: SizeConfig.sw(context, 16)),

                     // زر سجل المساعدات
                     Expanded(
                       child: Container(
                        height: SizeConfig.sw(context, 56),
                        decoration: BoxDecoration(
                          color: _accent,
                          borderRadius: BorderRadius.circular(SizeConfig.sw(context, 16)),
                          boxShadow: [
                            BoxShadow(
                              color: _accent.withAlpha((0.3 * 255).round()),
                              blurRadius: SizeConfig.sw(context, 12),
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                         child: Material(
                           color: Colors.transparent,
                           child: InkWell(
                             onTap: () {
                               // وظيفة سجل المساعدات
                             },
                            borderRadius: BorderRadius.circular(SizeConfig.sw(context, 16)),
                             child: Center(
                               child: Text(
                                 'سجل المساعدات',
                                 style: GoogleFonts.cairo(
                                  fontSize: SizeConfig.sp(context, 16),
                                   fontWeight: FontWeight.w600,
                                   color: Colors.white,
                                 ),
                               ),
                             ),
                           ),
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
             ),
           ],
         ),
       ),
     );
   }

   Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(SizeConfig.sw(context, 12)),
        border: Border.all(color: Colors.white.withAlpha((0.1 * 255).round())),
      ),
      child: TextField(
        textAlign: TextAlign.right,
        style: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: SizeConfig.sp(context, 14),
        ),
        decoration: InputDecoration(
          hintText: 'بحث عن صنف مثال (غذاء، أدوية) :',
          hintStyle: GoogleFonts.cairo(
            color: Colors.white.withAlpha((0.4 * 255).round()),
            fontSize: SizeConfig.sp(context, 14),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white.withAlpha((0.4 * 255).round()),
            size: SizeConfig.sp(context, 22),
          ),
          border: InputBorder.none,
          contentPadding:
              EdgeInsets.symmetric(horizontal: SizeConfig.sw(context, 16), vertical: SizeConfig.sh(context, 14)),
        ),
      ),
    );
   }

   Widget _buildStatCard(
       String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.sw(context, 16)),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(SizeConfig.sw(context, 12)),
        border: Border.all(color: Colors.white.withAlpha((0.05 * 255).round())),
      ),
       child: Column(
         children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Container(
                padding: EdgeInsets.all(SizeConfig.sw(context, 10)),
                decoration: BoxDecoration(
                  color: color.withAlpha((0.15 * 255).round()),
                  borderRadius: BorderRadius.circular(SizeConfig.sw(context, 10)),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: SizeConfig.sp(context, 24),
                ),
               ),
               Column(
                 crossAxisAlignment: CrossAxisAlignment.end,
                 children: [
                   Text(
                     label,
                     style: _labelStyle(),
                   ),
                  SizedBox(height: SizeConfig.sh(context, 4)),
                   Text(
                     value,
                     style: GoogleFonts.cairo(
                      fontSize: SizeConfig.sp(context, 24),
                       fontWeight: FontWeight.bold,
                       color: Colors.white,
                     ),
                   ),
                 ],
               ),
             ],
           ),
         ],
       ),
     );
   }

   Widget _buildAssistanceItem(
     String title,
     String quantity,
     String unit,
     IconData icon,
     Color iconColor,
     String status,
   ) {
     Color getStatusColor() {
       switch (status) {
         case 'available':
           return const Color(0xFF4CAF50);
         case 'low':
           return const Color(0xFFFFA726);
         case 'critical':
           return const Color(0xFFF44336);
         default:
           return Colors.grey;
       }
     }

     String getStatusText() {
       switch (status) {
         case 'low':
           return 'منخفض';
         case 'critical':
           return 'حرج';
         default:
           return '';
       }
     }

     return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          // الأيقونة
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // الكمية والحالة
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      quantity,
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: getStatusColor(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (status != 'available') ...[
                      const SizedBox(width: 6),
                      Text(
                        getStatusText(),
                        style: GoogleFonts.cairo(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: getStatusColor(),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  unit,
                  style: _unitStyle(),
                ),
              ],
            ),
          ),

          // العنوان
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

