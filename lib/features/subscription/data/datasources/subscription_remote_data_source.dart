import 'package:dio/dio.dart';
import '../../../../core/error/app_exceptions.dart';
import '../models/subscription_plan_model.dart';
import '../../../dashboard/data/models/dashboard_stats_model.dart';

abstract class SubscriptionRemoteDataSource {
  Future<List<SubscriptionPlanModel>> getSubscriptionPlans();
  Future<void> subscribe(String planId);
  Future<DashboardStatsModel> getSubscriptionStats();
}

class SubscriptionRemoteDataSourceImpl implements SubscriptionRemoteDataSource {
  final Dio dio;

  SubscriptionRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<SubscriptionPlanModel>> getSubscriptionPlans() async {
    try {
      final response = await dio.get('/subscriptions/plans');
      return (response.data as List)
          .map((item) => SubscriptionPlanModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> subscribe(String planId) async {
    try {
      await dio.post('/subscriptions/subscribe', data: {'planId': planId});
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<DashboardStatsModel> getSubscriptionStats() async {
    try {
      final response = await dio.get('/subscriptions/stats');
      return DashboardStatsModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
