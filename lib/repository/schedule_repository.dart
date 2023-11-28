import 'dart:async';
import 'dart:io';

import 'package:week10_1109/model/schedule_model.dart';
import 'package:dio/dio.dart';

// 날짜 파라미터 값을 JSON형식으로 변환하는 코드

class ScheduleRepository {
  final _dio = Dio();
  final _targetUrl = 'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:3000/schedule';

  Future<List<ScheduleModel>> getSchedules ({
    required DateTime date,
  }) async {
      final resp = await _dio.get(
        _targetUrl,
        queryParameters: {
          'date':
          '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}',
        },
      );

      return resp.data.map<ScheduleModel>(
          (x) => ScheduleModel.fromJson(
            json: x,
          ),
      ).toList();
  }

  Future<String> createSchedule({
    required ScheduleModel schedule,
  }) async {
    final json = schedule.toJson(); // JSON으로 변환

    final resp = await _dio.post(_targetUrl, data: json);

    return resp.data?['id'];
  }

  Future<String> deleteSchedule({
    required String id,
  }) async {
    final resp = await _dio.delete(_targetUrl, data: {
      'id' : id,
    });

    return resp.data?['id'];
  }
}