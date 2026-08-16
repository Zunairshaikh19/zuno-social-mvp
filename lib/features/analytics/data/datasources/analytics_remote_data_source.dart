import 'package:dio/dio.dart';
import 'package:zunosocial/core/error/app_exceptions.dart';
import '../models/analytics_overview_model.dart';

abstract class AnalyticsRemoteDataSource {
  Future<AnalyticsOverviewModel> getAnalytics({
    required String segmentId,
    required String timeframe,
  });
}

class AnalyticsRemoteDataSourceImpl implements AnalyticsRemoteDataSource {
  final Dio dio;

  AnalyticsRemoteDataSourceImpl({required this.dio});

  @override
  Future<AnalyticsOverviewModel> getAnalytics({
    required String segmentId,
    required String timeframe,
  }) async {
    try {
      final response = await dio.get('/subscriptions/stats', queryParameters: {
        'segmentId': segmentId,
        'timeframe': timeframe,
      });
      return AnalyticsOverviewModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
