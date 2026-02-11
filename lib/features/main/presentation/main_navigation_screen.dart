import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartcamp_gazarecovery/features/dashboard/presentation/dashboard_screen.dart';
import 'package:smartcamp_gazarecovery/features/assistance/presentation/assistance.dart';
import 'package:smartcamp_gazarecovery/features/settings/presentation/settings_screen.dart';
import 'package:smartcamp_gazarecovery/features/tents/presentation/tents.dart';
import 'package:smartcamp_gazarecovery/features/dashboard/presentation/cubit/dashboard_cubit.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 3; // البدء من الصفحة الرئيسية

  // قائمة الصفحات - build dynamically so we can read DashboardCubit's cached dashboard
  List<Widget> get _pages {
    // read cached dashboard model from the cubit; may be null if not yet loaded
    final dash = context.watch<DashboardCubit>().currentDashboard;
    // obtain camp id (as string) with a safe fallback to '49' (previous hardcoded value)
    final campId = (dash != null && dash.data != null) ? dash.data!.id.toString() : '49';

    return [
      const SettingsScreen(), // حساب - تفاصيل العائلة
      // Provide a ValueKey that includes the campId so Flutter will recreate AssistanceScreen when the id changes
      AssistanceScreen(key: ValueKey('assistance_$campId'), campId: campId), // المساعدات - الفهرس 1
      const TentsScreen(), // الخيام - الفهرس 2
      const DashboardScreen(), // الرئيسية - الفهرس 3
    ];
  }

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
