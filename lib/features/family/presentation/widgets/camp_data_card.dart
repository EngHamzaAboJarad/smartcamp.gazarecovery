import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartcamp_gazarecovery/features/family/presentation/widgets/camp_grid_item.dart';
import 'package:smartcamp_gazarecovery/features/family/presentation/cubit/family_cubit.dart';

class CampDataCard extends StatelessWidget {
  final FamilyCubit cubit;
  final List<Map<String, dynamic>> categories;
  final Map<String, String? Function(String?)?>? validators;
  final Map<String, Key?>? fieldKeys;

  const CampDataCard({
    Key? key,
    required this.cubit,
    required this.categories,
    this.validators,
    this.fieldKeys,
  }) : super(key: key);

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
              Text('بيانات الخيمة', style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
              const Spacer(),
              const Icon(Icons.info_outline, color: Colors.blueAccent),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.9,
            ),
            itemCount: categories.length,
            itemBuilder: (ctx, i) {
              final cat = categories[i];
              final key = cat['key'] as String;
              final controller = cubit.campControllers[key]!;
              return CampGridItem(
                title: cat['label'] as String,
                controller: controller,
                icon: cat['icon'] as IconData,
                validator: validators != null ? validators![key] : null,
                fieldKey: fieldKeys != null ? fieldKeys![key] : null,
                // make the 'children' (عدد الأطفال) field read-only because it's computed
                readOnly: key == 'children',
              );
            },
          ),
        ],
      ),
    );
  }
}
