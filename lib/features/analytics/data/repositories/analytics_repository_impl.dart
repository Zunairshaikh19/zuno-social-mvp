import '../../domain/repositories/analytics_repository.dart';
import '../datasources/analytics_remote_data_source.dart';
import '../models/analytics_overview_model.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final AnalyticsRemoteDataSource remoteDataSource;

  AnalyticsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AnalyticsOverviewModel> getAnalytics({
    required String segmentId,
    required String timeframe,
  }) {
    return remoteDataSource.getAnalytics(segmentId: segmentId, timeframe: timeframe);
  }
}
