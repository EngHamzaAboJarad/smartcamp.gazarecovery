import 'package:flutter/material.dart';
import 'package:smartcamp_gazarecovery/shared/utils/size_config.dart';

class ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const ActionCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.sw(context, 14)),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1),
        color: const Color(0xFF2A3647),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: SizeConfig.sw(context, 46),
            height: SizeConfig.sw(context, 46),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          Expanded(
              child: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}

