import 'package:flutter/material.dart';
import 'package:smartcamp_gazarecovery/shared/constants.dart';
import 'package:smartcamp_gazarecovery/shared/utils/size_config.dart';

class InfoBox extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color borderColor;

  const InfoBox({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.sw(context, 12)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor.withAlpha((0.9 * 255).round())),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(
             fontFamily: fontFamilyInt,
              fontWeight: FontWeight.w600,
              color: Colors.white70, fontSize: 22)),
          SizedBox(height: SizeConfig.sh(context, 8)),
          Text(subtitle, style: const  TextStyle(
              fontFamily: fontFamilyInt,
              fontWeight: FontWeight.w600,
              color: Colors.white70, fontSize: 30)),
        ],
      ),
    );
  }
}

