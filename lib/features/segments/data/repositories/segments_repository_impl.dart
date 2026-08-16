import '../../domain/repositories/segments_repository.dart';
import '../datasources/segments_remote_data_source.dart';
import '../models/segment_model.dart';

class SegmentsRepositoryImpl implements SegmentsRepository {
  final SegmentsRemoteDataSource remoteDataSource;

  SegmentsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SegmentModel> createSegment(SegmentModel segment) {
    return remoteDataSource.createSegment(segment);
  }

  @override
  Future<List<SegmentModel>> getSegments() {
    return remoteDataSource.getSegments();
  }

  @override
  Future<SegmentModel> getSegmentById(String id) {
    return remoteDataSource.getSegmentById(id);
  }

  @override
  Future<SegmentModel> updateSegment(SegmentModel segment) {
    return remoteDataSource.updateSegment(segment);
  }

  @override
  Future<void> deleteSegment(String id) {
    return remoteDataSource.deleteSegment(id);
  }
}
