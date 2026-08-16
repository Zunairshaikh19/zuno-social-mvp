import 'package:dio/dio.dart';
import 'package:zunosocial/core/error/app_exceptions.dart';
import 'package:zunosocial/features/integrations/data/models/connected_account_model.dart';

abstract class IntegrationsRemoteDataSource {
  Future<List<ConnectedAccountModel>> getConnectedAccounts(String segmentId);
  Future<void> connectAccount(String segmentId, String platform, String accessToken);
  Future<void> disconnectAccount(String accountId);
}

class IntegrationsRemoteDataSourceImpl implements IntegrationsRemoteDataSource {
  final Dio dio;

  IntegrationsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ConnectedAccountModel>> getConnectedAccounts(String segmentId) async {
    try {
      final response = await dio.get('/integrations/$segmentId');
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => ConnectedAccountModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> connectAccount(String segmentId, String platform, String accessToken) async {
    try {
      await dio.post('/integrations/connect', data: {
        'segmentId': segmentId,
        'platform': platform,
        'accessToken': accessToken,
      });
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> disconnectAccount(String accountId) async {
    try {
      await dio.delete('/integrations/$accountId');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
