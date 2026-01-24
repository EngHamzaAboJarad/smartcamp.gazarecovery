import 'package:flutter/material.dart';
import 'package:smartcamp_gazarecovery/features/dashboard/presentation/dashboard_screen.dart';
import 'package:smartcamp_gazarecovery/features/family/presentation/family.dart';
import 'package:smartcamp_gazarecovery/features/assistance/presentation/assistance.dart';
import 'package:smartcamp_gazarecovery/features/settings/presentation/settings_screen.dart';
import 'package:smartcamp_gazarecovery/features/tents/presentation/tents.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 3; // البدء من الصفحة الرئيسية

  // قائمة الصفحات
  final List<Widget> _pages = [
    const SettingsScreen(), // حساب - تفاصيل العائلة
    const AssistanceScreen(), // المساعدات - الفهرس 1
    const TentsScreen(), // الخيام - الفهرس 2
    const DashboardScreen(), // الرئيسية - الفهرس 3
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0B0F13),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.white54,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'حساب',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'المساعدات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الخيام',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'الرئيسية',
          ),
        ],
      ),
    );
  }
}

