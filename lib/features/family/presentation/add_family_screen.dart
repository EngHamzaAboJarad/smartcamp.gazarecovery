import 'package:flutter/material.dart';
import 'package:smartcamp_gazarecovery/features/family/presentation/widgets/input_field.dart';
// removed in-file widgets imports
// new imports
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartcamp_gazarecovery/features/family/presentation/cubit/family_cubit.dart';
import 'package:smartcamp_gazarecovery/features/family/presentation/widgets/add_family_header.dart';
import 'package:smartcamp_gazarecovery/features/family/presentation/widgets/camp_data_card.dart';
import 'package:smartcamp_gazarecovery/features/family/presentation/widgets/family_members_card.dart';
import 'package:smartcamp_gazarecovery/features/family/presentation/widgets/status_notes.dart';
import 'package:smartcamp_gazarecovery/features/family/presentation/widgets/save_button.dart';

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
                    // Header (extracted)
                    AddFamilyHeader(onBack: () => Navigator.of(context).maybePop()),
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
                    // Camp data card (extracted)
                    CampDataCard(cubit: cubit, categories: _campCategories),
                    const SizedBox(height: 18),
                    // Family members card (extracted)
                    FamilyMembersCard(cubit: cubit, onChanged: () => setState(() {})),
                    const SizedBox(height: 18),
                    // Status and notes (extracted)
                    StatusNotes(cubit: cubit, onChanged: () => setState(() {})),
                    const SizedBox(height: 22),
                    // Save button (extracted)
                    SaveButton(cubit: cubit, onSaved: () => setState(() {})),

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
