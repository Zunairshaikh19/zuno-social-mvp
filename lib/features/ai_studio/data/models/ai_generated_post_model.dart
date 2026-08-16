import 'package:equatable/equatable.dart';

class AiGeneratedPostModel extends Equatable {
  final String? segmentId;
  final String topic;
  final String caption;
  final List<String> hashtags;
  final String imageUrl;
  final String imagePrompt;
  final double characterConsistencyScore;
  final DateTime suggestedTime;

  const AiGeneratedPostModel({
    this.segmentId,
    required this.topic,
    required this.caption,
    required this.hashtags,
    required this.imageUrl,
    required this.imagePrompt,
    required this.characterConsistencyScore,
    required this.suggestedTime,
  });

  factory AiGeneratedPostModel.fromJson(Map<String, dynamic> json) {
    return AiGeneratedPostModel(
      segmentId: json['segmentId'] as String?,
      topic: (json['topic'] ?? '') as String,
      caption: (json['caption'] ?? '') as String,
      hashtags: List<String>.from(json['hashtags'] ?? []),
      imageUrl: (json['imageUrl'] ?? '') as String,
      imagePrompt: (json['imagePrompt'] ?? '') as String,
      characterConsistencyScore: (json['characterConsistencyScore'] as num? ?? 0.0).toDouble(),
      suggestedTime: DateTime.parse(json['suggestedTime'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'segmentId': segmentId,
      'topic': topic,
      'caption': caption,
      'hashtags': hashtags,
      'imageUrl': imageUrl,
      'imagePrompt': imagePrompt,
      'characterConsistencyScore': characterConsistencyScore,
      'suggestedTime': suggestedTime.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        segmentId,
        topic,
        caption,
        hashtags,
        imageUrl,
        imagePrompt,
        characterConsistencyScore,
        suggestedTime,
      ];

  AiGeneratedPostModel copyWith({
    String? segmentId,
    String? caption,
    List<String>? hashtags,
    String? imageUrl,
  }) {
    return AiGeneratedPostModel(
      segmentId: segmentId ?? this.segmentId,
      topic: topic,
      caption: caption ?? this.caption,
      hashtags: hashtags ?? this.hashtags,
      imageUrl: imageUrl ?? this.imageUrl,
      imagePrompt: imagePrompt,
      characterConsistencyScore: characterConsistencyScore,
      suggestedTime: suggestedTime,
    );
  }
}
