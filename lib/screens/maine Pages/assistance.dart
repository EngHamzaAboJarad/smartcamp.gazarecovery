import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white);

  TextStyle _sectionTitleStyle() => GoogleFonts.cairo(
      fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white);

  TextStyle _labelStyle() =>
      GoogleFonts.cairo(fontSize: 13, color: Colors.white70);

  TextStyle _unitStyle() =>
      GoogleFonts.cairo(fontSize: 11, color: Colors.white54);

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
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          centerTitle: false,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 160),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // العنوان الرئيسي
                  Text(
                    'المساعدات',
                    style: _titleStyle(),
                  ),
                  const SizedBox(height: 20),

                  // شريط البحث
                  _buildSearchBar(),
                  const SizedBox(height: 20),

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
                      const SizedBox(width: 12),
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
                  const SizedBox(height: 24),

                  // عنوان جميع الأصناف
                  Text(
                    'جميع الأصناف',
                    style: _sectionTitleStyle(),
                  ),
                  const SizedBox(height: 16),

                  // قائمة الأصناف
                  _buildAssistanceItem(
                    'سلات غذائية',
                    '1,250',
                    'الوحدة : صندوق',
                    Icons.restaurant,
                    _accent,
                    'available',
                  ),
                  const SizedBox(height: 12),

                  _buildAssistanceItem(
                    'مياه شرب',
                    '5,000',
                    'الوحدة : لتر',
                    Icons.water_drop,
                    _accent,
                    'available',
                  ),
                  const SizedBox(height: 12),

                  _buildAssistanceItem(
                    'أدوية ومستلزمات',
                    '340',
                    'الوحدة : طرد',
                    Icons.medical_services,
                    const Color(0xFFE91E63),
                    'low',
                  ),
                  const SizedBox(height: 12),

                  _buildAssistanceItem(
                    'أغطية شتوية',
                    '850',
                    'الوحدة : قطعة',
                    Icons.checkroom,
                    const Color(0xFF9C27B0),
                    'available',
                  ),
                  const SizedBox(height: 12),

                  _buildAssistanceItem(
                    'مستلزمات نظافة',
                    '600',
                    'الوحدة : حقيبة',
                    Icons.clean_hands,
                    const Color(0xFF00BCD4),
                    'available',
                  ),
                  const SizedBox(height: 12),

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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _bg.withOpacity(0.0),
                      _bg.withOpacity(0.8),
                      _bg,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    // زر +
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: _accent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _accent.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // زر سجل المساعدات
                    Expanded(
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: _accent,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: _accent.withOpacity(0.3),
                              blurRadius: 12,
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
                            borderRadius: BorderRadius.circular(16),
                            child: Center(
                              child: Text(
                                'سجل المساعدات',
                                style: GoogleFonts.cairo(
                                  fontSize: 16,
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        textAlign: TextAlign.right,
        style: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: 'بحث عن صنف مثال (غذاء، أدوية) :',
          hintStyle: GoogleFonts.cairo(
            color: Colors.white.withOpacity(0.4),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white.withOpacity(0.4),
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    label,
                    style: _labelStyle(),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.cairo(
                      fontSize: 24,
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
