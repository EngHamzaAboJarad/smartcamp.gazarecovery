import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartcamp_gazarecovery/core/routes.dart';
import 'package:smartcamp_gazarecovery/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:smartcamp_gazarecovery/features/auth/presentation/cubit/auth_state.dart';
import 'package:smartcamp_gazarecovery/features/login/presentation/cubit/login_cubit.dart';
import 'package:smartcamp_gazarecovery/features/login/presentation/cubit/login_state.dart';
import 'package:flutter/foundation.dart';
import 'package:smartcamp_gazarecovery/shared/constants.dart';
import 'package:smartcamp_gazarecovery/shared/utils/size_config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Debug FAB to quickly test the login endpoint with the sample payload
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              // Optionally show a loading indicator via a dialog/snackbar
            } else if (state is AuthSuccess) {
              // Navigate to home on success
              Navigator.of(context).pushReplacementNamed(AppRoutes.MainNavigationScreen);
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(child: CircularProgressIndicator()),
                );
              } else if (state is LoginSuccess) {
                // close loading dialog if open
                if (Navigator.of(context, rootNavigator: true).canPop()) {
                  Navigator.of(context, rootNavigator: true).pop();
                }
                // Navigate to dashboard on login success and pass the parsed user data
                Navigator.of(context).pushReplacementNamed(
                  AppRoutes.dashboard,
                  arguments: state.userData,
                );
              } else if (state is LoginError) {
                if (Navigator.of(context, rootNavigator: true).canPop()) {
                  Navigator.of(context, rootNavigator: true).pop();
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.sh(context, getNewNum(42)),
                    vertical: SizeConfig.sh(context, getNewNum(181))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    SizedBox(
                      height: SizeConfig.sh(context, getNewNum(36)),
                    ),
                    Text(
                      'أهلأ بك ، مدير المخيم',
                      style: TextStyle(
                        fontFamily: fontFamilyInt,
                        fontSize: SizeConfig.sh(context, getNewNum(54)),
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.sh(context, getNewNum(9)),
                    ),
                    Text(
                      'سجل دخولك لمتابعة احتياجات المخيم',
                      style: TextStyle(
                        fontFamily: fontFamilyInt,
                        fontSize: SizeConfig.sh(context, getNewNum(28)),
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.sh(context, getNewNum(50)),
                    ),
                    // Styled RTL input that matches the screenshot: label on the right,
                    // rounded filled background, hint mask and phone icon.
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'رقم الهوية',
                        style: TextStyle(
                          fontFamily: fontFamilyInt,
                          fontSize: SizeConfig.sh(context, getNewNum(25)),
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.sh(context, getNewNum(8))),
                    TextField(
                      controller: context.read<LoginCubit>().userController,
                      keyboardType: TextInputType.phone,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'XXX-XXXX-XXX',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        filled: true,
                        fillColor: const Color(0xFF0F1720),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: SizeConfig.sh(context, getNewNum(16)),
                          horizontal: SizeConfig.sw(context, getNewNum(12)),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        // The icon shown inside the field. In RTL this will appear on the left automatically,
                        // but text is aligned to the right like in the screenshot.
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(
                              right: SizeConfig.sw(context, getNewNum(10))),
                          child: Icon(
                            Icons.perm_contact_cal_sharp,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.sh(context, getNewNum(24)),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'كلمة المرور',
                        style: TextStyle(
                          fontFamily: fontFamilyInt,
                          fontSize: SizeConfig.sh(context, getNewNum(25)),
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.sh(context, getNewNum(8))),
                    TextField(
                      controller: context.read<LoginCubit>().passController,
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: '********',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        filled: true,
                        fillColor: const Color(0xFF0F1720),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: SizeConfig.sh(context, getNewNum(16)),
                          horizontal: SizeConfig.sw(context, getNewNum(12)),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        // The icon shown inside the field. In RTL this will appear on the left automatically,
                        // but text is aligned to the right like in the screenshot.
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(
                              right: SizeConfig.sw(context, getNewNum(10))),
                          child: Icon(
                            Icons.lock,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.sh(context, getNewNum(100))),
                    ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: WidgetStateProperty.all<Size>(
                          Size(SizeConfig.sw(context, getNewNum(620)),
                              SizeConfig.sw(context, getNewNum(102))),
                        ),
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.blue),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                        ),
                      ),
                      onPressed: () {
                        final cubit = context.read<LoginCubit>();
                        cubit.userController.text = '+972567077653'; // ID-10001 sample
                        cubit.passController.text = 'password';
                        cubit.submitLogin();
                       },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 25,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'تسجيل دخول',
                            style: TextStyle(
                              fontFamily: fontFamilyInt,
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.sh(context, getNewNum(75)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'هل تواجه مشكلة في الدخول',
                          style: TextStyle(
                            fontFamily: fontFamilyInt,
                            fontSize: SizeConfig.sh(context, getNewNum(26)),
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.question_mark,
                          color: Colors.grey.shade600,
                          size: 30,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
