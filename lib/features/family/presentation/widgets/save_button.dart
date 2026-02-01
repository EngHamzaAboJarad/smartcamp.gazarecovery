import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartcamp_gazarecovery/features/family/presentation/cubit/family_cubit.dart';

class SaveButton extends StatelessWidget {
  final FamilyCubit cubit;
  final VoidCallback onSaved;

  const SaveButton({Key? key, required this.cubit, required this.onSaved}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          await cubit.createTent(context);
        } catch (_) {
          // errors are handled by cubit; still trigger a rebuild so cleared data shows
        }
        onSaved();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E88E5),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text('حفظ البيانات', style: GoogleFonts.cairo(color: Colors.white, fontSize: 16)),
    );
  }
}

