import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartcamp_gazarecovery/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:smartcamp_gazarecovery/shared/widgets/top_floating_message.dart';
import 'family_state.dart';
import 'package:smartcamp_gazarecovery/core/http_client.dart';
import 'package:smartcamp_gazarecovery/core/api_settings.dart';
import 'dart:convert';

/// A small model for children (moved from the screen into the cubit)
class ChildModel {
  final TextEditingController name = TextEditingController();
  final TextEditingController id = TextEditingController();
  final TextEditingController age = TextEditingController();

  Map<String, String> toJson() => {
        'name': name.text,
        'id': id.text,
        'age': age.text,
      };

  void dispose() {
    name.dispose();
    id.dispose();
    age.dispose();
  }
}

class FamilyCubit extends Cubit<FamilyState> {
  // Form controllers moved from the UI into the cubit
  final TextEditingController tentController = TextEditingController();
  final TextEditingController peopleController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  // family members
  final TextEditingController familyNameController = TextEditingController();
  final TextEditingController familyIdController = TextEditingController();
  final TextEditingController familyAgeController = TextEditingController();

  // wife
  final TextEditingController wifeNameController = TextEditingController();
  final TextEditingController wifeIdController = TextEditingController();
  final TextEditingController wifeAgeController = TextEditingController();

  // notes
  final TextEditingController notesController = TextEditingController();

  // status (string) - default empty
  final TextEditingController statusController =
      TextEditingController(text: 'occupied');

  // flags for elder indicators
  bool fatherIsOld = false;
  bool motherIsOld = false;

  // camp numeric categories
  final Map<String, TextEditingController> campControllers = {};

  // dynamic children list
  final List<ChildModel> children = [];

  // Form helpers used by the UI
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();

  // Field keys used across the form (parents, tents, camp fields, notes, etc.)
  // GlobalKey<FormFieldState> is used where the widget expects a stronger type,
  // and it also implements Key so it can be passed to widgets that accept Key.
  final Map<String, GlobalKey<FormFieldState>> fieldKeys = {
    'tent': GlobalKey<FormFieldState>(),
    'people': GlobalKey<FormFieldState>(),
    'phone': GlobalKey<FormFieldState>(),
    'id': GlobalKey<FormFieldState>(),

    'males': GlobalKey<FormFieldState>(),
    'females': GlobalKey<FormFieldState>(),
    'children': GlobalKey<FormFieldState>(),
    'disabled': GlobalKey<FormFieldState>(),
    'children_under_18': GlobalKey<FormFieldState>(),
    'elderly': GlobalKey<FormFieldState>(),

    'father_name': GlobalKey<FormFieldState>(),
    'father_age': GlobalKey<FormFieldState>(),
    'father_id': GlobalKey<FormFieldState>(),
    'mother_name': GlobalKey<FormFieldState>(),
    'mother_age': GlobalKey<FormFieldState>(),
    'mother_id': GlobalKey<FormFieldState>(),

    'notes': GlobalKey<FormFieldState>(),
  };

  // ---------------------- Validation helpers ----------------------
  String? validateTent(String? v) {
    if (v == null || v.trim().isEmpty) return 'حقل الخيمة مطلوب';
    return null;
  }

  String? validatePeople(String? v) {
    if (v == null || v.trim().isEmpty) return 'عدد الأفراد مطلوب';
    final n = int.tryParse(v.trim());
    if (n == null || n < 0) return 'أدخل رقماً صحيحاً غير سالب';
    return null;
  }

  String? validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'رقم الجوال مطلوب';
    final cleaned = v.trim();
    if (!RegExp(r'^\d{6,}$').hasMatch(cleaned)) return 'رقم جوال غير صالح';
    return null;
  }

  String? validateNationalId(String? v) {
    if (v == null || v.trim().isEmpty) return 'رقم الهوية مطلوب';
    if (!RegExp(r'^\d{3,}$').hasMatch(v.trim())) return 'رقم هوية غير صالح';
    return null;
  }

  String? validateOptionalId(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    if (int.tryParse(v.trim()) == null) return 'الهوية غير صالحة';
    return null;
  }

  String? validateNonNegativeInt(String? v) {
    if (v == null || v.trim().isEmpty) return null; // empty means 0
    final n = int.tryParse(v.trim());
    if (n == null || n < 0) return 'أدخل رقمًا صحيحًا غير سالب';
    return null;
  }

  String? validateParentName(String? v) {
    if (v == null || v.trim().isEmpty) return 'الاسم مطلوب';
    return null;
  }

  String? validateParentAge(String? v) {
    if (v == null || v.trim().isEmpty) return null; // optional
    final n = int.tryParse(v.trim());
    if (n == null || n < 0) return 'أدخل عمرًا صالحًا';
    return null;
  }

  String? validateChildName(String? v) {
    if (v == null || v.trim().isEmpty) return 'اسم الطفل مطلوب';
    return null;
  }

  String? validateChildAge(String? v) {
    if (v == null || v.trim().isEmpty) return 'عمر الطفل مطلوب';
    final n = int.tryParse(v.trim());
    if (n == null || n < 0) return 'أدخل عمرًا صالحًا';
    return null;
  }

  String? validateNotes(String? v) {
    if (v == null || v.isEmpty) return null;
    if (v.length > 500) return 'الملاحظات طويلة جدًا';
    return null;
  }

  /// Validate the Form and submit by calling [createTent].
  /// Returns true when submission was triggered successfully.
  Future<bool> validateAndSubmit(BuildContext context) async {
    final formState = formKey.currentState;
    if (formState == null) return false;
    // Run validators
    final valid = formState.validate();
    if (!valid) return false;

    try {
      await createTent(context,context.read<DashboardCubit>().currentDashboard!.data!.id.toString());
      return true;
    } catch (_) {
      return false;
    }
  }

  // Pre-generated persistent keys for child form fields so the cubit/UI can address
  // specific child's fields by index even after widget rebuilds. Adjust the
  // size below if you need more/less pre-created slots.
  final List<Map<String, GlobalKey<FormFieldState>>> childrenFieldKeys =
      List.generate(
    20,
    (_) => {
      'name': GlobalKey<FormFieldState>(),
      'age': GlobalKey<FormFieldState>(),
      'id': GlobalKey<FormFieldState>(),
    },
  );

  FamilyCubit() : super(const FamilyInitial()) {
    // initialize camp controllers with the same keys used by the UI
    for (final key in [
      'males',
      'females',
      'disabled',
      'children_under_18',
      'elderly'
    ]) {
      campControllers[key] = TextEditingController(text: '0');
    }
    // add a controller for total children count (occupants_children)
    campControllers['children'] = TextEditingController(text: '0');

    // keep the computed children count synced with the expected people field.
    // children are defined as expected_people - 2 (father + mother), minimum 0.
    peopleController.addListener(_onPeopleControllerChanged);

    // initialize children based on current peopleController value so the
    // children count is linked to the expected people from the start
    _syncChildrenWithPeople();
  }

  void _onPeopleControllerChanged() {
    try {
      _syncChildrenWithPeople();
    } catch (_) {}
  }

  void _syncChildrenWithPeople() {
    final expected = int.tryParse(peopleController.text.trim()) ?? 0;
    // children count is expected minus father + mother (2), not less than 0
    final desiredChildren = expected > 2 ? expected - 2 : 0;

    // update the camp controller display value
    try {
      campControllers['children']?.text = desiredChildren.toString();
    } catch (_) {}

    // adjust the children list to match desiredChildren
    // if we need more, add; if we have too many, remove from the end
    while (children.length < desiredChildren) {
      // ensure there is a key slot for the new child
      if (children.length >= childrenFieldKeys.length) {
        childrenFieldKeys.add({
          'name': GlobalKey<FormFieldState>(),
          'age': GlobalKey<FormFieldState>(),
          'id': GlobalKey<FormFieldState>(),
        });
      }
      children.add(ChildModel());
    }

    while (children.length > desiredChildren) {
      final removed = children.removeLast();
      try {
        removed.dispose();
      } catch (_) {}
    }
  }

  // ---------------------- Private helpers (refactored) ----------------------
  int _parseIntController(TextEditingController? ctl) =>
      int.tryParse(ctl?.text ?? '') ?? 0;

  void _safeSetText(TextEditingController? ctl, String value) {
    try {
      if (ctl != null) ctl.text = value;
    } catch (_) {}
  }

  void _disposeChildren() {
    for (final c in children) {
      try {
        c.dispose();
      } catch (_) {}
    }
    children.clear();
  }

  void _resetCampControllers() {
    for (final key in campControllers.keys) {
      try {
        campControllers[key]?.text = '0';
      } catch (_) {}
    }
  }

  // New: build payload in a dedicated method to simplify testing and readability
  Map<String, dynamic> _buildCreateTentPayload() {
    final childrenData = children
        .map((c) => {
              'full_name': c.name.text,
              'id': c.id.text,
              'age': _parseIntController(c.age),
            })
        .toList();

    return {
      'name': tentController.text,
      'mobile_number': phoneController.text,
      'id_number': idController.text,
      'capacity_expected': _parseIntController(peopleController),
      'occupants_male_adults': _parseIntController(campControllers['males']),
      'occupants_female_adults': _parseIntController(campControllers['females']),
      'occupants_children': _parseIntController(campControllers['children']),
      'occupants_special_needs': _parseIntController(campControllers['disabled']),
      'less_than_18': _parseIntController(campControllers['children_under_18']),
      'old_people': _parseIntController(campControllers['elderly']),
      'father_full_name': familyNameController.text,
      'father_id': familyIdController.text,
      'father_is_old': fatherIsOld,
      'father_age': _parseIntController(familyAgeController),
      'mother_full_name': wifeNameController.text,
      'mother_id': wifeIdController.text,
      'mother_is_old': motherIsOld,
      'mother_age': _parseIntController(wifeAgeController),
      'children_details': childrenData,
      'status': statusController.text.isEmpty ? 'other' : statusController.text,
      'notes': notesController.text.isEmpty ? null : notesController.text,
    };
  }

  // Fallback loader stub: original code referenced loadFamilies as a safe fallback.
  // Provide a minimal no-op implementation to keep behavior stable.
  Future<void> _loadFamiliesFallback() async {
    // Intentionally left blank — this is a lightweight fallback used in error paths.
    return;
  }

  // ---------------------- Public API ----------------------
  /// Add a child row
  void addChild() {
    // If we've used up all pre-created keys, create one more slot so the
    // UI can address the new child's fields. This avoids silently refusing
    // to add more children and keeps keys persistent across rebuilds.
    if (children.length >= childrenFieldKeys.length) {
      childrenFieldKeys.add({
        'name': GlobalKey<FormFieldState>(),
        'age': GlobalKey<FormFieldState>(),
        'id': GlobalKey<FormFieldState>(),
      });
    }
    children.add(ChildModel());
    // No state emit: UI reacts to controller lists.
  }

  /// Remove a child row and dispose its controllers
  void removeChild(int index) {
    if (index < 0 || index >= children.length) return;
    final removed = children.removeAt(index);
    removed.dispose();
  }

  /// Clear all form fields back to their defaults.
  /// Call this after a successful creation so the UI shows an empty form.
  void clearForm() {
    // Basic fields
    _safeSetText(tentController, '');
    _safeSetText(peopleController, '');
    _safeSetText(phoneController, '');
    _safeSetText(idController, '');

    // parents
    _safeSetText(familyNameController, '');
    _safeSetText(familyIdController, '');
    _safeSetText(familyAgeController, '');

    _safeSetText(wifeNameController, '');
    _safeSetText(wifeIdController, '');
    _safeSetText(wifeAgeController, '');

    // notes and status
    _safeSetText(notesController, '');
    _safeSetText(statusController, 'occupied');

    fatherIsOld = false;
    motherIsOld = false;

    // reset camp counters
    _resetCampControllers();

    // dispose and clear children, then create a fresh default child
    _disposeChildren();
    addChild();
  }

  /// Create a tent/family on the backend using values from the cubit's controllers.
  ///
  /// Returns the backend `status` string when present (for example 'occupied').
  /// On success emits [FamilySuccess]. On failure emits [FamilyError] and rethrows.
  Future<String> createTent(context,id) async {
    emit(const FamilyLoading());

    final payload = _buildCreateTentPayload();

    // Debug: print the exact payload JSON being sent
    try {
      debugPrint('createTent payload: ${jsonEncode(payload)}');
    } catch (_) {}

    try {
      final res = await HttpClient.post(ApiSettings.create_tents.replaceAll('id', id.toString()), data: payload);

      final respData = res.data;
      log('respData => => ${respData}');

      final statusCode = (res.statusCode ?? 0);
      if (statusCode >= 200 && statusCode < 300) {
        try {
          if (respData is Map && respData['data'] is Map) {
            final name = respData['data']['name'] ?? '';
            final campId = respData['data']['camp_id'] ?? '';
            showTopFloatingMessage(
                context,
                'تمت الإضافة: ${name.toString().isNotEmpty ? name : campId}',
                isError: false);
            clearForm();
            emit(FamilySuccess());
            // return backend status if present
            final backendStatus = respData['data']['status']?.toString() ?? '';
            return backendStatus;
          }
        } catch (_) {}

        // Fallback success message when body shape is unexpected
        showTopFloatingMessage(context, 'تمت الإضافة بنجاح', isError: false);
        clearForm();
        emit(FamilySuccess());
        return '';
      }

      // Non-successful HTTP status: attempt to extract message and throw
      String message = 'خطأ في الخادم (رمز: $statusCode)';
      try {
        if (respData is Map && respData['message'] != null) {
          message = respData['message'].toString();
        }
      } catch (_) {}

      emit(FamilyError(message: message));
      // call loadFamilies as fallback (preserve previous behavior)
      try {
        await _loadFamiliesFallback();
      } catch (_) {}
      throw Exception(message);
    } catch (e) {
      // If an exception occurs during the request, emit failure and rethrow
      final errMsg = e.toString();
      emit(FamilyError(message: errMsg));
      try {
        await _loadFamiliesFallback();
      } catch (_) {}
      rethrow;
    }
  }

  /// Populate cubit's controllers and children from a payload map.
  ///
  /// This is a convenience helper so you can prefill the form programmatically
  /// with the JSON structure you provided and then call [createTent()].
  void populateFromMap(Map<String, dynamic> m) {
    // basic fields
    _safeSetText(tentController, (m['name'] ?? '').toString());
    _safeSetText(phoneController, (m['mobile_number'] ?? '').toString());
    _safeSetText(idController, (m['id_number'] ?? '').toString());
    _safeSetText(peopleController, m['capacity_expected']?.toString() ?? '');

    // camp counts
    _safeSetText(campControllers['males'],
        m['occupants_male_adults']?.toString() ?? '0');
    _safeSetText(campControllers['females'],
        m['occupants_female_adults']?.toString() ?? '0');
    _safeSetText(
        campControllers['children'], m['occupants_children']?.toString() ?? '0');
    _safeSetText(campControllers['disabled'],
        m['occupants_special_needs']?.toString() ?? '0');
    _safeSetText(campControllers['children_under_18'],
        m['less_than_18']?.toString() ?? '0');
    _safeSetText(
        campControllers['elderly'], m['old_people']?.toString() ?? '0');

    // father
    _safeSetText(familyNameController, (m['father_full_name'] ?? '').toString());
    _safeSetText(familyIdController, (m['father_id'] ?? '').toString());
    _safeSetText(familyAgeController, m['father_age']?.toString() ?? '');
    fatherIsOld = (m['father_is_old'] ?? false) == true;

    // mother
    _safeSetText(wifeNameController, (m['mother_full_name'] ?? '').toString());
    _safeSetText(wifeIdController, (m['mother_id'] ?? '').toString());
    _safeSetText(wifeAgeController, m['mother_age']?.toString() ?? '');
    motherIsOld = (m['mother_is_old'] ?? false) == true;

    // children_details
    try {
      _disposeChildren();
    } catch (_) {}

    if (m['children_details'] is Iterable) {
      for (final item in m['children_details']) {
        try {
          final c = ChildModel();
          c.name.text = (item['full_name'] ?? '').toString();
          c.id.text = (item['id'] ?? '').toString();
          c.age.text = (item['age']?.toString() ?? '0').toString();
          children.add(c);
        } catch (_) {}
      }
    }

    // Ensure we have enough field key slots for the loaded children
    while (childrenFieldKeys.length < children.length) {
      childrenFieldKeys.add({
        'name': GlobalKey<FormFieldState>(),
        'age': GlobalKey<FormFieldState>(),
        'id': GlobalKey<FormFieldState>(),
      });
    }

    // status and notes
    _safeSetText(statusController, (m['status'] ?? '').toString());
    _safeSetText(notesController, m['notes'] == null ? '' : (m['notes']).toString());

    // sync the computed children count to make the UI and controllers consistent
    try {
      _syncChildrenWithPeople();
    } catch (_) {}
  }

  @override
  Future<void> close() async {
    // dispose controllers
    try {
      // remove listeners registered on controllers
      try { peopleController.removeListener(_onPeopleControllerChanged); } catch (_) {}
       tentController.dispose();
       peopleController.dispose();
       phoneController.dispose();
       idController.dispose();

       familyNameController.dispose();
       familyIdController.dispose();
       familyAgeController.dispose();

       wifeNameController.dispose();
       wifeIdController.dispose();
       wifeAgeController.dispose();

       notesController.dispose();
       statusController.dispose();

       for (final c in campControllers.values) {
         c.dispose();
       }

       _disposeChildren();
       scrollController.dispose();
     } catch (_) {}

     return super.close();
  }

}
