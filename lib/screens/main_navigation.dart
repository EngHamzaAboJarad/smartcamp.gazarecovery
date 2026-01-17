import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'maine Pages/tents.dart';
import 'maine Pages/assistance.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 3; // البدء من الصفحة الرئيسية

  // قائمة الصفحات
  final List<Widget> _pages = [
    const AccountScreen(), // حساب - الفهرس 0
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

// صفحة الحساب (مؤقتة)
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1419),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1419),
        elevation: 0,
        title: const Text(
          'حساب',
          style: TextStyle(color: Colors.white70),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'صفحة الحساب',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
