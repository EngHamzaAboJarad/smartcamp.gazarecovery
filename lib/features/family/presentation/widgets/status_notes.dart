import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartcamp_gazarecovery/features/family/presentation/cubit/family_cubit.dart';
import 'package:smartcamp_gazarecovery/features/family/presentation/widgets/input_field.dart';

class StatusNotes extends StatelessWidget {
  final FamilyCubit cubit;
  final VoidCallback onChanged;

  const StatusNotes({Key? key, required this.cubit, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
                  onChanged();
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
        Text('ملاحظات إضافية (اختياري)', style: GoogleFonts.cairo(color: Colors.white70, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        InputField(
          controller: cubit.notesController,
          hint: 'أي تفاصيل أخرى عن حالة الخيمة أو محتوياتها',
          icon: Icons.note_alt,
          keyboardType: TextInputType.multiline,
          maxLines: 5,
        ),
      ],
    );
  }
}

