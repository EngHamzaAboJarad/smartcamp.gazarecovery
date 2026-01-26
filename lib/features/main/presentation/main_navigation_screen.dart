import 'package:flutter/material.dart';
<<<<<<< HEAD:lib/screens/main_navigation.dart
import 'dashboard_screen.dart';
import 'family_details_screen.dart';
import 'maine Pages/tents.dart';
import 'maine Pages/assistance.dart';
=======
import 'package:smartcamp_gazarecovery/features/family/presentation/family.dart';
import 'package:smartcamp_gazarecovery/features/assistance/presentation/assistance.dart';
import 'package:smartcamp_gazarecovery/features/tents/presentation/tents.dart';
import 'package:smartcamp_gazarecovery/features/dashboard/presentation/dashboard.dart';
>>>>>>> 857d14292e877c31485ce8f2684aa6afd5cbd0fa:lib/features/main/presentation/main_navigation_screen.dart

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 3; // البدء من الصفحة الرئيسية

  // قائمة الصفحات
  final List<Widget> _pages = [
    const FamilyDetailsScreen(), // حساب - تفاصيل العائلة
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
<<<<<<< HEAD:lib/screens/main_navigation.dart
=======

>>>>>>> 857d14292e877c31485ce8f2684aa6afd5cbd0fa:lib/features/main/presentation/main_navigation_screen.dart
