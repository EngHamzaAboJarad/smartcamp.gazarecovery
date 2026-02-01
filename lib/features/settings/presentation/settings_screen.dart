import 'package:flutter/material.dart';

import 'widgets/profile_section.dart';
import 'widgets/settings_row.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static const _darkCard = Color(0xFF0F1720);
  static const _red = Color(0xFFB84A4A);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text('الإعدادات'),

        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0A0F12), Color(0xFF071014)],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ProfileSection(),
                  const SizedBox(height: 18),

                  // ACCOUNT
                  // _buildSectionTitle('الحساب'),
                  // const SizedBox(height: 10),
                  //
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: const Color(0x990F1720),
                  //     borderRadius: BorderRadius.circular(14),
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       SettingsRow(
                  //         icon: Icons.lock_outline,
                  //         title: 'تغيير كلمة المرور',
                  //         onTap: () {},
                  //       ),
                  //       const Divider(height: 0, thickness: 0.5, color: Colors.white12),
                  //       SettingsRow(
                  //         icon: Icons.shield_outlined,
                  //         title: 'إعدادات الخصوصية',
                  //         onTap: () {},
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  //
                  // const SizedBox(height: 20),

                  // PREFERENCES
                  _buildSectionTitle('التفضيلات'),
                  const SizedBox(height: 10),

                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0x990F1720),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        // SettingsRow(
                        //   icon: Icons.notifications_outlined,
                        //   title: 'الإشعارات',
                        //   trailingSwitch: true,
                        //   switchValue: true,
                        //   onSwitchChanged: (v) {},
                        // ),
                        // const Divider(height: 0, thickness: 0.5, color: Colors.white12),
                        SettingsRow(
                          icon: Icons.language,
                          title: 'اللغة',
                          subtitle: 'العربية',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ABOUT
                  _buildSectionTitle('حول التطبيق'),
                  const SizedBox(height: 10),

                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0x990F1720),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        SettingsRow(
                          icon: Icons.info_outline,
                          title: 'عن المنصة',
                          onTap: () {},
                        ),
                        const Divider(height: 0, thickness: 0.5, color: Colors.white12),
                        SettingsRow(
                          icon: Icons.description_outlined,
                          title: 'الشروط والأحكام',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Logout button
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {},
                      child: const Text(
                        'تسجيل الخروج',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Center(
                    child: Text(
                      'الإصدار 1.0.0',
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600),
        ),
      );
}
