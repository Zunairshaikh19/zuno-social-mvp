import '../../data/models/referral_stats_model.dart';

abstract class ReferralRepository {
  Future<ReferralStatsModel> getReferralStats();
}
