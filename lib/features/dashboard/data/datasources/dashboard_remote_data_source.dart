import 'package:dio/dio.dart';
import 'package:zunosocial/core/error/app_exceptions.dart';
import '../models/dashboard_stats_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardStatsModel> getDashboardStats({String? segmentId});
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio;

  DashboardRemoteDataSourceImpl({required this.dio});

  @override
  Future<DashboardStatsModel> getDashboardStats({String? segmentId}) async {
    try {
      final response = await dio.get('/subscriptions/stats', queryParameters: {
        if (segmentId != null) 'segmentId': segmentId,
      });
      return DashboardStatsModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
