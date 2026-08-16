import 'package:zunosocial/features/integrations/data/models/connected_account_model.dart';

abstract class IntegrationsRepository {
  Future<List<ConnectedAccountModel>> getConnectedAccounts(String segmentId);
  Future<void> connectAccount(String segmentId, String platform, String accessToken);
  Future<void> disconnectAccount(String accountId);
}
