import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartcamp_gazarecovery/features/family/presentation/cubit/family_cubit.dart';
import 'package:smartcamp_gazarecovery/features/family/presentation/widgets/input_field.dart';

class ChildCard extends StatelessWidget {
  final FamilyCubit cubit;
  final int index;
  final VoidCallback onRemoved;

  const ChildCard({Key? key, required this.cubit, required this.index, required this.onRemoved}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  if (cubit.children.length <= 1) return;
                  cubit.removeChild(index);
                  onRemoved();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

