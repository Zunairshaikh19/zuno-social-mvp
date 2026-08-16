import 'package:equatable/equatable.dart';

class SegmentModel extends Equatable {
  final String? id;
  final String name;
  final String niche;
  final bool autoPublish;
  final String postingFrequency;
  final String? personaPrompt;
  final String? referenceImageUrl;

  const SegmentModel({
    this.id,
    required this.name,
    required this.niche,
    this.autoPublish = false,
    this.postingFrequency = 'Daily',
    this.personaPrompt,
    this.referenceImageUrl,
  });

  factory SegmentModel.fromJson(Map<String, dynamic> json) {
    return SegmentModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      niche: json['niche'] as String,
      autoPublish: json['autoPublish'] as bool? ?? false,
      postingFrequency: json['postingFrequency'] as String? ?? 'Daily',
      personaPrompt: json['personaPrompt'] as String?,
      referenceImageUrl: json['referenceImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'niche': niche,
      'autoPublish': autoPublish,
      'postingFrequency': postingFrequency,
      if (personaPrompt != null) 'personaPrompt': personaPrompt,
      if (referenceImageUrl != null) 'referenceImageUrl': referenceImageUrl,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        niche,
        autoPublish,
        postingFrequency,
        personaPrompt,
        referenceImageUrl,
      ];

  SegmentModel copyWith({
    String? id,
    String? name,
    String? niche,
    bool? autoPublish,
    String? postingFrequency,
    String? personaPrompt,
    String? referenceImageUrl,
  }) {
    return SegmentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      niche: niche ?? this.niche,
      autoPublish: autoPublish ?? this.autoPublish,
      postingFrequency: postingFrequency ?? this.postingFrequency,
      personaPrompt: personaPrompt ?? this.personaPrompt,
      referenceImageUrl: referenceImageUrl ?? this.referenceImageUrl,
    );
  }
}
