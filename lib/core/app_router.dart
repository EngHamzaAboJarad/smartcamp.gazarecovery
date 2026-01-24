import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartcamp_gazarecovery/core/routes.dart';
import 'package:smartcamp_gazarecovery/features/main/presentation/cubit/main_cubit.dart';
import 'package:smartcamp_gazarecovery/features/main/presentation/main_navigation_screen.dart';
import 'package:smartcamp_gazarecovery/features/otp/presentation/cubit/otp_cubit.dart';
import 'package:smartcamp_gazarecovery/features/otp/presentation/otp_screen.dart';
import 'package:smartcamp_gazarecovery/features/settings/presentation/settings_screen.dart';
import '../features/family/presentation/add_family_screen.dart';
import '../features/splash/presentation/splash_screen.dart';
import '../features/login/presentation/login_screen.dart';
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
      case AppRoutes.OtpScreen:
        // If a credential (phone or id) was provided via Navigator.arguments, forward it to OtpScreen
        final String? credentialArg = args is String ? args as String : null;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => OtpCubit(),
            child: OtpScreen(credential: credentialArg),
          ),
        );
      case AppRoutes.dashboard:
        // dashboard may receive a DataUserModel via route arguments
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      case AppRoutes.AddFamilyScreen:
        // dashboard may receive a DataUserModel via route arguments
        return MaterialPageRoute(builder: (_) => AddFamilyScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case AppRoutes.SettingsScreen:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case AppRoutes.MainNavigationScreen: //MainNavigationScreen(
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(providers: [
                  BlocProvider<OtpCubit>(
                    create: (BuildContext context) => OtpCubit(),
                  ),
                  BlocProvider<MainCubit>(
                    create: (BuildContext context) => MainCubit(),
                  ),
                ], child: MainNavigationScreen()));
      case AppRoutes.details:
        if (args is DetailsArgs) {
          return MaterialPageRoute(builder: (_) => DetailsScreen(args: args));
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
