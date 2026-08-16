import 'package:dio/dio.dart';
import '../../../../core/error/app_exceptions.dart';
import '../models/post_item_model.dart';

abstract class QueueRemoteDataSource {
  Future<PostItemModel> schedulePost(PostItemModel post);
  Future<void> publishNow(String id);
  Future<List<PostItemModel>> getQueue();
  Future<void> deletePost(String id);
  Future<PostItemModel> updatePost(PostItemModel post);
}

class QueueRemoteDataSourceImpl implements QueueRemoteDataSource {
  final Dio dio;

  QueueRemoteDataSourceImpl({required this.dio});

  @override
  Future<PostItemModel> schedulePost(PostItemModel post) async {
    try {
      final response = await dio.post('/queue/schedule', data: post.toJson());
      return PostItemModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> publishNow(String id) async {
    try {
      await dio.post('/queue/publish-now/$id');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<List<PostItemModel>> getQueue() async {
    try {
      final response = await dio.get('/queue');
      return (response.data as List)
          .map((item) => PostItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> deletePost(String id) async {
    try {
      await dio.delete('/queue/$id');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<PostItemModel> updatePost(PostItemModel post) async {
    try {
      final response = await dio.patch('/queue/${post.id}', data: post.toJson());
      return PostItemModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
