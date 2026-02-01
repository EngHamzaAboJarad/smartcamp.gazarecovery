import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartcamp_gazarecovery/features/family/presentation/cubit/family_cubit.dart';
import 'package:smartcamp_gazarecovery/features/family/presentation/widgets/family_member_group.dart';
import 'package:smartcamp_gazarecovery/features/family/presentation/widgets/child_card.dart';

class FamilyMembersCard extends StatelessWidget {
  final FamilyCubit cubit;
  final VoidCallback onChanged;

  const FamilyMembersCard({Key? key, required this.cubit, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              const Expanded(child: SizedBox()),
              Text('رب الأسرة كبير بالسن', style: GoogleFonts.cairo(color: Colors.white70)),
              const SizedBox(width: 8),
              Switch(
                value: cubit.fatherIsOld,
                onChanged: (v) {
                  cubit.fatherIsOld = v;
                  onChanged();
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
              const Expanded(child: SizedBox()),
              Text('الزوجة كبيرة بالسن', style: GoogleFonts.cairo(color: Colors.white70)),
              const SizedBox(width: 8),
              Switch(
                value: cubit.motherIsOld,
                onChanged: (v) {
                  cubit.motherIsOld = v;
                  onChanged();
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
            itemBuilder: (ctx, i) => ChildCard(
              cubit: cubit,
              index: i,
              onRemoved: onChanged,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                cubit.addChild();
                onChanged();
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
    );
  }
}

