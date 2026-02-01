import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartcamp_gazarecovery/features/family/presentation/cubit/family_cubit.dart';
import 'package:smartcamp_gazarecovery/features/family/presentation/widgets/input_field.dart';

class ChildCard extends StatelessWidget {
  final FamilyCubit cubit;
  final int index;
  final VoidCallback onRemoved;
  final bool allowRemove;
  final String? Function(String?)? nameValidator;
  final String? Function(String?)? ageValidator;
  final String? Function(String?)? idValidator;
  // use stronger typing for keys so callers pass GlobalKey<FormFieldState>
  final GlobalKey<FormFieldState>? nameFieldKey;
  final GlobalKey<FormFieldState>? ageFieldKey;
  final GlobalKey<FormFieldState>? idFieldKey;

  const ChildCard({
    Key? key,
    required this.cubit,
    required this.index,
    required this.onRemoved,
    this.allowRemove = true,
    this.nameValidator,
    this.ageValidator,
    this.idValidator,
    this.nameFieldKey,
    this.ageFieldKey,
    this.idFieldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Safety: if index is out of range, return an empty widget instead
    if (index < 0 || index >= cubit.children.length) return const SizedBox.shrink();

    // Get the child's controllers from the cubit
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
                  validator: nameValidator ?? cubit.validateChildName,
                  fieldKey: nameFieldKey,
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
                        validator: ageValidator ?? cubit.validateChildAge,
                        fieldKey: ageFieldKey,
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
                        validator: idValidator ?? cubit.validateOptionalId,
                        fieldKey: idFieldKey,
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
                onPressed: !allowRemove
                    ? null
                    : () {
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
