import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartcamp_gazarecovery/shared/constants.dart';
import 'package:smartcamp_gazarecovery/shared/utils/size_config.dart';
import 'package:smartcamp_gazarecovery/shared/widgets/top_floating_message.dart';
import 'package:smartcamp_gazarecovery/core/routes.dart';
import 'package:smartcamp_gazarecovery/features/otp/presentation/cubit/otp_cubit.dart';
import 'package:smartcamp_gazarecovery/features/otp/presentation/cubit/otp_state.dart';

class OtpScreen extends StatefulWidget {
  final int codeLength;
  // credential (phone or id) passed from previous screen
  final String? credential;

  // onConfirmed should return true when the provided code is valid
  final Future<bool> Function(String code)? onConfirmed;

  // Default to 6 digits as requested
  const OtpScreen({Key? key, this.credential, this.codeLength = 6, this.onConfirmed})
      : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late List<String> _digits;
  late int _remainingSeconds;
  Timer? _timer;
  int _activeIndex = 0; // current focused box

  @override
  void initState() {
    super.initState();
    _digits = List.generate(widget.codeLength, (_) => '');
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer({int seconds = 60}) {
    _timer?.cancel();
    setState(() => _remainingSeconds = seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds <= 0) {
        t.cancel();
        setState(() {});
        return;
      }
      setState(() => _remainingSeconds -= 1);
    });
  }

  String get _enteredCode => _digits.join();

  void _onKeyTap(String value) {
    if (value == 'del') {
      // delete last filled digit and move active index back to that position
      int lastFilled = -1;
      for (int i = widget.codeLength - 1; i >= 0; i--) {
        if (_digits[i].isNotEmpty) {
          lastFilled = i;
          break;
        }
      }
      if (lastFilled >= 0) {
        setState(() {
          _digits[lastFilled] = '';
          _activeIndex = lastFilled;
        });
      } else {
        // nothing to delete, keep at first box
        setState(() => _activeIndex = 0);
      }
      return;
    }

    // insert at first empty slot (or at active index if empty)
    int insertIndex = -1;
    // Prefer active index if it's empty
    if (_activeIndex >= 0 &&
        _activeIndex < widget.codeLength &&
        _digits[_activeIndex].isEmpty) {
      insertIndex = _activeIndex;
    } else {
      for (int i = 0; i < widget.codeLength; i++) {
        if (_digits[i].isEmpty) {
          insertIndex = i;
          break;
        }
      }
    }
    if (insertIndex != -1) {
      setState(() {
        _digits[insertIndex] = value;
        // move active index to next position (or stay at last)
        if (insertIndex + 1 < widget.codeLength)
          _activeIndex = insertIndex + 1;
        else
          _activeIndex = widget.codeLength - 1;
      });
    }
  }

  void _onClearAll() {
    setState(() {
      _digits = List.generate(widget.codeLength, (_) => '');
      _activeIndex = 0;
    });
  }

  void _onResend() {
    // Delegate resend to cubit; cubit will emit a success state that restarts the timer.
    if (widget.credential == null || widget.credential!.isEmpty) {
      showTopFloatingMessage(context, 'الرجاء العودة وإدخال رقم الجوال', isError: true);
      return;
    }
    // clear UI immediately and call cubit
    _onClearAll();
    context.read<OtpCubit>().resendOtp(widget.credential!);
  }

  void _onConfirm() async {
    final code = _enteredCode;
    if (code.length == widget.codeLength) {
      // If a custom validator is provided, call it first (keeps existing extensibility)
      if (widget.onConfirmed != null) {
        try {
          final valid = await widget.onConfirmed!(code);
          if (valid) {
            showTopFloatingMessage(context, 'تم التحقق بنجاح', isError: false);
            Navigator.of(context).pushReplacementNamed(AppRoutes.MainNavigationScreen);
            return;
          } else {
            showTopFloatingMessage(context, 'رمز التحقق غير صحيح', isError: true);
            _onClearAll();
            return;
          }
        } catch (e) {
          showTopFloatingMessage(context, 'حدث خطأ في التحقق', isError: true);
          return;
        }
      }

      // Delegate verification to cubit
      if (widget.credential == null || widget.credential!.isEmpty) {
        showTopFloatingMessage(context, 'الرجاء العودة وإدخال رقم الجوال', isError: true);
        return;
      }
      context.read<OtpCubit>().verifyOtp(widget.credential!, code);
    } else {
      // Could show a validation message; for now show top message
      showTopFloatingMessage(context, 'الرجاء إدخال كامل رمز التحقق',
          isError: true);
    }
  }

  String _formatTimer(int seconds) {
    final min = (seconds ~/ 60).toString().padLeft(2, '0');
    final sec = (seconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  @override
  Widget build(BuildContext context) {
    // screen width used throughout the layout
    final screenW = MediaQuery.of(context).size.width;
     // Place a BlocListener here so the screen reacts to cubit states (loading, success, resend, error)
     return BlocListener<OtpCubit, OtpState>(
      listener: (context, state) {
        if (state is OtpLoading) {
          // show loading dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else {
          // close loading if open
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }
        }

        if (state is OtpSuccess) {
          showTopFloatingMessage(context, state.data!['message'], isError: false);
          Navigator.of(context).pushReplacementNamed(AppRoutes.MainNavigationScreen);
        } else if (state is OtpResendSuccess) {
          showTopFloatingMessage(context, 'تم إرسال رمز جديد', isError: false);
          _startTimer();
        } else if (state is OtpError) {
          showTopFloatingMessage(context, state.message, isError: true);
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                 // Header: back icon and spacing
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_forward,
                              color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            'أدخل رمز التحقق الذي تم إرساله إلى رقم هاتفك',
                             style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                               fontFamily: fontFamilyInt
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'أدخل رمز التحقق المرسل لك. يمكنك طلب إعادة الإرسال بعد انتهاء المؤقت.',
                             style: TextStyle(color: Colors.white,fontFamily: fontFamilyInt, fontSize: 13),
                          ),

                          const SizedBox(height: 18),

                          // Code input boxes (big)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(widget.codeLength, (index) {
                              final val = _digits[index];
                              final bool isActive = index == _activeIndex;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _activeIndex = index;
                                    });
                                  },
                                  child: Container(
                                    margin:
                                        const EdgeInsets.symmetric(horizontal: 6),
                                    width: screenW * 0.12,
                                    height: screenW * 0.12,
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? Colors.white
                                          : const Color(0xFFFCECEC),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: isActive
                                              ? primaryColor
                                              : Colors.grey.shade300,
                                          width: isActive ? 2 : 1),
                                      boxShadow: isActive
                                          ? [
                                              BoxShadow(
                                                  color: Color.fromRGBO(
                                                      33, 150, 243, 0.12),
                                                  blurRadius: 6,
                                                  offset: Offset(0, 2))
                                            ]
                                          : null,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      val.isNotEmpty ? val : '',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),

                          const SizedBox(height: 22),

                          // Confirm button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _enteredCode.length == widget.codeLength
                                  ? _onConfirm
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    _enteredCode.length == widget.codeLength
                                        ? primaryColor
                                        : Colors.grey.shade400,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text('تأكيد',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),

                          const SizedBox(height: 25),

                          // Rich text where only "عدل الآن" is clickable
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(color: Colors.white, fontFamily: fontFamilyInt),
                              children: [
                                const TextSpan(text: 'رقم الجوال غير صحيح؟ '),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: GestureDetector(
                                    onTap: () => Navigator.of(context).maybePop(),
                                    child:   Text('عدل الآن',
                                        style: TextStyle(color: Colors.redAccent,fontSize: SizeConfig.sp(context,20))),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Countdown timer + resend button
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Timer text
                                Text(
                                  _remainingSeconds > 0
                                      ? 'إعادة الإرسال خلال ${_formatTimer(_remainingSeconds)}'
                                      : 'لم يعد الموقت مفعلًا',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: fontFamilyInt,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Resend button (enabled only when timer is 0)
                                TextButton(
                                  onPressed: _remainingSeconds <= 0 ? _onResend : null,
                                  child: Text(
                                    'إعادة الإرسال',
                                    style: TextStyle(
                                      color: _remainingSeconds <= 0
                                          ? Colors.white
                                          : Colors.white54,
                                      fontFamily: fontFamilyInt,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 6),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Spacer to push keypad down
                        ],
                      ),
                    ),
                  ),
                ),

                // Custom numeric keypad
                Container(
                  color: Colors.transparent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildKeyRow(['1', '2', '3'], screenW),
                      const SizedBox(height: 8),
                      _buildKeyRow(['4', '5', '6'], screenW),
                      const SizedBox(height: 8),
                      _buildKeyRow(['7', '8', '9'], screenW),
                      const SizedBox(height: 8),
                      _buildKeyRow(['*', '0', 'del'], screenW),
                      const SizedBox(height: 8),
                      SizedBox(height: 8),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )
     );
  }

  Widget _buildKeyRow(List<String> keys, double screenW) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((k) {
        final isDel = k == 'del';
        final computedWidth = (screenW - 48) / 3; // spacing + paddings
        final keyWidth = computedWidth > 92
            ? 92.0
            : (computedWidth < 60 ? 60.0 : computedWidth);
        return SizedBox(
          width: keyWidth,
          height: 56,
          child: ElevatedButton(
            onPressed: () => _onKeyTap(isDel
                ? 'del'
                : k == '*'
                    ? ''
                    : k),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: isDel
                ? const Icon(Icons.backspace_outlined)
                : Text(k,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600)),
          ),
        );
      }).toList(),
    );
  }
}
