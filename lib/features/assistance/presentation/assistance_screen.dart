import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartcamp_gazarecovery/features/assistance/presentation/cubit/assistance_cubit.dart';
import 'package:smartcamp_gazarecovery/features/assistance/presentation/cubit/assistance_state.dart';
import 'package:smartcamp_gazarecovery/features/donations/presentation/screens/donations_screen.dart';
import 'package:smartcamp_gazarecovery/shared/utils/size_config.dart';

class AssistanceScreen extends StatefulWidget {
  final String campId;

  const AssistanceScreen({Key? key, required this.campId}) : super(key: key);

  @override
  State<AssistanceScreen> createState() => _AssistanceScreenState();
}

class _AssistanceScreenState extends State<AssistanceScreen> {
  static const Color _bg = Color(0xFF0B1216);
  static const Color _card = Color(0xFF111B20);
  static const Color _accent = Color(0xFF2196F3);

  @override
  void initState() {
    super.initState();
    // تحميل البيانات عند فتح الشاشة
    context.read<AssistanceCubit>().loadAssistance(widget.campId);
  }

  TextStyle _titleStyle() => GoogleFonts.cairo(
      fontSize: SizeConfig.sp(context, 18),
      fontWeight: FontWeight.w700,
      color: Colors.white);

  TextStyle _sectionTitleStyle() => GoogleFonts.cairo(
      fontSize: SizeConfig.sp(context, 16),
      fontWeight: FontWeight.w600,
      color: Colors.white);

  TextStyle _unitStyle() => GoogleFonts.cairo(
      fontSize: SizeConfig.sp(context, 11), color: Colors.white54);

  @override
  Widget build(BuildContext context) {
    // compute dynamic bottom padding so the list isn't covered by the floating bar
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;
    final double floatingBarHeight = 56 + SizeConfig.sh(context, 18) * 2; // button + vertical paddings
    final double listBottomPadding = bottomInset + floatingBarHeight + SizeConfig.sh(context, 12);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _bg,
        appBar: AppBar(
          backgroundColor: _bg,
          elevation: 0,
          title: Text(
            'سجل التوزيعات',
            style: GoogleFonts.cairo(
              fontSize: SizeConfig.sp(context, 16),
              color: Colors.white70,
            ),
          ),
        ),
        body: Stack(
          children: [
            // Fixed header + scrollable list
            Padding(
              padding: EdgeInsets.fromLTRB(
                SizeConfig.sw(context, 16),
                SizeConfig.sh(context, 16),
                SizeConfig.sw(context, 16),
                SizeConfig.sh(context, 12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header (fixed)
                  Text('المساعدات', style: _titleStyle()),
                  SizedBox(height: SizeConfig.sh(context, 16)),

                  // شريط البحث (يمكنك توصيله لاحقًا بالفلترة)
                  _buildSearchBar(),
                  SizedBox(height: SizeConfig.sh(context, 16)),

                  // الإحصائيات والحالة حسب Cubit
                  BlocBuilder<AssistanceCubit, AssistanceState>(
                    builder: (context, state) {
                      if (state is AssistanceLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is AssistanceLoaded) {
                        return Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'إجمالي الأصناف',
                                state.totalTypes.toString(),
                                Icons.inventory_2,
                                _accent,
                              ),
                            ),
                            SizedBox(width: SizeConfig.sw(context, 12)),
                            Expanded(
                              child: _buildStatCard(
                                'إجمالي العناصر',
                                state.totalItems.toString(),
                                Icons.warning_amber_rounded,
                                const Color(0xFFFFA726),
                              ),
                            ),
                          ],
                        );
                      } else if (state is AssistanceError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),

                  SizedBox(height: SizeConfig.sh(context, 24)),
                  Text('جميع الأصناف', style: _sectionTitleStyle()),
                  SizedBox(height: SizeConfig.sh(context, 16)),

                  // Only the list scrolls
                  Expanded(
                    child: BlocBuilder<AssistanceCubit, AssistanceState>(
                      builder: (context, state) {
                        if (state is AssistanceLoading) return const Center(child: CircularProgressIndicator());
                        if (state is AssistanceLoaded) {
                          final items = state.helpTypeCounts;
                          if (items.isEmpty) return const Center(child: Text('لا توجد بيانات'));
                          return ListView.separated(
                            padding: EdgeInsets.only(bottom: listBottomPadding),
                            itemCount: items.length,
                            separatorBuilder: (_, __) => SizedBox(height: SizeConfig.sh(context, 12)),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return _buildAssistanceItem(
                                title: item.nameAr ?? 'غير معروف',
                                quantity: item.count.toString(),
                                unit: ':الوحدة ${item.nameAr}',
                                icon: item.icon ?? 'logo.png',
                                status: item.nameAr ?? 'available',
                                iconColor: _accent,
                              );
                            },
                          );
                        }
                        if (state is AssistanceError) return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Floating bottom action bar
             Positioned(
               left: 0,
               right: 0,
               bottom: 0,
               child: Container(
                 padding: EdgeInsets.symmetric(
                     horizontal: SizeConfig.sw(context, 16),
                     vertical: SizeConfig.sh(context, 18)),
                 // Gradient with 3 stops: transparent -> 80% opacity dark -> full dark
                 decoration: BoxDecoration(
                   gradient: LinearGradient(
                     begin: Alignment.topCenter,
                     end: Alignment.bottomCenter,
                     colors: [
                       Colors.transparent,
                       // _bg is 0xFF0B1216 -> rgb(11,18,22)
                       Color.fromRGBO(11, 18, 22, 0.8),
                       _bg,
                     ],
                     stops: const [0.0, 0.5, 1.0],
                   ),
                 ),
                 child: Row(
                   textDirection: TextDirection.rtl,
                   children: [
                     // Circular Add Button
                     Container(
                       width: 56,
                       height: 56,
                       decoration: BoxDecoration(
                         shape: BoxShape.circle,
                         boxShadow: [
                           BoxShadow(
                             // _accent is 0xFF2196F3 -> rgb(33,150,243)
                             color: Color.fromRGBO(33, 150, 243, 0.28),
                             blurRadius: 12,
                             offset: const Offset(0, 6),
                           ),
                         ],
                       ),
                       child: ElevatedButton(
                         onPressed: () {
                           // TODO: handle add action
                         },
                         style: ElevatedButton.styleFrom(
                           padding: EdgeInsets.zero,
                           shape: const CircleBorder(),
                           backgroundColor: _accent,
                           elevation: 6,
                         ),
                         child: const Icon(Icons.add, color: Colors.white, size: 28),
                       ),
                     ),

                     SizedBox(width: SizeConfig.sw(context, 12)),

                     // Expanded Main Action Button
                     Expanded(
                       child: SizedBox(
                         height: 56,
                         child: ElevatedButton(
                           onPressed: () {
                             Navigator.push(context, MaterialPageRoute(builder: (context) => DonationsScreen()));
                             // TODO: main action (open assistance log)
                           },
                           style: ElevatedButton.styleFrom(
                             backgroundColor: _accent,
                             elevation: 6,
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(16),
                             ),
                           ),
                           child: Text(
                             'سجل المساعدات',
                             textAlign: TextAlign.center,
                             style: GoogleFonts.cairo(
                               fontSize: SizeConfig.sp(context, 16),
                               fontWeight: FontWeight.w600,
                               color: Colors.white,
                             ),
                           ),
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
             ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(SizeConfig.sw(context, 12)),
        border: Border.all(color: Colors.white.withAlpha((0.1 * 255).round())),
      ),
      child: TextField(
        textAlign: TextAlign.right,
        style: GoogleFonts.cairo(
            color: Colors.white, fontSize: SizeConfig.sp(context, 14)),
        decoration: InputDecoration(
          hintText: 'بحث عن صنف مثال (غذاء، أدوية) :',
          hintStyle: GoogleFonts.cairo(
            // replace with Color.fromRGBO for alpha
            color: Color.fromRGBO(255, 255, 255, 0.4),
            fontSize: SizeConfig.sp(context, 14),
          ),
          prefixIcon: Icon(Icons.search,
              color: Color.fromRGBO(255, 255, 255, 0.4)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
              horizontal: SizeConfig.sw(context, 16),
              vertical: SizeConfig.sh(context, 14)),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.sw(context, 16)),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(SizeConfig.sw(context, 12)),
        // replace with Color.fromRGBO for alpha
        border: Border.all(color: Color.fromRGBO(255, 255, 255, 0.05)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(SizeConfig.sw(context, 10)),
                decoration: BoxDecoration(
                  // use dynamic color alpha via fromRGBO (color.r/g/b are 0..1 doubles)
                  color: Color.fromRGBO((color.r * 255).round(), (color.g * 255).round(), (color.b * 255).round(), 0.15),
                  borderRadius:
                      BorderRadius.circular(SizeConfig.sw(context, 10)),
                ),
                child:
                    Icon(icon, color: color, size: SizeConfig.sp(context, 24)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(label,
                      style: GoogleFonts.cairo(
                          color: Colors.white70,
                          fontSize: SizeConfig.sp(context, 13))),
                  SizedBox(height: SizeConfig.sh(context, 4)),
                  Text(value,
                      style: GoogleFonts.cairo(
                          fontSize: SizeConfig.sp(context, 24),
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAssistanceItem({
    required String title,
    required String quantity,
    required String unit,
    required String icon,
    required  Color iconColor,
    required String status}
  ) {
    Color getStatusColor() {
      switch (status) {
        case 'available':
          return const Color(0xFF4CAF50);
        case 'low':
          return const Color(0xFFFFA726);
        case 'critical':
          return const Color(0xFFF44336);
        default:
          return Colors.grey;
      }
    }

    String getStatusText() {
      switch (status) {
        case 'low':
          return 'منخفض';
        case 'critical':
          return 'حرج';
        default:
          return '';
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color.fromRGBO(255, 255, 255, 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              // dynamic iconColor alpha via fromRGBO (iconColor.r/g/b are 0..1 doubles)
              color: Color.fromRGBO((iconColor.r * 255).round(), (iconColor.g * 255).round(), (iconColor.b * 255).round(), 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: icon == 'logo.png'
                ? Image.asset('images/$icon',width: 24,)
                : Image.network('$icon',width:24),

          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(quantity,
                        style: GoogleFonts.cairo(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(width: 8),
                    Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                            color: getStatusColor(), shape: BoxShape.circle)),
                    if (status != 'available') ...[
                      const SizedBox(width: 6),
                      Text(getStatusText(),
                          style: GoogleFonts.cairo(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: getStatusColor())),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(unit, style: _unitStyle()),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(title,
                  style: GoogleFonts.cairo(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
