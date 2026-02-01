import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartcamp_gazarecovery/core/prefs.dart';
import 'package:smartcamp_gazarecovery/features/settings/presentation/cubit/edit_profile_cubit.dart';
import 'package:smartcamp_gazarecovery/features/settings/presentation/cubit/edit_profile_state.dart';
import 'package:smartcamp_gazarecovery/features/settings/presentation/widgets/labeled_field.dart';
import 'package:smartcamp_gazarecovery/features/settings/presentation/widgets/confirm_save_button.dart';
import 'package:smartcamp_gazarecovery/shared/widgets/top_floating_message.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController(text: 'احمد محمد');
  final TextEditingController _emailController = TextEditingController(text: 'ahmad@gmail.com');
  final TextEditingController _phoneController = TextEditingController(text: '+970599999999');
  final TextEditingController _passwordController = TextEditingController();
  // hidden username field required by backend
  final TextEditingController _usernameController = TextEditingController();

  bool _loadingLocal = true;
  static const _darkCard = Color(0xFF0F1720);

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() => _loadingLocal = true);
    try {
      final userData = await Prefs.getUser();
      if (userData != null) {
        final user = userData.user;
        _nameController.text = user.name.isNotEmpty ? user.name : _nameController.text;
        if (user.email != null && user.email!.isNotEmpty) _emailController.text = user.email!;
        _phoneController.text = user.mobileNumber.isNotEmpty ? user.mobileNumber : _phoneController.text;
        _usernameController.text = user.username.isNotEmpty ? user.username : _generateUsername(user.name);
      } else {
        _usernameController.text = _generateUsername(_nameController.text);
      }
    } catch (_) {
      _usernameController.text = _generateUsername(_nameController.text);
    } finally {
      if (mounted) setState(() => _loadingLocal = false);
    }
  }

  String _generateUsername(String name) {
    final n = name.trim().toLowerCase();
    if (n.isEmpty) return 'manager';
    return n.replaceAll(RegExp(r'[^a-z0-9]+'), '-');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      border: InputBorder.none,
      hintStyle: const TextStyle(color: Colors.white38),
    );
  }

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
            child: BlocListener<EditProfileCubit, EditProfileState>(
              listener: (context, state) {
                if (state is EditProfileLoading) {
                  // optionally show local loader
                } else if (state is EditProfileSuccess) {
                  // Show top floating success message (and the cubit already updated Prefs)
                  showTopFloatingMessage(context, state.message ?? 'تم تحديث البيانات', isError: false);
                   // pop back after a short delay to allow user to see the message
                   Future.delayed(const Duration(milliseconds: 350), () {
                     if (mounted) Navigator.of(context).pop(true);
                   });
                } else if (state is EditProfileError) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 6),

                    if (_loadingLocal)
                      const Center(child: SizedBox(height: 28, width: 28, child: CircularProgressIndicator(strokeWidth: 2)))
                    else ...[
                      // Name
                      LabeledField(
                        label: 'الاسم',
                        child: TextFormField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration(),
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
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration(),
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
                          controller: _phoneController,
                          style: const TextStyle(color: Colors.white),
                          decoration: _inputDecoration(),
                          keyboardType: TextInputType.phone,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'حقل رقم الجوال مطلوب';
                            // basic check
                            //if (!RegExp(r'^\+?[0-9]{6,}\$').hasMatch(v.trim())) return 'رقم جوال غير صالح';
                            return null;
                          },
                        ),
                      ),

                      // const SizedBox(height: 14),
                      //
                      // // Password (optional)
                      // _buildLabeledField(
                      //   label: 'كلمة المرور',
                      //   field: TextFormField(
                      //     controller: _passwordController,
                      //     style: const TextStyle(color: Colors.white),
                      //     decoration: _inputDecoration().copyWith(
                      //       suffixIcon: IconButton(
                      //         icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: Colors.white54),
                      //         onPressed: () => setState(() => _obscure = !_obscure),
                      //       ),
                      //     ),
                      //     obscureText: _obscure,
                      //     keyboardType: TextInputType.visiblePassword,
                      //     validator: (v) {
                      //       // password optional for edit form; if provided, enforce min length
                      //       if (v != null && v.isNotEmpty && v.length < 6) return 'كلمة المرور قصيرة';
                      //       return null;
                      //     },
                      //   ),
                      // ),

                      const SizedBox(height: 24),

                      // Save button
                      BlocBuilder<EditProfileCubit, EditProfileState>(
                        builder: (context, state) {
                          final isLoading = state is EditProfileLoading;
                          return ConfirmSaveButton(
                            isLoading: isLoading,
                            onConfirmed: () async {
                              var username = _usernameController.text.trim();
                              if (username.isEmpty) username = _generateUsername(_nameController.text);
                              context.read<EditProfileCubit>().updateProfile(
                                    name: _nameController.text.trim(),
                                    username: username,
                                    mobileNumber: _phoneController.text.trim(),
                                  );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 18),
                    ],
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
