import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartcamp_gazarecovery/features/family/presentation/widgets/input_field.dart';
import 'package:smartcamp_gazarecovery/features/family/presentation/widgets/family_member_group.dart';
import 'package:smartcamp_gazarecovery/features/family/presentation/widgets/camp_grid_item.dart';

// new imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartcamp_gazarecovery/shared/widgets/top_floating_message.dart';
import 'package:smartcamp_gazarecovery/features/family/presentation/cubit/family_cubit.dart';

class AddFamilyScreen extends StatefulWidget {
  const AddFamilyScreen({Key? key}) : super(key: key);

  @override
  State<AddFamilyScreen> createState() => _AddFamilyScreenState();
}

class _AddFamilyScreenState extends State<AddFamilyScreen> {
  // Keep only the camp categories metadata here; controllers are in the cubit
  final List<Map<String, dynamic>> _campCategories = [
    {'key': 'males', 'label': 'ذكور', 'icon': Icons.male},
    {'key': 'females', 'label': 'إناث', 'icon': Icons.female},
    {'key': 'children', 'label': 'عدد الأطفال', 'icon': Icons.group},
    {'key': 'disabled', 'label': 'ذوي همم', 'icon': Icons.accessible},
    {'key': 'children_under_18', 'label': 'أطفال أقل من (18)', 'icon': Icons.child_care},
    {'key': 'elderly', 'label': 'كبار سن', 'icon': Icons.elderly},
  ];

  Widget _buildChildCard(int index) {
    final cubit = context.read<FamilyCubit>();
    final child = cubit.children[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Stack(
        children: [
          // the card
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withAlpha(10)),
            ),
            padding: const EdgeInsets.fromLTRB(12, 18, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title top-right (because of RTL)
                Align(
                  alignment: Alignment.topRight,
                  child: Text('الولد ${index + 1}',
                      style: GoogleFonts.cairo(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                // fields
                InputField(
                  controller: child.name,
                  hint: 'الاسم',
                  icon: Icons.person,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: InputField(
                        controller: child.age,
                        hint: 'العمر',
                        icon: Icons.calendar_today,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: InputField(
                        controller: child.id,
                        hint: 'الهوية',
                        icon: Icons.badge,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // delete button on the 'start' side so it respects RTL: in RTL start is right
          PositionedDirectional(
            top: -6,
            start: -6,
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.redAccent),
                onPressed: () {
                  final cubit = context.read<FamilyCubit>();
                  if (cubit.children.length <= 1) return;
                  cubit.removeChild(index);
                  setState(() {}); // rebuild list
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FamilyCubit>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF07121A), Color(0xFF0B1B25)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.arrow_forward, color: Colors.white),
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Text('إضافة عائلة',
                                style: GoogleFonts.cairo(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text('مخيم النور المنطقة الشمالية',
                                style: GoogleFonts.cairo(
                                    color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Inputs (controllers live in cubit)
                    InputField(
                      controller: cubit.tentController,
                      hint: 'مثال: A-105',
                      icon: Icons.abc,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 12),
                    InputField(
                      controller: cubit.peopleController,
                      hint: 'عدد الأفراد المتوقعين',
                      icon: Icons.group,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    InputField(
                      controller: cubit.phoneController,
                      hint: 'رقم الجوال',
                      icon: Icons.phone_android,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    InputField(
                      controller: cubit.idController,
                      hint: 'رقم الهوية',
                      icon: Icons.badge,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 18),

                    // Camp data card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withAlpha(10)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Text('بيانات الخيمة', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
                              const Spacer(),
                              Icon(Icons.info_outline, color: Colors.blueAccent),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // replaced static GridView with builder that shows numeric input fields for each category
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 0.9,
                            ),
                            itemCount: _campCategories.length,
                            itemBuilder: (ctx, i) {
                              final cat = _campCategories[i];
                              return CampGridItem(
                                title: cat['label'],
                                controller: cubit.campControllers[cat['key']]!,
                                icon: cat['icon'],
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Family members card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withAlpha(10)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Text('أفراد الأسرة', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
                              const Spacer(),
                              Icon(Icons.people_outline, color: Colors.blueAccent),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // fixed groups
                          FamilyMemberGroup(
                            title: 'رب الأسرة',
                            nameController: cubit.familyNameController,
                            idController: cubit.familyIdController,
                            ageController: cubit.familyAgeController,
                          ),
                          // Father is old switch
                          Row(
                            children: [
                              Expanded(child: SizedBox()),
                              Text('رب الأسرة كبير بالسن', style: GoogleFonts.cairo(color: Colors.white70)),
                              const SizedBox(width: 8),
                              Switch(
                                value: cubit.fatherIsOld,
                                onChanged: (v) {
                                  cubit.fatherIsOld = v;
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          FamilyMemberGroup(
                            title: 'الزوجة',
                            nameController: cubit.wifeNameController,
                            idController: cubit.wifeIdController,
                            ageController: cubit.wifeAgeController,
                          ),
                          // Mother is old switch
                          Row(
                            children: [
                              Expanded(child: SizedBox()),
                              Text('الزوجة كبيرة بالسن', style: GoogleFonts.cairo(color: Colors.white70)),
                              const SizedBox(width: 8),
                              Switch(
                                value: cubit.motherIsOld,
                                onChanged: (v) {
                                  cubit.motherIsOld = v;
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // dynamic children list rendered with ListView.builder
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cubit.children.length,
                            itemBuilder: (ctx, i) => _buildChildCard(i),
                          ),

                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<FamilyCubit>().addChild();
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                              ),
                              child: Text('إضافة', style: GoogleFonts.cairo(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Status selection (occupied,vacant,unusable,reserved,other)
                    Row(
                      children: [
                        Text('الحالة', style: GoogleFonts.cairo(color: Colors.white70)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: cubit.statusController.text.isEmpty ? 'other' : cubit.statusController.text,
                            items: const [
                              DropdownMenuItem(value: 'occupied', child: Text('occupied')),
                              DropdownMenuItem(value: 'vacant', child: Text('vacant')),
                              DropdownMenuItem(value: 'unusable', child: Text('unusable')),
                              DropdownMenuItem(value: 'reserved', child: Text('reserved')),
                              DropdownMenuItem(value: 'other', child: Text('other')),
                            ],
                            onChanged: (v) {
                              cubit.statusController.text = v ?? 'other';
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withAlpha(6),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Notes
                    Text('ملاحظات إضافية (اختياري)', style: GoogleFonts.cairo(color: Colors.white70, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    InputField(
                      controller: cubit.notesController,
                      hint: 'أي تفاصيل أخرى عن حالة الخيمة أو محتوياتها',
                      icon: Icons.note_alt,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                    ),

                    const SizedBox(height: 22),

                    // Save button
                    ElevatedButton(
                      onPressed: () async {
                         await context.read<FamilyCubit>().createTent(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E88E5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: Text('حفظ البيانات', style: GoogleFonts.cairo(color: Colors.white, fontSize: 16)),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
