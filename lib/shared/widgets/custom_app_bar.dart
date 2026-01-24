import 'package:flutter/material.dart';
import 'package:smartcamp_gazarecovery/shared/constants.dart';
import 'package:smartcamp_gazarecovery/shared/utils/size_config.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppBar({Key? key, this.title = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.sw(context, 8), vertical: SizeConfig.sh(context, 8)),
        child: Row(
          children: [
            CircleAvatar(
              radius: SizeConfig.sw(context, 20),
              backgroundImage: const AssetImage('images/family_details_screen_images/c8b989ac7a3b73d42306d4d352507ce74231e5fc.png'),
            ),
            const Spacer(),
            Text(title, style: TextStyle(color: Colors.white, fontSize: SizeConfig.sp(context, 18))),
            const Spacer(),
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: Colors.white70,
                    size: SizeConfig.sp(context, getNewNum(40)),
                  ),
                ),

                // دائرة التنبيه الحمراء
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

