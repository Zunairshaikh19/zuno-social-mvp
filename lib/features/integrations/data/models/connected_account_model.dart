import 'package:equatable/equatable.dart';

class ConnectedAccountModel extends Equatable {
  final String id;
  final String segmentId;
  final String platform;
  final String accountName;
  final String? accountAvatarUrl;
  final bool isConnected;
  final DateTime? tokenExpiresAt;
  final List<String> scopes;

  const ConnectedAccountModel({
    required this.id,
    required this.segmentId,
    required this.platform,
    required this.accountName,
    this.accountAvatarUrl,
    required this.isConnected,
    this.tokenExpiresAt,
    required this.scopes,
  });

  @override
  List<Object?> get props => [
        id,
        segmentId,
        platform,
        accountName,
        accountAvatarUrl,
        isConnected,
        tokenExpiresAt,
        scopes,
      ];

  factory ConnectedAccountModel.fromJson(Map<String, dynamic> json) {
    return ConnectedAccountModel(
      id: json['id'] as String,
      segmentId: json['segmentId'] as String,
      platform: json['platform'] as String,
      accountName: json['accountName'] as String,
      accountAvatarUrl: json['accountAvatarUrl'] as String?,
      isConnected: json['isConnected'] as bool? ?? false,
      tokenExpiresAt: json['tokenExpiresAt'] != null 
          ? DateTime.parse(json['tokenExpiresAt'] as String) 
          : null,
      scopes: (json['scopes'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );
  }

  factory ConnectedAccountModel.mock() {
    return ConnectedAccountModel(
      id: 'acc_1',
      segmentId: 'seg_1',
      platform: 'Instagram',
      accountName: '@cyber_influencer_alpha',
      accountAvatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
      isConnected: true,
      tokenExpiresAt: DateTime.now().add(const Duration(days: 45)),
      scopes: const ['instagram_content_publish', 'pages_manage_posts', 'instagram_basic'],
    );
  }
}
