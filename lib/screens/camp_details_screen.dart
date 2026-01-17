import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CampDetailsScreen extends StatefulWidget {
  final String campName;
  final String tentId;

  const CampDetailsScreen({
    Key? key,
    required this.campName,
    required this.tentId,
  }) : super(key: key);

  @override
  State<CampDetailsScreen> createState() => _CampDetailsScreenState();
}

class _CampDetailsScreenState extends State<CampDetailsScreen> {
  static const Color _bg = Color(0xFF0B1216);
  static const Color _card = Color(0xFF111B20);
  static const Color _accent = Color(0xFF2196F3);

  String selectedCategory = 'B'; // القيمة الافتراضية من الصورة

  TextStyle _titleStyle() => GoogleFonts.cairo(
      fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white);

  TextStyle _sectionTitleStyle() => GoogleFonts.cairo(
      fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white);

  TextStyle _labelStyle() =>
      GoogleFonts.cairo(fontSize: 13, color: Colors.white70);

  TextStyle _valueStyle() => GoogleFonts.cairo(
      fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white);

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
            'بيانات المخيم',
            style: _titleStyle(),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white70),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // زر تحديث بيانات المخيم
              _buildUpdateButton(),
              const SizedBox(height: 24),

              // المعلومات الأساسية
              _buildSectionTitle('المعلومات الأساسية'),
              const SizedBox(height: 12),
              _buildInfoCard([
                _buildInfoField('اسم المخيم', 'مخيم الست امرة',
                    fullWidth: true),
                _buildInfoField('المنطقة', 'المنطقة الوسطى'),
                _buildInfoField('الحي', 'الركن'),
                _buildInfoField('الجهة الشريكة', 'منظمة الإحسان الإغاثية',
                    fullWidth: true),
              ]),
              const SizedBox(height: 24),

              // الحالة والسعة
              _buildSectionTitle('الحالة والسعة'),
              const SizedBox(height: 12),
              _buildInfoCard([
                _buildDropdownField('حالة المخيم', 'نشط بتسقيف بأرضين'),
                _buildInfoFieldWithNumber('عدد الخيام', '150'),
                _buildInfoFieldWithNumber('عدد المرافقات', '25'),
                _buildInfoFieldWithNumber('عدد الخيام المحاورة', '50'),
                _buildInfoFieldWithNumber('عدد العائلات الباحثين', '20'),
              ]),
              const SizedBox(height: 24),

              // بيانات السكان والاحتياج
              _buildSectionTitle('بيانات السكان والاحتياج'),
              const SizedBox(height: 12),
              _buildInfoCard([
                _buildCategorySelector(),
                const SizedBox(height: 12),
                _buildInfoText(),
                const SizedBox(height: 16),
                _buildInfoFieldWithNumber('عدد العائلات', '340'),
                _buildInfoFieldWithNumber('عدد الأطفال', '385'),
                _buildInfoFieldWithNumber('عدد الذكور', '120'),
                _buildInfoFieldWithNumber('عدد النساء', '145'),
                _buildInfoFieldWithNumber('عدد ذوي الهمم', '12'),
              ]),
              const SizedBox(height: 24),

              // البنية التحتية والخدمات
              _buildSectionTitle('البنية التحتية والخدمات'),
              const SizedBox(height: 12),
              _buildInfoCard([
                _buildServiceField('مصدر المياه الأساسي', 'صهاريج مياه شال'),
                _buildServiceField('مصدر الطاقة الكهرب', 'لا يوجد'),
                _buildServiceField('حمامات', '3 حمامات'),
              ]),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _accent.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // وظيفة تحديث البيانات
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.arrow_back, color: _accent, size: 20),
                const SizedBox(width: 12),
                Text(
                  'تحديث بيانات المخيم',
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _accent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: _sectionTitleStyle(),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Widget _buildInfoField(String label, String value, {bool fullWidth = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _labelStyle()),
          const SizedBox(height: 8),
          Container(
            width: fullWidth ? double.infinity : null,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: _bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Text(
              value,
              style: _valueStyle(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoFieldWithNumber(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: _labelStyle()),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: _bg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Text(
                    value,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _labelStyle()),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: _bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: _valueStyle(),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white70,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('فئة الاحتياج بتصنيف العائلات', style: _labelStyle()),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildCategoryButton('C', 'سحم', selectedCategory == 'C'),
            _buildCategoryButton('B', 'متوسط', selectedCategory == 'B'),
            _buildCategoryButton('A', 'أجمد', selectedCategory == 'A'),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryButton(String category, String label, bool isSelected) {
    Color getCategoryColor() {
      switch (category) {
        case 'A':
          return const Color(0xFF4CAF50);
        case 'B':
          return const Color(0xFFFF9800);
        case 'C':
          return const Color(0xFF9E9E9E);
        default:
          return Colors.grey;
      }
    }

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCategory = category;
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: _bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? getCategoryColor()
                  : Colors.white.withOpacity(0.1),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: getCategoryColor(),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    category,
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
              if (isSelected)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Icon(
                    Icons.check_circle,
                    color: getCategoryColor(),
                    size: 16,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoText() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _bg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: Colors.white54,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'يحدد فئة الحساسة الأولى تخدم المنسقون سنمور بالتنسيق مع إدارة الأحتياج',
              style: GoogleFonts.cairo(
                fontSize: 11,
                color: Colors.white54,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceField(String label, String value) {
    IconData getIcon() {
      if (label.contains('المياه')) return Icons.water_drop_outlined;
      if (label.contains('الكهرب')) return Icons.bolt_outlined;
      if (label.contains('حمامات')) return Icons.wc_outlined;
      return Icons.info_outline;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _labelStyle()),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: _bg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Icon(
                  getIcon(),
                  color: _accent.withOpacity(0.7),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value,
                    style: _valueStyle(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
