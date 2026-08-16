import 'package:dio/dio.dart';
import '../../../../core/error/app_exceptions.dart';
import '../models/referral_stats_model.dart';

abstract class ReferralRemoteDataSource {
  Future<ReferralStatsModel> getReferralStats();
}

class ReferralRemoteDataSourceImpl implements ReferralRemoteDataSource {
  final Dio dio;

  ReferralRemoteDataSourceImpl({required this.dio});

  @override
  Future<ReferralStatsModel> getReferralStats() async {
    try {
      final response = await dio.get('/referral/stats');
      return ReferralStatsModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
