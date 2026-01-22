import 'package:flutter/material.dart';
import 'package:smartcamp_gazarecovery/shared/utils/size_config.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({Key? key, this.title = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.sw(context, 8), vertical: SizeConfig.sh(context, 8)),
        child: Container(
          height: SizeConfig.sh(context, 70),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(SizeConfig.sw(context, 12)),
          ),
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.sw(context, 8)),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  final scaffold = Scaffold.maybeOf(context);
                  if (scaffold != null && scaffold.hasDrawer) scaffold.openDrawer();
                },
                icon: Icon(Icons.menu, color: Colors.white70, size: SizeConfig.sp(context, 20)),
              ),
              const Spacer(),
              Text(title, style: TextStyle(color: Colors.white, fontSize: SizeConfig.sp(context, 18))),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_outlined, color: Colors.white70, size: SizeConfig.sp(context, 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

