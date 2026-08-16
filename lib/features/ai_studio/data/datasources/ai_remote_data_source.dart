import 'package:dio/dio.dart';
import '../../../../core/error/app_exceptions.dart';
import '../models/ai_generated_post_model.dart';

abstract class AiRemoteDataSource {
  Future<AiGeneratedPostModel> generatePost({
    required String segmentId,
    required String promptTopic,
    required bool usePersonaReference,
  });

  Future<String> regenerateCaption(String currentPrompt);
  Future<String> regenerateImage(String referenceImageUrl, String style);
}

class AiRemoteDataSourceImpl implements AiRemoteDataSource {
  final Dio dio;

  AiRemoteDataSourceImpl({required this.dio});

  @override
  Future<AiGeneratedPostModel> generatePost({
    required String segmentId,
    required String promptTopic,
    required bool usePersonaReference,
  }) async {
    try {
      final response = await dio.post('/ai/generate-post', data: {
        'segmentId': segmentId,
        'topic': promptTopic,
        'usePersona': usePersonaReference,
      });
      return AiGeneratedPostModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<String> regenerateCaption(String currentPrompt) async {
    try {
      final response = await dio.post('/ai/regenerate-caption', data: {
        'prompt': currentPrompt,
      });
      return response.data['caption'] as String;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<String> regenerateImage(String referenceImageUrl, String style) async {
    try {
      final response = await dio.post('/ai/regenerate-image', data: {
        'referenceImageUrl': referenceImageUrl,
        'style': style,
      });
      return response.data['imageUrl'] as String;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
