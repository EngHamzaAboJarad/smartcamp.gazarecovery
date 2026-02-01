import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartcamp_gazarecovery/shared/constants.dart';
import 'package:smartcamp_gazarecovery/shared/utils/size_config.dart';
import 'package:smartcamp_gazarecovery/shared/widgets/custom_app_bar.dart';
import 'package:smartcamp_gazarecovery/shared/widgets/app_drawer.dart';

import '../presentation/cubit/dashboard_cubit.dart';
import '../presentation/cubit/dashboard_state.dart';
import '../../dashboard/data/models/dashboard_model.dart';

// Widget imports moved to separate files
import 'package:smartcamp_gazarecovery/features/dashboard/widgets/stat_card.dart';
import 'package:smartcamp_gazarecovery/features/dashboard/widgets/big_card.dart';
import 'package:smartcamp_gazarecovery/features/dashboard/widgets/info_box.dart';
import 'package:smartcamp_gazarecovery/features/dashboard/widgets/action_card.dart';
import 'package:smartcamp_gazarecovery/features/dashboard/widgets/status_box.dart';
import 'package:smartcamp_gazarecovery/features/dashboard/widgets/highlight_tile.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  // Design colors tuned to the screenshot
  static const Color _bg = Color(0xFF0B1216);
  static const Color _card = Color(0xFF111B20);

  Color _cardColor(BuildContext context) => _card;

  TextStyle _statLabelStyle(context) => TextStyle(
      fontSize: SizeConfig.sp(context, getNewNum(25)),
      color: Colors.white,
      fontFamily: fontFamilyInt);

  TextStyle _statValueStyle(context) => TextStyle(
      fontSize: SizeConfig.sp(context, getNewNum(42)),
      color: Colors.white,
      fontFamily: fontFamilyInt);

  TextStyle _bigLabelStyle() =>
      GoogleFonts.cairo(fontSize: 14, color: Colors.white70);

  TextStyle _bigValueStyle() => GoogleFonts.cairo(
      fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    final double fullWidth = MediaQuery.of(context).size.width - 32;
    final double cellWidth = (fullWidth - 12) / 2;
    const double targetCellHeight = 120.0;
    final double gridAspect = cellWidth / targetCellHeight;
    const double actionCardHeight = 100.0;
    final double actionAspect = cellWidth / actionCardHeight;
    return Scaffold(
      drawer: const AppDrawer(),
      backgroundColor: _bg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.sw(context, 16)),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: SizeConfig.sh(context, 120)),
            child: BlocProvider(
              create: (_) => DashboardCubit()..fetchDashboard(),
              child: BlocBuilder<DashboardCubit, DashboardState>(
                builder: (context, state) {
                  if (state is DashboardLoading) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height - 120,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (state is DashboardError) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height - 120,
                      child: Center(
                          child: Text(state.message,
                              style: const TextStyle(color: Colors.white))),
                    );
                  }

                  final DashboardData? object =
                      state is DashboardLoaded ? state.dashboard.data : null;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomAppBar(title: 'SmartCamp'),
                      SizedBox(height: SizeConfig.sh(context, getNewNum(25))),
                      Row(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  object?.campName.toString().split(' ')[0] ??
                                      'مخيم الست اميرة',
                                  style: GoogleFonts.inter(
                                      fontSize:
                                          SizeConfig.sp(context, getNewNum(45)),
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white)),
                              SizedBox(height: SizeConfig.sh(context, 6)),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined,
                                      size: 14, color: Colors.white54),
                                  SizedBox(width: SizeConfig.sw(context, 6)),
                                  Text(
                                    (object?.campLocation?.city ?? '') +
                                        ((object?.campLocation?.address !=
                                                    null &&
                                                (object?.campLocation
                                                            ?.address ??
                                                        '')
                                                    .isNotEmpty)
                                            ? ' / ${object!.campLocation!.address}'
                                            : ''),
                                    style: GoogleFonts.cairo(
                                        fontSize: 12, color: Colors.white54),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF155C44),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(object?.status ?? 'مكتمل',
                                style: GoogleFonts.cairo(
                                    color: Colors.white70, fontSize: 12)),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.sh(context, 30)),

                      GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: gridAspect,
                        children: [
                          StatCard(
                              label: 'عدد الأفراد',
                              value:
                                  (object?.numberOfIndividuals ?? 0).toString(),
                              icon: Icons.people,
                              iconBg: Colors.indigo),
                          StatCard(
                              label: 'عدد الخيام',
                              value: (object?.tentNumber ?? 0).toString(),
                              icon: Icons.home,
                              iconBg: Colors.blue),
                          StatCard(
                              label: 'عدد الأطفال',
                              value: (object?.childrenNumbers ?? 0).toString(),
                              icon: Icons.sentiment_satisfied,
                              iconBg: Colors.teal),
                          StatCard(
                              label: 'عدد العائلات',
                              value: (object?.familiesNumber ?? 0).toString(),
                              icon: Icons.family_restroom,
                              iconBg: Colors.purple),
                          StatCard(
                              label: 'عدد النساء',
                              value: (object?.femalesNumber ?? 0).toString(),
                              icon: Icons.female,
                              iconBg: Colors.pink),
                          StatCard(
                              label: 'عدد الذكور',
                              value: (object?.malesNumber ?? 0).toString(),
                              icon: Icons.male,
                              iconBg: Colors.lightBlue),
                        ],
                      ),

                      SizedBox(height: SizeConfig.sh(context, 12)),

                      BigCard(
                        label: 'عدد ذوي الهمم',
                        value: (object?.numberOfPeopleWithDisabilities ?? 0)
                            .toString(),
                        nameImage: 'image',
                      ),
                      SizedBox(height: SizeConfig.sh(context, 12)),
                      BigCard(
                          label: 'كبار السن',
                          value: object!.numberOldPeople.toString(),
                          nameImage: 'man_peg',
                          accent: Colors.green.shade500),
                      SizedBox(height: SizeConfig.sh(context, 12)),
                      Row(
                        children: [
                          Expanded(
                              child: BigCard(
                                  label: 'عدد الخيام المجاورة',
                                  value: (object?.numberOfAdjacentTents ?? 0).toString(),
                                  nameImage: 'image2')),
                          SizedBox(
                            width: SizeConfig.sw(context, 15),
                          ),
                          Expanded(
                              child: BigCard(
                                  label: 'عدد العائلات فالمباني',
                                  value: (object?.numberOfFamiliesInBuildings ?? 0)
                                      .toString(),
                                  nameImage: 'image3',
                                  accent: Colors.blue)),
                        ],
                      ),

                      SizedBox(height: SizeConfig.sh(context, 14)),

                      Row(
                        children: [
                          Expanded(
                              child: InfoBox(
                                  title: 'A فئة',
                                  subtitle: (object != null
                                      ? (object.classification['A'] ?? 0)
                                          .toString()
                                      : '0'),
                                  borderColor: Colors.green)),
                          SizedBox(width: SizeConfig.sw(context, 10)),
                          Expanded(
                              child: InfoBox(
                                  title: 'B فئة',
                                  subtitle: (object != null
                                      ? (object.classification['B'] ?? 0)
                                          .toString()
                                      : '0'),
                                  borderColor: Colors.orange)),
                          SizedBox(width: SizeConfig.sw(context, 10)),
                          Expanded(
                              child: InfoBox(
                                  title: 'C فئة',
                                  subtitle: (object != null
                                      ? (object.classification['C'] ?? 0)
                                          .toString()
                                      : '0'),
                                  borderColor: Colors.red)),
                        ],
                      ),
                      SizedBox(height: SizeConfig.sh(context, 18)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'تصنيف العائلات',
                            style: TextStyle(
                                fontFamily: fontFamilyInt,
                                fontSize: SizeConfig.sp(context, 22)),
                          ),
                          SizedBox(width: SizeConfig.sh(context, 18)),
                          Image.asset(
                            'images/classification.png',
                            width: SizeConfig.sw(context, getNewNum(35)),
                            height: SizeConfig.sh(context, getNewNum(35)),
                          )
                        ],
                      ),
                      GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: actionAspect,
                        children: [
                          ActionCard(
                              title: 'الإبلاغ عن احتياج',
                              icon: Icons.notifications_active,
                              color: Colors.blueAccent),
                          ActionCard(
                              title: 'تحديث البيانات',
                              icon: Icons.edit,
                              color: Colors.teal),
                          ActionCard(
                              title: 'الدعم الفني',
                              icon: Icons.support_agent,
                              color: Colors.amber),
                          ActionCard(
                              title: 'الخيام في المخيم',
                              icon: Icons.home_work,
                              color: Colors.indigo),
                        ],
                      ),

                      SizedBox(height: SizeConfig.sh(context, 18)),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'البنية التحتية للمخيم',
                          style: TextStyle(
                              fontFamily: fontFamilyInt,
                              fontSize: SizeConfig.sp(context, 22)),
                        ),
                      ),
                      SizedBox(height: SizeConfig.sh(context, 8)),
                      // Infrastructure row
                      Row(
                        children: [
                          Expanded(
                              child: StatusBox(
                                  imageName: 'image.png',
                                  title: 'مياه للاستخدام',
                                  status: object!.water!.available == false
                                      ? 'لا تتوفر'
                                      : 'متوفرة',
                                  color: Colors.blue)),
                          SizedBox(width: SizeConfig.sw(context, 12)),
                          Expanded(
                              child: StatusBox(
                                  imageName: 'image.png',
                                  title: 'مياه الشرب',
                                  status:
                                      object!.waterForDrinks!.available == false
                                          ? 'لا تتوفر'
                                          : 'متوفرة',
                                  color: Colors.red)),
                          SizedBox(width: SizeConfig.sw(context, 12)),
                          Expanded(
                              child: StatusBox(
                                  imageName: 'image2.png',
                                  title: 'الحمامات',
                                  status: object?.bathrooms != 0
                                      ? 'متوفر(${object?.bathrooms ?? 0})'
                                      : 'لا تتوفر',
                                  color: Colors.green)),
                        ],
                      ),
                      SizedBox(height: SizeConfig.sh(context, getNewNum(30))),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Text(
                              'عرض الكل',
                              style: TextStyle(
                                  fontFamily: fontFamilyInt,
                                  color: Colors.blue,
                                  fontSize: SizeConfig.sp(context, 15)),
                            ),
                          ),
                          Spacer(),
                          Text(
                            'أبرز الاحتياجات',
                            style: TextStyle(
                                fontFamily: fontFamilyInt,
                                fontSize: SizeConfig.sp(context, 22)),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.sh(context, getNewNum(28))),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (int i = 0; i < object!.needs.length; i++)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: HighlightTile(
                                  title: object.needs[i].details,
                                  subtitle: 'تم الإبلاغ منذ ساعتين',
                                  tagColor: Colors.redAccent,
                                  tagLabel: object.needs[i].status,
                                  imageName:
                                      'images/icons/icon_need/image${i}.png'),
                            ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
