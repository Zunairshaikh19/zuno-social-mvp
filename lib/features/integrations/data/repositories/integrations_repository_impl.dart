import 'package:zunosocial/features/integrations/data/datasources/integrations_remote_data_source.dart';
import 'package:zunosocial/features/integrations/data/models/connected_account_model.dart';
import 'package:zunosocial/features/integrations/domain/repositories/integrations_repository.dart';

class IntegrationsRepositoryImpl implements IntegrationsRepository {
  final IntegrationsRemoteDataSource remoteDataSource;

  IntegrationsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ConnectedAccountModel>> getConnectedAccounts(String segmentId) {
    return remoteDataSource.getConnectedAccounts(segmentId);
  }

  @override
  Future<void> connectAccount(String segmentId, String platform, String accessToken) {
    return remoteDataSource.connectAccount(segmentId, platform, accessToken);
  }

  @override
  Future<void> disconnectAccount(String accountId) {
    return remoteDataSource.disconnectAccount(accountId);
  }
}
