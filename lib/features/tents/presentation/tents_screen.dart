import 'package:flutter/material.dart';
import 'package:smartcamp_gazarecovery/shared/utils/size_config.dart';
import 'package:smartcamp_gazarecovery/core/routes.dart';

class TentsScreen extends StatefulWidget {
  const TentsScreen({super.key});

  @override
  State<TentsScreen> createState() => _TentsScreenState();
}

class _TentsScreenState extends State<TentsScreen> {
  String selectedType = 'الكل';
  String selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isWide = screenWidth > 800;
    final double horizontalPadding = SizeConfig.sw(context, 16);
    final double maxWidth = isWide ? 800.0 : double.infinity;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1419),
        elevation: 0,
        title: Text(
          'الخيام',
          style: TextStyle(
            color: Colors.white70,
            fontSize: SizeConfig.sp(context, 18),
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCampInfoCard(),
                      SizedBox(height: SizeConfig.sh(context, 20)),
                      _buildSearchBar(),
                      SizedBox(height: SizeConfig.sh(context, 24)),
                      _buildSectionTitle('نوع الإيواء'),
                      SizedBox(height: SizeConfig.sh(context, 12)),
                      _buildShelterTypes(),
                      SizedBox(height: SizeConfig.sh(context, 24)),
                      _buildSectionTitle('تصنيف الاحتياج العائلة'),
                      SizedBox(height: SizeConfig.sh(context, 12)),
                      _buildFamilyCategories(),
                      SizedBox(height: SizeConfig.sh(context, 24)),
                      _buildTentCard(
                        tentId: 'A-101',
                        label: 'A',
                        labelColor: const Color(0xFFE74C3C),
                        familyName: 'محمد الأحمد',
                        location: 'داخل المخيم',
                        members: 6,
                        phone: '0599123456',
                        idNumber: '406001020',
                        icon: Icons.campaign_outlined,
                        iconColor: Colors.blue,
                      ),
                      SizedBox(height: SizeConfig.sh(context, 12)),
                      _buildTentCard(
                        tentId: 'خيمة مبأورة',
                        label: 'B',
                        labelColor: const Color(0xFFE67E22),
                        familyName: 'سالم الفرج',
                        location: 'مخامر',
                        members: 8,
                        phone: '0599123456',
                        idNumber: '406301020',
                        icon: Icons.home_outlined,
                        iconColor: Colors.purple,
                      ),
                      SizedBox(height: SizeConfig.sh(context, 12)),
                      _buildTentCard(
                        tentId: 'بناء الهدى شقة 3',
                        label: 'C',
                        labelColor: const Color(0xFF16A085),
                        familyName: 'خالد النامي',
                        location: null,
                        members: 4,
                        phone: '0599123456',
                        idNumber: '406301020',
                        icon: Icons.business_outlined,
                        iconColor: Colors.teal,
                      ),
                      SizedBox(height: SizeConfig.sh(context, 12)),
                      _buildTentCard(
                        tentId: 'A-103a',
                        label: 'لكي',
                        labelColor: const Color(0xFF95A5A6),
                        familyName: 'حامزة السبيين',
                        location: 'داخل المخيم',
                        members: null,
                        phone: null,
                        idNumber: null,
                        icon: Icons.apartment_outlined,
                        iconColor: Colors.grey,
                      ),
                      SizedBox(height: SizeConfig.sh(context, 80)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: const Color(0xFF2196F3),
        icon: Icon(
          Icons.add_location_alt_outlined,
          color: Colors.white,
          size: SizeConfig.sp(context, 22),
        ),
        label: Text(
          'إضافة خيمة',
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.sp(context, 16),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCampInfoCard() {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isLarge = screenWidth > 800;

    return Container(
      padding: EdgeInsets.all(SizeConfig.sw(context, 20)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E3A5F),
            Color(0xFF0D1F33),
          ],
        ),
        borderRadius: BorderRadius.circular(SizeConfig.sw(context, 16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'الخيام',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: SizeConfig.sp(context, 20),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: SizeConfig.sh(context, 6)),
              Text(
                'مخيم النور ومحيطه',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: SizeConfig.sp(context, 14),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.sw(context, 12),
              vertical: SizeConfig.sh(context, 6),
            ),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((0.15 * 255).round()),
              borderRadius: BorderRadius.circular(SizeConfig.sw(context, 8)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_city,
                  color: Colors.white70,
                  size: SizeConfig.sp(context, 16),
                ),
                SizedBox(width: SizeConfig.sw(context, 6)),
                Text(
                  '216 مكان',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: SizeConfig.sp(context, 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A2530),
        borderRadius: BorderRadius.circular(isTablet ? 14 : 12),
        border: Border.all(color: Colors.white.withAlpha((0.1 * 255).round())),
      ),
      child: TextField(
        textAlign: TextAlign.right,
        style: TextStyle(
          color: Colors.white,
          fontSize: isTablet ? SizeConfig.sp(context, 16) : SizeConfig.sp(context, 14),
        ),
        decoration: InputDecoration(
          hintText: 'بحث برقم المكان، اسم العائلة، أو النوع...',
          hintStyle: TextStyle(
            color: Colors.white.withAlpha((0.5 * 255).round()),
            fontSize: isTablet ? SizeConfig.sp(context, 16) : SizeConfig.sp(context, 14),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white.withAlpha((0.5 * 255).round()),
            size: isTablet ? SizeConfig.sp(context, 26) : SizeConfig.sp(context, 22),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: isTablet ? SizeConfig.sw(context, 20) : SizeConfig.sw(context, 16),
            vertical: isTablet ? SizeConfig.sh(context, 18) : SizeConfig.sh(context, 14),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: isTablet ? SizeConfig.sp(context, 16) : SizeConfig.sp(context, 14),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildShelterTypes() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        children: [
          _buildTypeButton('الكل', Icons.grid_view, Colors.blue),
          const SizedBox(width: 8),
          _buildTypeButton('داخل المخيم', Icons.campaign_outlined, Colors.blue),
          const SizedBox(width: 8),
          _buildTypeButton('مخيم الخيميم', Icons.home_outlined, Colors.purple),
          const SizedBox(width: 8),
          _buildTypeButton('مبانى', Icons.business_outlined, Colors.teal),
        ],
      ),
    );
  }

  Widget _buildTypeButton(String label, IconData icon, Color color) {
    final isSelected = selectedType == label;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return InkWell(
      onTap: () {
        setState(() {
          selectedType = label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 20 : 16,
          vertical: isTablet ? 12 : 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : const Color(0xFF1A2530),
          borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.white60,
              size: isTablet ? 22 : 18,
            ),
            SizedBox(width: isTablet ? 8 : 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.white60,
                fontSize: isTablet ? 15 : 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFamilyCategories() {
    return Row(
      children: [
        Expanded(
          child: _buildCategoryButton('فئة A', const Color(0xFF16A085)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildCategoryButton('فئة B', const Color(0xFFE67E22)),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildCategoryButton('فئة A', const Color(0xFFE74C3C)),
        ),
      ],
    );
  }

  Widget _buildCategoryButton(String label, Color color) {
    final isSelected = selectedCategory == label;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return InkWell(
      onTap: () {
        setState(() {
          selectedCategory = isSelected ? '' : label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isTablet ? 14 : 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2530),
          borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: isTablet ? 10 : 8,
              height: isTablet ? 10 : 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: isTablet ? 10 : 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.white60,
                fontSize: isTablet ? 15 : 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTentCard({
    required String tentId,
    required String label,
    required Color labelColor,
    required String familyName,
    required String? location,
    required int? members,
    required String? phone,
    required String? idNumber,
    required IconData icon,
    required Color iconColor,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.campDetails, arguments: {
          'campName': familyName,
          'tentId': tentId,
        });
      },
      child: Container(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2530),
          borderRadius: BorderRadius.circular(isTablet ? 14 : 12),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isTablet ? 16 : 12),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: isTablet ? 30 : 24,
                  ),
                ),
                SizedBox(width: isTablet ? 16 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: labelColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              label,
                              style: TextStyle(
                                color: labelColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            tentId,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 18 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (location != null) ...[
                            Text(
                              location,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '•',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            'عائلة: $familyName',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white.withOpacity(0.3),
                  size: 16,
                ),
              ],
            ),
            if (members != null && phone != null && idNumber != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F1419),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            color: Colors.white.withOpacity(0.6),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$members أفراد',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              phone!,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'رقم الجوال',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              idNumber!,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'هوية',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
