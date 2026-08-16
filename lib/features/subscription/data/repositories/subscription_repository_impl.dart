import '../../domain/repositories/subscription_repository.dart';
import '../datasources/subscription_remote_data_source.dart';
import '../models/subscription_plan_model.dart';
import '../../../dashboard/data/models/dashboard_stats_model.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDataSource remoteDataSource;

  SubscriptionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<SubscriptionPlanModel>> getSubscriptionPlans() {
    return remoteDataSource.getSubscriptionPlans();
  }

  @override
  Future<void> subscribe(String planId) {
    return remoteDataSource.subscribe(planId);
  }

  @override
  Future<DashboardStatsModel> getSubscriptionStats() {
    return remoteDataSource.getSubscriptionStats();
  }
}
