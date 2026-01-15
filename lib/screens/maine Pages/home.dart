import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartcamp_gazarecovery/screens/maine%20Pages/tents.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  // Design colors tuned to the screenshot
  static const Color _bg = Color(0xFF0B1216);
  static const Color _card = Color(0xFF111B20);

  Color _cardColor(BuildContext context) => _card;

  // Text styles using Cairo (Google Fonts) for better Arabic rendering
  TextStyle _titleStyle() => GoogleFonts.cairo(
      fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white);
  TextStyle _subtitleStyle() =>
      GoogleFonts.cairo(fontSize: 12, color: Colors.white70);
  TextStyle _statLabelStyle() =>
      GoogleFonts.cairo(fontSize: 12, color: Colors.white70);
  TextStyle _statValueStyle() => GoogleFonts.cairo(
      fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white);
  TextStyle _bigLabelStyle() =>
      GoogleFonts.cairo(fontSize: 14, color: Colors.white70);
  TextStyle _bigValueStyle() => GoogleFonts.cairo(
      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white);
  TextStyle _emergencyValueStyle() => GoogleFonts.cairo(
      fontSize: 36, fontWeight: FontWeight.bold, color: Colors.redAccent);

  Widget _statusPill(String text, {Color bg = const Color(0xFF0F3E2F)}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha((0.3 * 255).round()),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Text(text,
          style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12)),
    );
  }

  Widget _statCard(
      BuildContext context, String label, String value, IconData icon,
      {Color? iconBg}) {
    final Color bg = _cardColor(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withAlpha((0.02 * 255).round())),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // label and value (on the right because of RTL)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: _statLabelStyle()),
              const SizedBox(height: 6),
              Text(value, style: _statValueStyle()),
            ],
          ),
          // icon box
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: iconBg ?? Colors.blueGrey.shade700,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withAlpha((0.35 * 255).round()),
                    blurRadius: 4,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Icon(icon, color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget _bigCard(BuildContext context, String label, String value,
      {IconData? icon, Color? accent}) {
    final Color bg = _cardColor(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
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
                Text(label, style: _bigLabelStyle()),
                const SizedBox(height: 6),
                Text(value, style: _bigValueStyle()),
              ],
            ),
          ),
          if (icon != null)
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: accent ?? Colors.deepPurple,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white),
            ),
        ],
      ),
    );
  }

  Widget _emergencyCard(BuildContext context, String label, String value) {
    final Color bg = _cardColor(context);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border:
                Border.all(color: Colors.white.withAlpha((0.02 * 255).round())),
          ),
          child: Row(
            children: [
              // large red number on the left (visual left) — in RTL this appears left
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha((0.25 * 255).round()),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(value, style: _emergencyValueStyle()),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('احتياجات عاجلة',
                        style: GoogleFonts.cairo(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text('تفاصيل أو وصف مختصر',
                        style: GoogleFonts.cairo(
                            color: Colors.white.withAlpha((0.6 * 255).round()),
                            fontSize: 13)),
                  ],
                ),
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.error_outline, color: Colors.white),
              ),
            ],
          ),
        ),
        // red vertical indicator on the right edge
        Positioned(
          right: -8,
          top: 12,
          bottom: 12,
          child: Container(
            width: 8,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                    color: Colors.redAccent.withAlpha((0.3 * 255).round()),
                    blurRadius: 6,
                    offset: const Offset(2, 0))
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _coloredBox(String title, String subtitle, Color borderColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor.withAlpha((0.9 * 255).round())),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 8),
          Text(subtitle,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // responsive grid aspect ratio based on screen width so cards don't overflow
    final double fullWidth = MediaQuery.of(context).size.width -
        32; // horizontal padding 16 each side
    final double cellWidth = (fullWidth - 12) / 2; // two columns, spacing 12
    const double targetCellHeight = 120.0; // target height for stat cards
    final double gridAspect = cellWidth / targetCellHeight;
    // quick action cards height target
    const double actionCardHeight = 100.0;
    final double actionAspect = cellWidth / actionCardHeight;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                // small top-left label outside the card like the screenshot
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2, bottom: 6),
                    child: Text('الرئيسية',
                        style: GoogleFonts.cairo(
                            color: Colors.white24, fontSize: 12)),
                  ),
                ),

                // Header: wrapped in a rounded dark card to match the screenshot
                SizedBox(
                  height:
                      104, // fixed header height to match screenshot proportions
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: _card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color:
                                Colors.white.withAlpha((0.02 * 255).round())),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Avatar column (avatar + status pill)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // outer ring + avatar
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: _card,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white
                                              .withAlpha((0.08 * 255).round()),
                                          width: 1.6),
                                    ),
                                    child: CircleAvatar(
                                      radius:
                                          26, // slightly larger to match screenshot scale
                                      backgroundColor: Colors.green.shade700,
                                      child: const Icon(Icons.person,
                                          color: Colors.white, size: 20),
                                    ),
                                  ),
                                  Positioned(
                                    right: -10,
                                    top: -10,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: _card, width: 1.6),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              // status pill
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF155C44),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Text('مكتمل',
                                    style: GoogleFonts.cairo(
                                        color: Colors.white70, fontSize: 12)),
                              ),
                            ],
                          ),

                          const SizedBox(
                              width: 14), // tuned gap between avatar and title

                          // Middle column: title and subtitle
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('مخيم الست اميرة',
                                    style: GoogleFonts.cairo(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined,
                                        size: 14, color: Colors.white54),
                                    const SizedBox(width: 6),
                                    Text('المنطقة الوسطى / البركة',
                                        style: GoogleFonts.cairo(
                                            fontSize: 12,
                                            color: Colors.white54)),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Right icons: bell + menu (compact)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    padding: const EdgeInsets.all(8),
                                    constraints: const BoxConstraints(
                                        minWidth: 40, minHeight: 40),
                                    icon: const Icon(
                                        Icons.notifications_outlined,
                                        color: Colors.white70),
                                  ),
                                  Positioned(
                                    right: 8,
                                    top: 6,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: _card, width: 1.2),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {},
                                padding: const EdgeInsets.all(8),
                                constraints: const BoxConstraints(
                                    minWidth: 40, minHeight: 40),
                                icon: const Icon(Icons.menu,
                                    color: Colors.white70),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Grid of small stats (2 columns)
                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  // responsive aspect so cards have enough height on small screens
                  childAspectRatio: gridAspect,
                  children: [
                    _statCard(context, 'عدد الأفراد', '850', Icons.people,
                        iconBg: Colors.indigo),
                    _statCard(context, 'عدد الخيام', '150', Icons.home,
                        iconBg: Colors.blue),
                    _statCard(context, 'عدد الأطفال', '450',
                        Icons.sentiment_satisfied,
                        iconBg: Colors.teal),
                    _statCard(
                        context, 'عدد العائلات', '210', Icons.family_restroom,
                        iconBg: Colors.purple),
                    _statCard(context, 'عدد النساء', '220', Icons.female,
                        iconBg: Colors.pink),
                    _statCard(context, 'عدد الذكور', '180', Icons.male,
                        iconBg: Colors.lightBlue),
                  ],
                ),

                const SizedBox(height: 12),

                _bigCard(context, 'عدد ذوي الهمم', '65',
                    icon: Icons.accessible, accent: Colors.orange),
                const SizedBox(height: 12),

                // Emergency row
                Row(
                  children: [
                    Expanded(
                        child: _emergencyCard(context, 'احتياجات عاجلة', '3')),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _bigCard(context, 'عدد الخيام المجاورة', '50',
                            icon: Icons.home, accent: Colors.blue)),
                  ],
                ),

                const SizedBox(height: 14),

                // Colored small boxes (3)
                Row(
                  children: [
                    Expanded(
                        child: _coloredBox('فئة أ', '15/160', Colors.green)),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _coloredBox('فئة ب', '60/100', Colors.orange)),
                    const SizedBox(width: 10),
                    Expanded(child: _coloredBox('فئة ج', '45/50', Colors.red)),
                  ],
                ),

                const SizedBox(height: 18),

                // Quick actions grid
                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: actionAspect,
                  children: [
                    _actionCard(context, 'الإبلاغ عن احتياج',
                        Icons.notifications_active, Colors.blueAccent),
                    _actionCard(
                        context, 'تحديث البيانات', Icons.edit, Colors.teal),
                    _actionCard(context, 'الدعم الفني', Icons.support_agent,
                        Colors.amber),
                    _actionCard(context, 'الخيام في المخيم', Icons.home_work,
                        Colors.indigo),
                  ],
                ),

                const SizedBox(height: 18),

                // Infrastructure row
                Row(
                  children: [
                    Expanded(
                        child: _statusBox(
                            context, 'مياه للاستخدام', 'متوفرة', Colors.blue)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _statusBox(
                            context, 'مياه الشرب', 'لا تتوفر', Colors.red)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _statusBox(
                            context, 'الحمامات', 'متوفر(3)', Colors.green)),
                  ],
                ),

                const SizedBox(height: 18),

                // Highlights (list)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _highlightTile(context, 'نقص حاد في المياه',
                        'تم الإبلاغ منذ ساعتين', Colors.redAccent, 'عاجل جداً'),
                    const SizedBox(height: 10),
                    _highlightTile(context, 'مستلزمات طبية',
                        'تم الإبلاغ منذ 5 ساعات', Colors.orangeAccent, 'متوسط'),
                    const SizedBox(height: 10),
                    _highlightTile(context, 'توزيع سلال غذائية',
                        'تم الإبلاغ منذ يوم', Colors.green, 'مجدول'),
                  ],
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),

      // Bottom navigation
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0B0F13),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حساب'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'المساعدات'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الخيام'),
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view), label: 'الرئيسية'),
        ],
        currentIndex: 3,
        onTap: (i) {
          if (i == 2) {
            // الخيام - الفهرس 2
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TentsScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _actionCard(
      BuildContext context, String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withAlpha((0.05 * 255).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _statusBox(
      BuildContext context, String title, String status, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withAlpha((0.04 * 255).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Text(status,
              style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _highlightTile(BuildContext context, String title, String subtitle,
      Color tagColor, String tagLabel) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withAlpha((0.04 * 255).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(subtitle,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: tagColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(tagLabel,
                style: const TextStyle(color: Colors.white, fontSize: 12)),
          )
        ],
      ),
    );
  }
}
