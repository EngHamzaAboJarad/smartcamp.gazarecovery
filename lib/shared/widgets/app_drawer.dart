import 'package:flutter/material.dart';
import 'package:smartcamp_gazarecovery/shared/utils/size_config.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(radius: SizeConfig.sw(context, 28), backgroundColor: Colors.grey),
                  SizedBox(height: SizeConfig.sh(context, 8)),
                  Text('المستخدم', style: TextStyle(fontSize: SizeConfig.sp(context, 16))),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('الرئيسية'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('العائلات'),
              onTap: () => Navigator.pop(context),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.all(SizeConfig.sw(context, 12)),
              child: Text('نسخة تجريبية', style: TextStyle(color: Colors.grey)),
            )
          ],
        ),
      ),
    );
  }
}

