import 'package:equatable/equatable.dart';

class SubscriptionPlanModel extends Equatable {
  final String id;
  final String name;
  final double priceMonthly;
  final int postsPerMonth;
  final int segmentLimit;
  final List<String> features;
  final bool isPopularBadge;

  const SubscriptionPlanModel({
    required this.id,
    required this.name,
    required this.priceMonthly,
    required this.postsPerMonth,
    required this.segmentLimit,
    required this.features,
    this.isPopularBadge = false,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      id: json['id'] as String,
      name: json['name'] as String,
      priceMonthly: json['priceMonthly'] is String 
          ? double.parse(json['priceMonthly'] as String)
          : (json['priceMonthly'] as num).toDouble(),
      postsPerMonth: json['postsPerMonth'] as int,
      segmentLimit: json['segmentLimit'] as int,
      features: (json['features'] as List<dynamic>).map((e) => e as String).toList(),
      isPopularBadge: json['isPopularBadge'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'priceMonthly': priceMonthly,
      'postsPerMonth': postsPerMonth,
      'segmentLimit': segmentLimit,
      'features': features,
      'isPopularBadge': isPopularBadge,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        priceMonthly,
        postsPerMonth,
        segmentLimit,
        features,
        isPopularBadge,
      ];

  static List<SubscriptionPlanModel> get mockPlans => [
        const SubscriptionPlanModel(
          id: 'starter',
          name: 'Starter',
          priceMonthly: 19.0,
          postsPerMonth: 16,
          segmentLimit: 1,
          features: [
            '1 Segment / Persona',
            '16 auto-posts / month',
            'Meta OAuth Integration',
            'Basic Analytics',
          ],
        ),
        const SubscriptionPlanModel(
          id: 'pro',
          name: 'Pro',
          priceMonthly: 35.0,
          postsPerMonth: 30,
          segmentLimit: 2,
          isPopularBadge: true,
          features: [
            '2 Segments / Personas',
            '30 auto-posts / month',
            'Highest Priority Gemini generation',
            'Full Analytics Suite',
            'AI Image Variations',
          ],
        ),
      ];
}
