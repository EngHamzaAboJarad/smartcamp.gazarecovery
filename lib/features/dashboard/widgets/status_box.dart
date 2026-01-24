import 'package:flutter/material.dart';
import 'package:smartcamp_gazarecovery/shared/utils/size_config.dart';

class StatusBox extends StatelessWidget {
  final String imageName;
  final String title;
  final String status;
  final Color color;

  const StatusBox({
    Key? key,
    required this.imageName,
    required this.title,
    required this.status,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.sw(context, 12)),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withAlpha((0.04 * 255).round()),
        border: Border.all(color: color.withAlpha((0.9 * 255).round())),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('images/icons/$imageName',
              height: SizeConfig.sh(context, 70), width: SizeConfig.sw(context, 70)),
          SizedBox(height: SizeConfig.sh(context, 8)),
          Text(title, style: const TextStyle(color: Colors.white70)),
          SizedBox(height: SizeConfig.sh(context, 3)),
          Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

