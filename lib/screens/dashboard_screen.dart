import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartcamp_gazarecovery/utils/size_config.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  // Design colors tuned to the screenshot
  static const Color _bg = Color(0xFF0B1216);
  static const Color _card = Color(0xFF111B20);

  Color _cardColor(BuildContext context) => _card;

  Widget _buildAppBar(BuildContext context) {
    final double iconSize = SizeConfig.sp(context, 26);
    final double btnPadding = SizeConfig.sw(context, 8);
    final double avatarSize = SizeConfig.sw(context, 65);
    return SizedBox(
      height: SizeConfig.sh(context, 88),
      child: Row(
        children: [
          // Drawer/menu button (leading)
          IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            padding: EdgeInsets.all(btnPadding),
            icon: Icon(Icons.menu, color: Colors.white, size: iconSize),
          ),
          const Spacer(),
          // Notifications with small red badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {},
                padding: EdgeInsets.all(btnPadding),
                icon: Icon(Icons.notifications, color: Colors.white, size: iconSize),
              ),
              Positioned(
                right: SizeConfig.sw(context, 6),
                top: SizeConfig.sh(context, 6),
                child: Container(
                  width: SizeConfig.sw(context, 10),
                  height: SizeConfig.sw(context, 10),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: _card, width: 1.0),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: SizeConfig.sw(context, 12)),
          // User avatar
          Container(
            width: avatarSize,
            height: avatarSize,
            padding: EdgeInsets.all(SizeConfig.sw(context, 4)),
            decoration: BoxDecoration(
              color: _card,
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white.withAlpha((0.08 * 255).round()),
                  width: 1.6),
            ),
            child: CircleAvatar(
              radius: avatarSize / 2,
              backgroundColor: Colors.green.shade700,
              child: Icon(Icons.person, color: Colors.white, size: SizeConfig.sp(context, 20)),
            ),
          ),
        ],
      ),
    );
  }

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

  Widget _statusPill(BuildContext context, String text, {Color bg = const Color(0xFF0F3E2F)}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.sw(context, 10), vertical: SizeConfig.sh(context, 6)),
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
          style: GoogleFonts.cairo(color: Colors.white70, fontSize: SizeConfig.sp(context, 12))),
    );
  }

  Widget _statCard(
      BuildContext context, String label, String value, IconData icon,
      {Color? iconBg}) {
    final Color bg = _cardColor(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.sw(context, 14), vertical: SizeConfig.sh(context, 12)),
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
              SizedBox(height: SizeConfig.sh(context, 6)),
              Text(value, style: _statValueStyle()),
            ],
          ),
          // icon box
          Container(
            width: SizeConfig.sw(context, 46),
            height: SizeConfig.sw(context, 46),
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
      padding: EdgeInsets.symmetric(vertical: SizeConfig.sh(context, 18), horizontal: SizeConfig.sw(context, 16)),
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
                SizedBox(height: SizeConfig.sh(context, 6)),
                Text(value, style: _bigValueStyle()),
              ],
            ),
          ),
          if (icon != null)
            Container(
              width: SizeConfig.sw(context, 46),
              height: SizeConfig.sw(context, 46),
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
          padding: EdgeInsets.symmetric(vertical: SizeConfig.sh(context, 18), horizontal: SizeConfig.sw(context, 16)),
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
                width: SizeConfig.sw(context, 72),
                height: SizeConfig.sw(context, 72),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha((0.25 * 255).round()),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(value, style: _emergencyValueStyle()),
              ),
              SizedBox(width: SizeConfig.sw(context, 12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('احتياجات عاجلة',
                        style: GoogleFonts.cairo(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                    SizedBox(height: SizeConfig.sh(context, 6)),
                    Text('تفاصيل أو وصف مختصر',
                        style: GoogleFonts.cairo(
                            color: Colors.white.withAlpha((0.6 * 255).round()),
                            fontSize: 13)),
                  ],
                ),
              ),
              Container(
                width: SizeConfig.sw(context, 48),
                height: SizeConfig.sw(context, 48),
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
          right: -SizeConfig.sw(context, 8),
          top: SizeConfig.sh(context, 12),
          bottom: SizeConfig.sh(context, 12),
          child: Container(
            width: SizeConfig.sw(context, 8),
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
    return Builder(builder: (context) {
      return Container(
        padding: EdgeInsets.all(SizeConfig.sw(context, 12)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor.withAlpha((0.9 * 255).round())),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
            SizedBox(height: SizeConfig.sh(context, 8)),
            Text(subtitle,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      );
    });
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
      // Drawer present so the menu button opens it
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: const [
              ListTile(title: Text('القائمة')),
            ],
          ),
        ),
      ),
       backgroundColor: _bg,
       body: SafeArea(
         child: Padding(
         padding: EdgeInsets.symmetric(horizontal: SizeConfig.sw(context, 16)),
           child: SingleChildScrollView(
             padding: EdgeInsets.only(bottom: SizeConfig.sh(context, 120)),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.stretch,
               children: [
                 // Responsive custom app bar (menu, notifications, user)
                Builder(builder: (ctx) => _buildAppBar(ctx)),
                SizedBox(height: SizeConfig.sh(context, 65)),
                Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('مخيم الست اميرة',
                            style: GoogleFonts.cairo(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.white)),
                        SizedBox(height: SizeConfig.sh(context, 6)),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                size: 14, color: Colors.white54),
                            SizedBox(width: SizeConfig.sw(context, 6)),
                            Text('المنطقة الوسطى / البركة',
                                style: GoogleFonts.cairo(
                                    fontSize: 12,
                                    color: Colors.white54)),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
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

                SizedBox(height: SizeConfig.sh(context, 12)),

                _bigCard(context, 'عدد ذوي الهمم', '65',
                    icon: Icons.accessible, accent: Colors.orange),
                SizedBox(height: SizeConfig.sh(context, 12)),

                // Emergency row
                Row(
                  children: [
                    Expanded(
                        child: _emergencyCard(context, 'احتياجات عاجلة', '3')),
                    SizedBox(width: SizeConfig.sw(context, 12)),
                    Expanded(
                        child: _bigCard(context, 'عدد الخيام المجاورة', '50',
                            icon: Icons.home, accent: Colors.blue)),
                  ],
                ),

                SizedBox(height: SizeConfig.sh(context, 14)),

                // Colored small boxes (3)
                Row(
                  children: [
                    Expanded(
                        child: _coloredBox('فئة أ', '15/160', Colors.green)),
                    SizedBox(width: SizeConfig.sw(context, 10)),
                    Expanded(
                        child: _coloredBox('فئة ب', '60/100', Colors.orange)),
                    SizedBox(width: SizeConfig.sw(context, 10)),
                    Expanded(child: _coloredBox('فئة ج', '45/50', Colors.red)),
                  ],
                ),

                SizedBox(height: SizeConfig.sh(context, 18)),

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

                SizedBox(height: SizeConfig.sh(context, 18)),

                // Infrastructure row
                Row(
                  children: [
                    Expanded(
                        child: _statusBox(
                            context, 'مياه للاستخدام', 'متوفرة', Colors.blue)),
                    SizedBox(width: SizeConfig.sw(context, 12)),
                    Expanded(
                        child: _statusBox(
                            context, 'مياه الشرب', 'لا تتوفر', Colors.red)),
                    SizedBox(width: SizeConfig.sw(context, 12)),
                    Expanded(
                        child: _statusBox(
                            context, 'الحمامات', 'متوفر(3)', Colors.green)),
                  ],
                ),

                SizedBox(height: SizeConfig.sh(context, 18)),

                // Highlights (list)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _highlightTile(context, 'نقص حاد في المياه',
                        'تم الإبلاغ منذ ساعتين', Colors.redAccent, 'عاجل جداً'),
                    SizedBox(height: SizeConfig.sh(context, 10)),
                    _highlightTile(context, 'مستلزمات طبية',
                        'تم الإبلاغ منذ 5 ساعات', Colors.orangeAccent, 'متوسط'),
                    SizedBox(height: SizeConfig.sh(context, 10)),
                    _highlightTile(context, 'توزيع سلال غذائية',
                        'تم الإبلاغ منذ يوم', Colors.green, 'مجدول'),
                  ],
                ),

                SizedBox(height: SizeConfig.sh(context, 80)),
               ],
             ),
           ),
         ),
       ),
    );
  }

  Widget _actionCard(
      BuildContext context, String title, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.sw(context, 14)),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withAlpha((0.05 * 255).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: SizeConfig.sw(context, 46),
            height: SizeConfig.sw(context, 46),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          SizedBox(width: SizeConfig.sw(context, 12)),
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
      padding: EdgeInsets.all(SizeConfig.sw(context, 12)),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withAlpha((0.04 * 255).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          SizedBox(height: SizeConfig.sh(context, 8)),
          Text(status,
              style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _highlightTile(BuildContext context, String title, String subtitle,
      Color tagColor, String tagLabel) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.sw(context, 12)),
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
                SizedBox(height: SizeConfig.sh(context, 6)),
                Text(subtitle,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.sw(context, 10), vertical: SizeConfig.sh(context, 6)),
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
