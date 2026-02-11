import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartcamp_gazarecovery/features/settings/presentation/cubit/edit_profile_cubit.dart';
import 'package:smartcamp_gazarecovery/features/settings/presentation/cubit/edit_profile_state.dart';
import 'package:smartcamp_gazarecovery/features/settings/presentation/widgets/labeled_field.dart';
import 'package:smartcamp_gazarecovery/features/settings/presentation/widgets/confirm_save_button.dart';
import 'package:smartcamp_gazarecovery/shared/widgets/top_floating_message.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: const Text('تعديل الملف', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: BlocConsumer<EditProfileCubit, EditProfileState>(
              listener: (context, state) {
                if (state is EditProfileLoading) {
                  // nothing to do; builder will show progress
                } else if (state is EditProfileSuccess) {
                  showTopFloatingMessage(context, state.message ?? 'تم تحديث البيانات', isError: false);
                  Future.delayed(const Duration(milliseconds: 350), () {
                    if (Navigator.of(context).canPop()) Navigator.of(context).pop(true);
                  });
                } else if (state is EditProfileError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                final cubit = context.read<EditProfileCubit>();
                final loadingLocal = state is EditProfileLoading || state is EditProfileInitial;
                return Form(
                  key: cubit.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 6),

                      if (loadingLocal)
                        const Center(child: SizedBox(height: 28, width: 28, child: CircularProgressIndicator(strokeWidth: 2)))
                      else ...[
                        // Name
                        LabeledField(
                          label: 'الاسم',
                          child: TextFormField(
                            controller: cubit.nameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: cubit.inputDecoration(),
                            keyboardType: TextInputType.text,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'حقل الاسم مطلوب';
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Email
                        LabeledField(
                          label: 'الايميل',
                          child: TextFormField(
                            controller: cubit.emailController,
                            style: const TextStyle(color: Colors.white),
                            decoration: cubit.inputDecoration(),
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'حقل الايميل مطلوب';
                              if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}").hasMatch(v.trim())) return 'ايميل غير صالح';
                              return null;
                            },
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Phone
                        LabeledField(
                          label: 'رقم الجوال',
                          child: TextFormField(
                            controller: cubit.phoneController,
                            style: const TextStyle(color: Colors.white),
                            decoration: cubit.inputDecoration(),
                            keyboardType: TextInputType.phone,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) return 'حقل رقم الجوال مطلوب';
                              // basic check
                              //if (!RegExp(r'^\+?[0-9]{6,}\$').hasMatch(v.trim())) return 'رقم جوال غير صالح';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Save button
                        BlocBuilder<EditProfileCubit, EditProfileState>(
                          builder: (context, state) {
                            final isLoading = state is EditProfileLoading;
                            return ConfirmSaveButton(
                              isLoading: isLoading,
                              formKey: cubit.formKey,
                              onConfirmed: () async {
                                var username = cubit.usernameController.text.trim();
                                if (username.isEmpty) username = cubit.generateUsername(cubit.nameController.text);
                                cubit.updateProfile(
                                  name: cubit.nameController.text.trim(),
                                  username: username,
                                  mobileNumber: cubit.phoneController.text.trim(),
                                );
                              },
                            );
                          },
                        ),

                        const SizedBox(height: 18),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}