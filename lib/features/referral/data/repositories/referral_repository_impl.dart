import '../../domain/repositories/referral_repository.dart';
import '../datasources/referral_remote_data_source.dart';
import '../models/referral_stats_model.dart';

class ReferralRepositoryImpl implements ReferralRepository {
  final ReferralRemoteDataSource remoteDataSource;

  ReferralRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ReferralStatsModel> getReferralStats() {
    return remoteDataSource.getReferralStats();
  }
}
