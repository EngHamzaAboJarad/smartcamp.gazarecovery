import 'package:flutter/material.dart';
import '../utils/size_config.dart';

// Asset paths used in this design (you can swap files as needed)
const String _iconsDir = 'images/icons';
const String _fdsDir = 'images/family_details_screen_images';
const String _avatarMale =
    '$_fdsDir/a2ecabc9c31a4f034b15a80dc65da332f15073e1.png';
const String _avatarFemale =
    '$_fdsDir/800459d11d2b9666816b4cf7f89ec01f627f5d4b.png';
const String _avatarBoy =
    '$_fdsDir/723067b2d46d1be887f4091a67e3bcf878514280.png';
const String _avatarGirl =
    '$_fdsDir/8758d41530503eeaa8cc286d599c22e734900104.png';
const String _avatarElder =
    '$_fdsDir/c9d63a92dd8f4bae4bd9d68da970747fd4e244e0.png';
const String _arrowRight = '$_iconsDir/drou.png';

class FamilyDetailsScreen extends StatelessWidget {
  const FamilyDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = const Color(0xFF0F1419);
    final card = const Color(0xFF111821);
    final accent = const Color(0xFF2D86FF);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text(
          'تفاصيل العائلة',
          textDirection: TextDirection.rtl,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 16),
            child: Image.asset(
              _arrowRight,
              width: SizeConfig.sw(context, 18),
              height: SizeConfig.sw(context, 18),
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.sw(context, 16),
            vertical: SizeConfig.sh(context, 12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ProfileHeader(card: card, accent: accent),
              SizedBox(height: SizeConfig.sh(context, 12)),
              _LastUpdateBanner(card: card),
              SizedBox(height: SizeConfig.sh(context, 12)),
              _IdentityRow(card: card),
              SizedBox(height: SizeConfig.sh(context, 12)),
              _StatsGrid(card: card, accent: accent),
              SizedBox(height: SizeConfig.sh(context, 20)),
              Text(
                'أفراد الأسرة',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: SizeConfig.sh(context, 8)),
              const _MemberTile(
                  name: 'أحمد محمد', role: 'رب الأسرة', age: 45, isHead: true),
              const _MemberTile(name: 'فاطمة علي', role: 'زوجة', age: 40),
              const _MemberTile(
                  name: 'عمر أحمد', role: 'ابن', age: 12, isChild: true),
              const _MemberTile(
                  name: 'سارة أحمد', role: 'ابنة', age: 9, isChild: true),
              const _MemberTile(
                  name: 'محمد عبد الله',
                  role: 'جد • حالة صحية',
                  age: 75,
                  hasHealthBadge: true),
              SizedBox(height: SizeConfig.sh(context, 20)),
              SizedBox(
                height: SizeConfig.sh(context, 48),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('تحديث البيانات'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MemberAvatar extends StatelessWidget {
  final bool isHead;
  final bool isChild;
  final String name;
  final String role;
  const _MemberAvatar(
      {required this.isHead,
      required this.isChild,
      required this.name,
      required this.role});

  String _resolveAsset(String roleText) {
    final t = roleText.trim();
    // Simple heuristics for demo; adjust as needed.
    if (t.contains('زوجة')) return _avatarFemale;
    if (t.contains('ابنة')) return _avatarGirl;
    if (t.contains('جد') || t.contains('جدة')) return _avatarElder;
    if (isChild) return _avatarBoy;
    if (isHead) return _avatarMale;
    // Fallback based on name feminine marker
    if (name.endsWith('ة')) return _avatarFemale;
    return _avatarMale;
  }

  @override
  Widget build(BuildContext context) {
    final path = _resolveAsset(role);
    return CircleAvatar(
      radius: SizeConfig.sw(context, 20),
      backgroundColor: const Color(0xFF1B2430),
      backgroundImage: AssetImage(path),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final Color card;
  final Color accent;
  const _ProfileHeader({required this.card, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.sw(context, 16)),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: SizeConfig.sw(context, 32),
            backgroundColor: const Color(0xFF1B2430),
            backgroundImage: const AssetImage(_avatarMale),
          ),
          SizedBox(width: SizeConfig.sw(context, 12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أحمد محمد عبد الله',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.sp(context, 16),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: SizeConfig.sh(context, 6)),
                Wrap(
                  spacing: SizeConfig.sw(context, 8),
                  runSpacing: SizeConfig.sh(context, 6),
                  children: [
                    _Badge(text: 'B', color: const Color(0xFF2B3440)),
                    _Badge(
                        text: 'B-124 :رقم الخيمة',
                        color: const Color(0xFF1E2732),
                        icon: Icons.shield),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;
  const _Badge({required this.text, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.sw(context, 10),
        vertical: SizeConfig.sh(context, 6),
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: SizeConfig.sp(context, 14), color: Colors.white70),
            SizedBox(width: SizeConfig.sw(context, 6)),
          ],
          Text(
            text,
            style: TextStyle(
                color: Colors.white70, fontSize: SizeConfig.sp(context, 12)),
          ),
        ],
      ),
    );
  }
}

class _LastUpdateBanner extends StatelessWidget {
  final Color card;
  const _LastUpdateBanner({required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.sw(context, 14)),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blueAccent),
          SizedBox(width: SizeConfig.sw(context, 8)),
          Expanded(
            child: Text(
              '.البيانات محدّثة بتاريخ 1 أكتوبر 2023\nيرجى تحديث البيانات في حال أي تغيير',
              style: TextStyle(
                  color: Colors.white70, fontSize: SizeConfig.sp(context, 12)),
            ),
          ),
        ],
      ),
    );
  }
}

class _IdentityRow extends StatelessWidget {
  final Color card;
  const _IdentityRow({required this.card});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: _InfoTile(card: card, title: 'هوية', value: '406301020')),
        SizedBox(width: SizeConfig.sw(context, 12)),
        Expanded(
            child: _InfoTile(
                card: card, title: 'الجوال رقم', value: '0599123456')),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final Color card;
  final String title;
  final String value;
  const _InfoTile(
      {required this.card, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.sw(context, 14)),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people, color: Colors.white60, size: 18),
              SizedBox(width: SizeConfig.sw(context, 6)),
              Text(title,
                  style: TextStyle(
                      color: Colors.white60,
                      fontSize: SizeConfig.sp(context, 12))),
            ],
          ),
          SizedBox(height: SizeConfig.sh(context, 8)),
          Text(value,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig.sp(context, 14),
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final Color card;
  final Color accent;
  const _StatsGrid({required this.card, required this.accent});

  @override
  Widget build(BuildContext context) {
    final items = [
      const _StatItem(
          title: 'إجمالي أفراد العائلة', value: '5', icon: Icons.groups),
      const _StatItem(title: 'عدد الأطفال', value: '2', icon: Icons.child_care),
      const _StatItem(title: 'عدد الذكور', value: '3', icon: Icons.male),
      const _StatItem(title: 'عدد النساء', value: '2', icon: Icons.female),
      const _StatItem(title: 'عدد كبار السن', value: '1', icon: Icons.elderly),
      const _StatItem(
          title: 'عدد ذوي الهمم', value: '1', icon: Icons.accessible),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 420;
        final crossAxisCount = isWide ? 3 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: SizeConfig.sw(context, 12),
            mainAxisSpacing: SizeConfig.sh(context, 12),
            childAspectRatio: isWide ? 3 / 2 : 4 / 3,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.all(SizeConfig.sw(context, 14)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(item.icon, color: Colors.white60),
                      SizedBox(width: SizeConfig.sw(context, 6)),
                      Expanded(
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize: SizeConfig.sp(context, 12)),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    item.value,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.sp(context, 20),
                      fontWeight: FontWeight.w800,
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _StatItem {
  final String title;
  final String value;
  final IconData icon;
  const _StatItem(
      {required this.title, required this.value, required this.icon});
}

class _MemberTile extends StatelessWidget {
  final String name;
  final String role;
  final int age;
  final bool isHead;
  final bool isChild;
  final bool hasHealthBadge;
  const _MemberTile({
    required this.name,
    required this.role,
    required this.age,
    this.isHead = false,
    this.isChild = false,
    this.hasHealthBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final card = const Color(0xFF111821);
    return Container(
      margin: EdgeInsets.only(bottom: SizeConfig.sh(context, 10)),
      padding: EdgeInsets.all(SizeConfig.sw(context, 12)),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _MemberAvatar(
              isHead: isHead, isChild: isChild, name: name, role: role),
          SizedBox(width: SizeConfig.sw(context, 12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.sp(context, 14),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (hasHealthBadge)
                      Container(
                        width: SizeConfig.sw(context, 18),
                        height: SizeConfig.sw(context, 18),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFF4D5E),
                        ),
                        child: const Icon(Icons.local_hospital,
                            color: Colors.white, size: 14),
                      ),
                  ],
                ),
                SizedBox(height: SizeConfig.sh(context, 4)),
                Wrap(
                  spacing: SizeConfig.sw(context, 6),
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.sw(context, 8),
                        vertical: SizeConfig.sh(context, 4),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2732),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        role,
                        style: TextStyle(
                            color: Colors.white60,
                            fontSize: SizeConfig.sp(context, 11)),
                      ),
                    ),
                    Text(
                      'سنة $age',
                      style: TextStyle(
                          color: Colors.white60,
                          fontSize: SizeConfig.sp(context, 12)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
