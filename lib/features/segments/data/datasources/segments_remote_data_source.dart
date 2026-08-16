import 'package:dio/dio.dart';
import '../../../../core/error/app_exceptions.dart';
import '../models/segment_model.dart';

abstract class SegmentsRemoteDataSource {
  Future<SegmentModel> createSegment(SegmentModel segment);
  Future<List<SegmentModel>> getSegments();
  Future<SegmentModel> getSegmentById(String id);
  Future<SegmentModel> updateSegment(SegmentModel segment);
  Future<void> deleteSegment(String id);
}

class SegmentsRemoteDataSourceImpl implements SegmentsRemoteDataSource {
  final Dio dio;

  SegmentsRemoteDataSourceImpl({required this.dio});

  @override
  Future<SegmentModel> createSegment(SegmentModel segment) async {
    try {
      final response = await dio.post('/segments', data: segment.toJson());
      return SegmentModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<List<SegmentModel>> getSegments() async {
    try {
      final response = await dio.get('/segments');
      return (response.data as List)
          .map((item) => SegmentModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<SegmentModel> getSegmentById(String id) async {
    try {
      final response = await dio.get('/segments/$id');
      return SegmentModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<SegmentModel> updateSegment(SegmentModel segment) async {
    try {
      final response = await dio.patch('/segments/${segment.id}', data: segment.toJson());
      return SegmentModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  @override
  Future<void> deleteSegment(String id) async {
    try {
      await dio.delete('/segments/$id');
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
