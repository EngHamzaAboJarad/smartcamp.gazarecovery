import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartcamp_gazarecovery/features/donations/presentation/widgets/donation_card.dart';
import 'package:smartcamp_gazarecovery/features/donations/presentation/widgets/summary_card.dart';
import 'package:smartcamp_gazarecovery/shared/utils/size_config.dart';

class DonationsScreen extends StatefulWidget {
  const DonationsScreen({Key? key}) : super(key: key);

  @override
  State<DonationsScreen> createState() => _DonationsScreenState();
}

class _DonationsScreenState extends State<DonationsScreen> {
  String _selectedFilter = 'all';

  final List<Map<String, dynamic>> _donations = [
    {
      'quantity': 250,
      'title': 'سلال غذائية عائلية',
      'org': 'الهلال الأحمر',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'status': 'completed',
      'color': const Color(0xFF4CAF50),
      'icon': Icons.shopping_bag,
    },
    {
      'quantity': 120,
      'title': 'مواد عينية للأطفال',
      'org': 'منظمة رعاية',
      'date': DateTime.now().subtract(const Duration(days: 4)),
      'status': 'in_progress',
      'color': const Color(0xFF2196F3),
      'icon': Icons.child_care,
    },
    {
      'quantity': 80,
      'title': 'ملابس شتوية',
      'org': 'مؤسسة التطوع',
      'date': DateTime.now().subtract(const Duration(days: 6)),
      'status': 'completed',
      'color': const Color(0xFFE91E63),
      'icon': Icons.checkroom,
    },
    {
      'quantity': 500,
      'title': 'مياه شرب','org': 'بنك المياه',
      'date': DateTime.now().subtract(const Duration(days: 8)),
      'status': 'in_progress',
      'color': const Color(0xFF9C27B0),
      'icon': Icons.water,
    },
  ];

  List<Map<String, dynamic>> get _filteredDonations {
    if (_selectedFilter == 'all') return _donations;
    if (_selectedFilter == 'food_basket') {
      return _donations.where((d) => d['title']?.toString().contains('سلال') == true).toList();
    }
    if (_selectedFilter == 'goods') {
      return _donations.where((d) => d['title']?.toString().contains('مواد') == true || d['title']?.toString().contains('ملابس') == true).toList();
    }
    return _donations;
  }

  @override
  Widget build(BuildContext context) {
      const Color _bg = Color(0xFF0B1216);
      const Color _card = Color(0xFF111B20);
      const Color _accent = Color(0xFF2196F3);
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          backgroundColor: _bg,
          elevation: 0,
          centerTitle: true,
          // In RTL, leading appears on the right (start)
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.maybePop(context),
          ),
          title: Text('سجل التبرعات', style: GoogleFonts.cairo(fontWeight: FontWeight.w700)),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [      Color(0xFF0B1C2D),
            //     Color(0xFF0A2238),
            //     Color(0xFF061525),],
            // ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(SizeConfig.sw(context, 16), SizeConfig.sh(context, 8), SizeConfig.sw(context, 16), SizeConfig.sh(context, 12) + bottomInset),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Filters
                  SizedBox(
                    height: SizeConfig.sh(context, 44),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip('all', 'الكل'),
                          SizedBox(width: SizeConfig.sw(context, 8)),
                          _buildFilterChip('food_basket', 'سلال غذائية'),
                          SizedBox(width: SizeConfig.sw(context, 8)),
                          _buildFilterChip('goods', 'مواد عينية'),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.sh(context, 16)),

                  // Summary title
                  Text('ملخص هذا الشهر', style: GoogleFonts.cairo(fontSize: SizeConfig.sp(context, 16), fontWeight: FontWeight.w700, color: Colors.white)),
                  SizedBox(height: SizeConfig.sh(context, 12)),

                  Row(
                    children: [
                      Expanded(
                        child: SummaryCard(title: 'إجمالي التبرعات', value: '1,250', delta: '12%', deltaColor: const Color(0xFF4CAF50), icon: Icons.attach_money),
                      ),
                      SizedBox(width: SizeConfig.sw(context, 12)),
                      Expanded(
                        child: SummaryCard(title: 'عدد التبرعات', value: '14', delta: '2%', deltaColor: const Color(0xFF4CAF50), icon: Icons.receipt_long),
                      ),
                    ],
                  ),

                  SizedBox(height: SizeConfig.sh(context, 18)),

                  // Recent donations title
                  Text('التبرعات الأخيرة', style: GoogleFonts.cairo(fontSize: SizeConfig.sp(context, 16), fontWeight: FontWeight.w700, color: Colors.white)),
                  SizedBox(height: SizeConfig.sh(context, 12)),

                  // List
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredDonations.length,
                      itemBuilder: (context, index) {
                        final d = _filteredDonations[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: SizeConfig.sh(context, 12)),
                          child: DonationCard(
                            quantity: d['quantity'] as int,
                            title: d['title'] as String,
                            organization: d['org'] as String,
                            date: d['date'] as DateTime,
                            status: d['status'] as String,
                            color: d['color'] as Color,
                            icon: d['icon'] as IconData,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final selected = _selectedFilter == key;
    final accent = const Color(0xFF2196F3);
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.sw(context, 12), vertical: SizeConfig.sh(context, 8)),
        decoration: BoxDecoration(
          color: selected ? accent : const Color(0x1AFFFFFF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? accent : Color.fromRGBO(255, 255, 255, 0.03)),
        ),
        child: Text(label, style: GoogleFonts.cairo(color: selected ? Colors.white : Colors.white70, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

