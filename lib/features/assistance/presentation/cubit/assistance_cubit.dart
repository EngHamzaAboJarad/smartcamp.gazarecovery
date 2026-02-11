import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'assistance_state.dart';
import '../../data/models/coming_helps_model.dart';
import 'package:smartcamp_gazarecovery/core/api_settings.dart';
import 'package:smartcamp_gazarecovery/core/http_client.dart';
import 'package:smartcamp_gazarecovery/core/prefs.dart';

class AssistanceCubit extends Cubit<AssistanceState> {
  AssistanceCubit() : super(const AssistanceInitial());

  ComingHelpsResponse? _lastResponse;
  final List<dynamic> _items = [];
  final List<HelpTypeCount> _aggregatedHelpTypes = [];
  int _totalTypes = 0;
  int _totalItems = 0;

  ComingHelpsResponse? get lastResponse => _lastResponse;
  List<dynamic> get items => _items;
  List<HelpTypeCount> get aggregatedHelpTypes => _aggregatedHelpTypes;
  int get totalTypes => _totalTypes;
  int get totalItems => _totalItems;

  void clearComingHelps() {
    _lastResponse = null;
    _items.clear();
    _aggregatedHelpTypes.clear();
    _totalTypes = 0;
    _totalItems = 0;
    emit(const AssistanceInitial());
  }

  Future<void> loadAssistance(String campId) async {
    emit(const AssistanceLoading());

    try {
      await _attachTokenIfExists();

      final baseUrl =
      ApiSettings.coming_helps.replaceAll('id', campId);

      final typeMap = <int, HelpTypeCount>{};
      int rawTypeEntries = 0;

      // -------- First Page --------
      final firstResp = await HttpClient.get(baseUrl);
      _ensureSuccess(firstResp);

      final firstModel =
      ComingHelpsResponse.fromJson(_body(firstResp));

      final lastPage =
          firstModel.data?.comingHelps?.meta?.lastPage ?? 1;

      _mergePage(firstModel, typeMap, (v) => rawTypeEntries += v);

      // -------- Remaining Pages (Parallel) --------
      if (lastPage > 1) {
        final futures = List.generate(
          lastPage - 1,
              (i) => HttpClient.get(
            baseUrl,
            queryParameters: {'page': i + 2},
          ),
        );

        final responses = await Future.wait(futures);

        for (final resp in responses) {
          if (_isSuccess(resp)) {
            final model =
            ComingHelpsResponse.fromJson(_body(resp));
            _mergePage(model, typeMap, (v) => rawTypeEntries += v);
          }
        }
      }

      // -------- Final Aggregation --------
      _aggregatedHelpTypes
        ..clear()
        ..addAll(typeMap.values);

      _totalTypes = rawTypeEntries;
      _totalItems = _aggregatedHelpTypes.fold(
        0,
            (sum, e) => sum + e.count,
      );

      _lastResponse = ComingHelpsResponse(
        message: firstModel.message,
        data: ComingHelpsData(
          comingHelps: ComingHelpsList(
            data: _items,
            links: firstModel.data?.comingHelps?.links,
            meta: firstModel.data?.comingHelps?.meta,
          ),
          helpTypeCounts: _aggregatedHelpTypes,
        ),
      );

      emit(AssistanceLoaded(
        items: _items,
        helpTypeCounts: _aggregatedHelpTypes,
        totalTypes: _totalTypes,
        totalItems: _totalItems,
      ));
    } on DioException catch (e) {
      emit(AssistanceError(message: _dioMessage(e)));
    } catch (e) {
      emit(AssistanceError(message: e.toString()));
    }
  }

  // =================== Helpers ===================

  Future<void> _attachTokenIfExists() async {
    final user = await Prefs.getUser();
    if (user?.token?.isNotEmpty == true) {
      HttpClient.setAuthToken(user!.token);
    }
  }

  void _mergePage(
      ComingHelpsResponse model,
      Map<int, HelpTypeCount> typeMap,
      Function(int) onTypeCountAdded,
      ) {
    final pageItems = model.data?.comingHelps?.data ?? [];
    _items.addAll(pageItems);

    final helpTypes = model.data?.helpTypeCounts ?? [];
    onTypeCountAdded(helpTypes.length);

    for (final ht in helpTypes) {
      if (ht.id == null) continue;

      typeMap.update(
        ht.id!,
            (existing) => existing..count += ht.count,
        ifAbsent: () => HelpTypeCount(
          id: ht.id,
          name: ht.name,
          nameEn: ht.nameEn,
          nameAr: ht.nameAr,
          icon: ht.icon,
          count: ht.count,
        ),
      );
    }
  }

  bool _isSuccess(Response r) =>
      r.statusCode != null &&
          r.statusCode! >= 200 &&
          r.statusCode! < 300;

  void _ensureSuccess(Response r) {
    if (!_isSuccess(r)) {
      throw DioException(
        requestOptions: r.requestOptions,
        response: r,
      );
    }
  }

  Map<String, dynamic> _body(Response r) =>
      r.data is Map
          ? Map<String, dynamic>.from(r.data)
          : {};

  String _dioMessage(DioException e) {
    if (e.response?.data is Map &&
        e.response!.data['message'] != null) {
      return e.response!.data['message'].toString();
    }
    return e.message ?? 'خطأ في الشبكة';
  }
}
