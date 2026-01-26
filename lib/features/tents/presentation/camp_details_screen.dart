import 'package:flutter/material.dart';
import 'package:smartcamp_gazarecovery/shared/utils/size_config.dart';

class CampDetailsScreen extends StatelessWidget {
  final String campName;
  final String tentId;

  const CampDetailsScreen({Key? key, required this.campName, required this.tentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الخيمة'),
      ),
      body: Padding(
        padding: EdgeInsets.all(SizeConfig.sw(context, 16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('اسم العائلة: $campName', style: TextStyle(fontSize: SizeConfig.sp(context, 18))),
            SizedBox(height: SizeConfig.sh(context, 12)),
            Text('رقم الخيمة: $tentId', style: TextStyle(fontSize: SizeConfig.sp(context, 16))),
          ],
        ),
      ),
    );
  }
}

