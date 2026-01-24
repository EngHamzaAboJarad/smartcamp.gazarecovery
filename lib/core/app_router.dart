import 'package:flutter/material.dart';
import 'package:smartcamp_gazarecovery/core/routes.dart';
import 'package:smartcamp_gazarecovery/features/main/presentation/main_navigation_screen.dart';
import '../features/splash/presentation/splash_screen.dart';
import '../features/login/login_screen.dart';
import '../features/home/home_screen.dart';
import '../features/details/details_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import './not_found_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.dashboard:
        // dashboard may receive a DataUserModel via route arguments
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
        case AppRoutes.MainNavigationScreen:
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen());
      case AppRoutes.details:
        if (args is DetailsArgs) {
          return MaterialPageRoute(
              builder: (_) => DetailsScreen(args: args));
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) => const NotFoundPage());
  }
}
