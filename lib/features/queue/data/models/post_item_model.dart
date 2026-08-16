import 'package:equatable/equatable.dart';

enum PostStatus { draft, scheduled, published, failed }

class PostItemModel extends Equatable {
  final String id;
  final String segmentId;
  final String topic;
  final String caption;
  final List<String> hashtags;
  final String mediaUrl;
  final PostStatus status;
  final DateTime scheduledFor;
  final DateTime? publishedAt;

  const PostItemModel({
    required this.id,
    required this.segmentId,
    required this.topic,
    required this.caption,
    required this.hashtags,
    required this.mediaUrl,
    required this.status,
    required this.scheduledFor,
    this.publishedAt,
  });

  factory PostItemModel.fromJson(Map<String, dynamic> json) {
    return PostItemModel(
      id: json['id'] as String,
      segmentId: json['segmentId'] as String,
      topic: json['topic'] as String,
      caption: json['caption'] as String,
      hashtags: (json['hashtags'] as List<dynamic>).map((e) => e as String).toList(),
      mediaUrl: json['mediaUrl'] as String,
      status: PostStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PostStatus.draft,
      ),
      scheduledFor: DateTime.parse(json['scheduledFor'] as String),
      publishedAt: json['publishedAt'] != null ? DateTime.parse(json['publishedAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'segmentId': segmentId,
      'topic': topic,
      'caption': caption,
      'hashtags': hashtags,
      'mediaUrl': mediaUrl,
      'status': status.name,
      'scheduledFor': scheduledFor.toIso8601String(),
      if (publishedAt != null) 'publishedAt': publishedAt!.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        segmentId,
        topic,
        caption,
        hashtags,
        mediaUrl,
        status,
        scheduledFor,
        publishedAt,
      ];

  PostItemModel copyWith({
    String? caption,
    List<String>? hashtags,
    PostStatus? status,
    DateTime? scheduledFor,
    DateTime? publishedAt,
  }) {
    return PostItemModel(
      id: id,
      segmentId: segmentId,
      topic: topic,
      caption: caption ?? this.caption,
      hashtags: hashtags ?? this.hashtags,
      mediaUrl: mediaUrl,
      status: status ?? this.status,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }

  factory PostItemModel.mock({required String id, required PostStatus status, required DateTime scheduledFor}) {
    return PostItemModel(
      id: id,
      segmentId: 'seg_1',
      topic: 'Cyberpunk Aesthetic',
      caption: 'The future is now. Exploring the neon streets of Neo-Tokyo. #cyberpunk #future #ai',
      hashtags: const ['cyberpunk', 'future', 'ai', 'neon', 'tokyo'],
      mediaUrl: 'https://images.unsplash.com/photo-1614728263952-84ea256f9679',
      status: status,
      scheduledFor: scheduledFor,
    );
  }
}
