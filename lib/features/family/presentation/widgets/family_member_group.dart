import 'package:flutter/material.dart';
import 'package:smartcamp_gazarecovery/features/family/presentation/widgets/input_field.dart';

class FamilyMemberGroup extends StatelessWidget {
  final String title;
  final TextEditingController? nameController;
  final TextEditingController? idController;
  final TextEditingController? ageController;
  final String? Function(String?)? nameValidator;
  final String? Function(String?)? ageValidator;
  final String? Function(String?)? idValidator;
  final Key? nameFieldKey;
  final Key? ageFieldKey;
  final Key? idFieldKey;

  const FamilyMemberGroup({
    Key? key,
    required this.title,
    this.nameController,
    this.idController,
    this.ageController,
    this.nameValidator,
    this.ageValidator,
    this.idValidator,
    this.nameFieldKey,
    this.ageFieldKey,
    this.idFieldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: InputField(
                  controller: nameController,
                  hint: 'الاسم',
                  icon: Icons.person,
                  validator: nameValidator,
                  fieldKey: nameFieldKey,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InputField(
                  controller: ageController,
                  hint: 'العمر',
                  icon: Icons.calendar_today,
                  keyboardType: TextInputType.number,
                  validator: ageValidator,
                  fieldKey: ageFieldKey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          InputField(
            controller: idController,
            hint: 'الهوية',
            icon: Icons.badge,
            keyboardType: TextInputType.number,
            validator: idValidator,
            fieldKey: idFieldKey,
          ),
        ],
      ),
    );
  }
}
