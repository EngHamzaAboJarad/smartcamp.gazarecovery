import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartcamp_gazarecovery/core/routes.dart';
import 'package:smartcamp_gazarecovery/core/app_router.dart';
import 'package:smartcamp_gazarecovery/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:smartcamp_gazarecovery/features/home/presentation/cubit/home_cubit.dart';
import 'package:smartcamp_gazarecovery/features/assistance/presentation/cubit/assistance_cubit.dart';
import 'package:smartcamp_gazarecovery/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:smartcamp_gazarecovery/features/details/presentation/cubit/details_cubit.dart';
import 'package:smartcamp_gazarecovery/features/family/presentation/cubit/family_cubit.dart';
import 'package:smartcamp_gazarecovery/features/login/presentation/cubit/login_cubit.dart';
import 'package:smartcamp_gazarecovery/features/main/presentation/cubit/main_cubit.dart';
import 'package:smartcamp_gazarecovery/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:smartcamp_gazarecovery/features/tents/presentation/cubit/tents_cubit.dart';
import 'package:smartcamp_gazarecovery/core/dio_helper.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Dio (restore token and configure interceptors)
  await DioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => HomeCubit()),
        BlocProvider(create: (_) => AssistanceCubit()),
        BlocProvider(create: (_) => DashboardCubit()),
        BlocProvider(create: (_) => DetailsCubit()),
        BlocProvider(create: (_) => FamilyCubit()),
        BlocProvider(create: (_) => LoginCubit()),
        BlocProvider(create: (_) => MainCubit()),
        BlocProvider(create: (_) => SplashCubit()),
        BlocProvider(create: (_) => TentsCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, brightness: Brightness.dark),
          scaffoldBackgroundColor: const Color(0xFF0B1216),
          cardColor: const Color(0xFF0F1A1F),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF0B0F13),
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.white54,
            type: BottomNavigationBarType.fixed,
          ),
        ),
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
