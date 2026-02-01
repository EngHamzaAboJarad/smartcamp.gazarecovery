import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    // start with one child row by default
    addChild();
  }

  Future<void> loadFamilies() async {
    emit(const FamilyLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(const FamilyLoaded(families: [
        {'id': 'f1', 'name': 'Family A'},
        {'id': 'f2', 'name': 'Family B'},
      ]));
    } catch (e) {
      emit(FamilyError(message: e.toString()));
    }
  }

  /// Add a child row
  void addChild() {
    children.add(ChildModel());
    // We don't emit a special FamilyState here because the UI listens to cubit's controllers/list directly.
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
    try {
      tentController.text = '';
      peopleController.text = '';
      phoneController.text = '';
      idController.text = '';

      familyNameController.text = '';
      familyIdController.text = '';
      familyAgeController.text = '';

      wifeNameController.text = '';
      wifeIdController.text = '';
      wifeAgeController.text = '';

      notesController.text = '';
      statusController.text = 'occupied';

      fatherIsOld = false;
      motherIsOld = false;

      for (final key in campControllers.keys) {
        campControllers[key]?.text = '0';
      }

      // dispose and clear children
      for (final c in children) {
        c.dispose();
      }
      children.clear();
      // Start with one empty child row by default
      addChild();
    } catch (_) {}
  }

  /// Create a tent/family on the backend using values from the cubit's controllers.
  ///
  /// Returns the backend `status` string when present (for example 'occupied').
  /// If the backend response is non-success or an exception occurs, this method
  /// will call [loadFamilies] as a fallback and rethrow the error to the caller.
  Future<void> createTent(context) async {
    // Build payload from the cubit's controllers
    final childrenData = children
        .map((c) => {
              'full_name': c.name.text,
              'id': c.id.text,
              'age': int.tryParse(c.age.text) ?? 0,
            })
        .toList();

    int parseInt(TextEditingController? ctl) =>
        int.tryParse(ctl?.text ?? '') ?? 0;

    final payload = {
      'name': tentController.text,
      'mobile_number': phoneController.text,
      'id_number': idController.text,
      'capacity_expected': parseInt(peopleController),
      'occupants_male_adults': parseInt(campControllers['males']),
      'occupants_female_adults': parseInt(campControllers['females']),
      'occupants_children': parseInt(campControllers['children']),
      'occupants_special_needs': parseInt(campControllers['disabled']),
      'less_than_18': parseInt(campControllers['children_under_18']),
      'old_people': parseInt(campControllers['elderly']),
      'father_full_name': familyNameController.text,
      'father_id': familyIdController.text,
      'father_is_old': fatherIsOld,
      'father_age': parseInt(familyAgeController),
      'mother_full_name': wifeNameController.text,
      'mother_id': wifeIdController.text,
      'mother_is_old': motherIsOld,
      'mother_age': parseInt(wifeAgeController),
      'children_details': childrenData,
      'status': statusController.text.isEmpty ? 'other' : statusController.text,
      'notes': notesController.text.isEmpty ? null : notesController.text,
    };

    // Debug: print the exact payload JSON being sent
    try {
      debugPrint('createTent payload: ${jsonEncode(payload)}');
    } catch (_) {}

    try {
      final res =
          await HttpClient.post(ApiSettings.create_tents, data: payload);

      final respData = res.data;
      log('respData => => ${respData}');

      // If server responded with a 2xx status treat it as success and show a message
      final statusCode = (res.statusCode ?? 0);
      if (statusCode >= 200 && statusCode < 300) {
        try {
          if (respData is Map && respData['data'] is Map) {
            final name = respData['data']['name'] ?? '';
            final campId = respData['data']['camp_id'] ?? '';
            showTopFloatingMessage(context,
                'تمت الإضافة: ${name.toString().isNotEmpty ? name : campId}',
                isError: false);
            clearForm();
            emit(FamilySuccess());
            return;
          }
        } catch (_) {}

        // Fallback success message when body shape is unexpected
        showTopFloatingMessage(context, 'تمت الإضافة بنجاح', isError: false);
        clearForm();
        emit(FamilySuccess());
        return;
      }

      // previous behavior: if respData['data'] was a map we already handled it above

    } catch (e) {
      try {
        await loadFamilies();
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
    tentController.text = (m['name'] ?? '') as String;
    phoneController.text = (m['mobile_number'] ?? '') as String;
    idController.text = (m['id_number'] ?? '') as String;
    peopleController.text = m['capacity_expected']?.toString() ?? '';

    // camp counts
    campControllers['males']?.text =
        m['occupants_male_adults']?.toString() ?? '0';
    campControllers['females']?.text =
        m['occupants_female_adults']?.toString() ?? '0';
    campControllers['children']?.text =
        m['occupants_children']?.toString() ?? '0';
    campControllers['disabled']?.text =
        m['occupants_special_needs']?.toString() ?? '0';
    campControllers['children_under_18']?.text =
        m['less_than_18']?.toString() ?? '0';
    campControllers['elderly']?.text = m['old_people']?.toString() ?? '0';

    // father
    familyNameController.text = (m['father_full_name'] ?? '') as String;
    familyIdController.text = (m['father_id'] ?? '') as String;
    familyAgeController.text = m['father_age']?.toString() ?? '';
    fatherIsOld = (m['father_is_old'] ?? false) as bool;

    // mother
    wifeNameController.text = (m['mother_full_name'] ?? '') as String;
    wifeIdController.text = (m['mother_id'] ?? '') as String;
    wifeAgeController.text = m['mother_age']?.toString() ?? '';
    motherIsOld = (m['mother_is_old'] ?? false) as bool;

    // children_details
    try {
      // dispose existing children controllers
      for (final c in children) {
        c.dispose();
      }
    } catch (_) {}
    children.clear();

    if (m['children_details'] is Iterable) {
      for (final item in m['children_details']) {
        try {
          final c = ChildModel();
          c.name.text = (item['full_name'] ?? '') as String;
          c.id.text = (item['id'] ?? '') as String;
          c.age.text = (item['age']?.toString() ?? '0') as String;
          children.add(c);
        } catch (_) {}
      }
    }

    // status and notes
    statusController.text = (m['status'] ?? '') as String;
    notesController.text = m['notes'] == null ? '' : (m['notes'] as String);
  }

  @override
  Future<void> close() async {
    // dispose controllers
    try {
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

      for (final child in children) {
        child.dispose();
      }
    } catch (_) {}

    return super.close();
  }
}
