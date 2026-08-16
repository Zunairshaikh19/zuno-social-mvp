import '../../data/models/subscription_plan_model.dart';
import '../../../dashboard/data/models/dashboard_stats_model.dart';

abstract class SubscriptionRepository {
  Future<List<SubscriptionPlanModel>> getSubscriptionPlans();
  Future<void> subscribe(String planId);
  Future<DashboardStatsModel> getSubscriptionStats();
}
