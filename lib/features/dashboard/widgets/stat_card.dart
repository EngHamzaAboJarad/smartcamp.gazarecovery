import 'package:flutter/material.dart';
import 'package:smartcamp_gazarecovery/shared/constants.dart';
import 'package:smartcamp_gazarecovery/shared/utils/size_config.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? iconBg;

  const StatCard({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
    this.iconBg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color bg = const Color(0xFF111B20);
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.sw(context, 14),
          vertical: SizeConfig.sh(context, 12)),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withAlpha((0.02 * 255).round())),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // label and value (on the right because of RTL)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: SizeConfig.sp(context, getNewNum(25)),
                      color: Colors.white,
                      fontFamily: fontFamilyInt)),
              SizedBox(height: SizeConfig.sh(context, 6)),
              Text(value,
                  style: TextStyle(
                      fontSize: SizeConfig.sp(context, getNewNum(42)),
                      color: Colors.white,
                      fontFamily: fontFamilyInt)),
            ],
          ),
          // icon box
          Container(
            width: SizeConfig.sw(context, 46),
            height: SizeConfig.sw(context, 46),
            decoration: BoxDecoration(
              color: iconBg ?? Colors.blueGrey.shade700,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withAlpha((0.35 * 255).round()),
                    blurRadius: 4,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Icon(icon, color: Colors.white),
          )
        ],
      ),
    );
  }
}

