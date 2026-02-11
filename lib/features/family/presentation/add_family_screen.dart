import 'package:flutter/material.dart';
import 'package:smartcamp_gazarecovery/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:smartcamp_gazarecovery/features/dashboard/presentation/cubit/dashboard_state.dart';
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
  AddFamilyScreen({Key? key}) : super(key: key);

  @override
  State<AddFamilyScreen> createState() => _AddFamilyScreenState();
}

class _AddFamilyScreenState extends State<AddFamilyScreen> {
  // Keep only the camp categories metadata here; controllers are in the cubit
  final List<Map<String, dynamic>> _campCategories = const [
    {'key': 'males', 'label': 'ذكور', 'icon': Icons.male},
    {'key': 'females', 'label': 'إناث', 'icon': Icons.female},
    {'key': 'children', 'label': 'عدد الأطفال', 'icon': Icons.group},
    {'key': 'disabled', 'label': 'ذوي همم', 'icon': Icons.accessible},
    {'key': 'children_under_18', 'label': 'أطفال أقل من (18)', 'icon': Icons.child_care},
    {'key': 'elderly', 'label': 'كبار سن', 'icon': Icons.elderly},
  ];

  late final FamilyCubit _cubit;
  late final DashboardCubit Dashboard_Cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<FamilyCubit>();
    Dashboard_Cubit = context.read<DashboardCubit>();
     // Rebuild whenever the peopleController changes so the UI reflects
    // the computed children count and the dynamic children list.
    _cubit.peopleController.addListener(_onPeopleChanged);
  }

  void _onPeopleChanged() => setState(() {});

  @override
  void dispose() {
    try { _cubit.peopleController.removeListener(_onPeopleChanged); } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = _cubit;

    // compute children limit for add button
    final expected = int.tryParse(cubit.peopleController.text) ?? 0;
    final maxChildren = expected > 2 ? expected - 2 : 0;

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
                controller: cubit.scrollController,
                child: Form(
                  key: cubit.formKey,
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
                        validator: cubit.validateTent,
                        fieldKey: cubit.fieldKeys['tent'],
                      ),
                      const SizedBox(height: 12),
                      InputField(
                        controller: cubit.peopleController,
                        hint: 'عدد الأفراد المتوقعين',
                        icon: Icons.group,
                        keyboardType: TextInputType.number,
                        validator: cubit.validatePeople,
                        fieldKey: cubit.fieldKeys['people'],
                      ),
                      const SizedBox(height: 12),
                      InputField(
                        controller: cubit.phoneController,
                        hint: 'رقم الجوال',
                        icon: Icons.phone_android,
                        keyboardType: TextInputType.phone,
                        validator: cubit.validatePhone,
                        fieldKey: cubit.fieldKeys['phone'],
                      ),
                      const SizedBox(height: 12),
                      InputField(
                        controller: cubit.idController,
                        hint: 'رقم الهوية',
                        icon: Icons.badge,
                        keyboardType: TextInputType.number,
                        validator: cubit.validateNationalId,
                        fieldKey: cubit.fieldKeys['id'],
                      ),
                      const SizedBox(height: 18),
                      // Camp data card (extracted)
                      CampDataCard(
                        cubit: cubit,
                        categories: _campCategories,
                        validators: {
                          for (final cat in _campCategories) (cat['key'] as String): cubit.validateNonNegativeInt
                        },
                        fieldKeys: {for (final cat in _campCategories) (cat['key'] as String): cubit.fieldKeys[cat['key'] as String]},
                      ),
                      const SizedBox(height: 18),
                      // Family members card (extracted)
                      FamilyMembersCard(
                        cubit: cubit,
                        onChanged: () => setState(() {}),
                        childrenLimit: maxChildren,
                        // pass validators and field keys so the card's fields participate in Form validation
                        fatherNameValidator: cubit.validateParentName,
                        fatherAgeValidator: cubit.validateParentAge,
                        fatherIdValidator: cubit.validateOptionalId,
                        motherNameValidator: cubit.validateParentName,
                        motherAgeValidator: cubit.validateParentAge,
                        motherIdValidator: cubit.validateOptionalId,
                        childNameValidator: cubit.validateChildName,
                        childAgeValidator: cubit.validateChildAge,
                        childIdValidator: cubit.validateOptionalId,
                        parentFieldKeys: {
                          'father_name': cubit.fieldKeys['father_name']!,
                          'father_age': cubit.fieldKeys['father_age']!,
                          'father_id': cubit.fieldKeys['father_id']!,
                          'mother_name': cubit.fieldKeys['mother_name']!,
                          'mother_age': cubit.fieldKeys['mother_age']!,
                          'mother_id': cubit.fieldKeys['mother_id']!,
                        },
                        childrenFieldKeys: cubit.childrenFieldKeys.sublist(0, cubit.children.length),
                      ),
                      const SizedBox(height: 18),
                      // Status and notes (extracted)
                      StatusNotes(
                        cubit: cubit,
                        onChanged: () => setState(() {}),
                        notesValidator: cubit.validateNotes,
                        notesFieldKey: cubit.fieldKeys['notes'],
                      ),
                      const SizedBox(height: 22),
                      // Save button (extracted)
                      SaveButton(cubit: cubit, onSaved: () => cubit.validateAndSubmit(context),Dashboard_Cubit: Dashboard_Cubit,),
                      const SizedBox(height: 40),
                    ],
                  ),//final DashboardData? object =

                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
