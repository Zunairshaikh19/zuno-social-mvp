import '../../data/models/segment_model.dart';

abstract class SegmentsRepository {
  Future<SegmentModel> createSegment(SegmentModel segment);
  Future<List<SegmentModel>> getSegments();
  Future<SegmentModel> getSegmentById(String id);
  Future<SegmentModel> updateSegment(SegmentModel segment);
  Future<void> deleteSegment(String id);
}
