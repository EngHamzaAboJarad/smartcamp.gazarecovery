import 'package:flutter/material.dart';
import 'package:smartcamp_gazarecovery/shared/utils/size_config.dart';
import 'package:smartcamp_gazarecovery/shared/constants.dart';

class HighlightTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color tagColor;
  final String tagLabel;
  final String imageName;

  const HighlightTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.tagColor,
    required this.tagLabel,
    required this.imageName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.sw(context, 12)),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.white),
        color: const Color(0xff1B2530),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(
            imageName,
            width: SizeConfig.sw(context, getNewNum(88)),
            height: SizeConfig.sh(context, getNewNum(88)),
          ),
          SizedBox(width: SizeConfig.sw(context, 10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: SizeConfig.sp(context, getNewNum(35)),
                        fontFamily: fontFamilyInt,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: SizeConfig.sh(context, 6)),
                Text(
                  subtitle,
                  style: TextStyle(
                      fontSize: SizeConfig.sp(context, getNewNum(25)),
                      fontFamily: fontFamilyInt,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.sw(context, 10),
                vertical: SizeConfig.sh(context, 6)),
            decoration: BoxDecoration(
              color: tagColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(tagLabel,
                style: const TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

