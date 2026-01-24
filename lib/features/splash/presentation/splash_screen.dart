import 'package:flutter/material.dart';
import 'package:smartcamp_gazarecovery/shared/constants.dart';
import 'package:smartcamp_gazarecovery/shared/utils/size_config.dart';
import 'package:smartcamp_gazarecovery/core/routes.dart';
import 'package:smartcamp_gazarecovery/core/prefs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      // After splash, check persisted login flag and navigate accordingly
      final logged = await Prefs.isLoggedIn();
      if (logged) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.MainNavigationScreen);
      } else {
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageNames.logo,
              width: SizeConfig.sw(context, getNewNum(282)),
              height: SizeConfig.sh(context, getNewNum(217)),
            ),
            Text(
              appName,
              style: TextStyle(
                fontFamily: fontFamilyIsland,
                fontSize: SizeConfig.sh(context, getNewNum(100)),
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
