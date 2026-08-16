import '../../data/models/post_item_model.dart';

abstract class QueueRepository {
  Future<PostItemModel> schedulePost(PostItemModel post);
  Future<void> publishNow(String id);
  Future<List<PostItemModel>> getQueue();
  Future<void> deletePost(String id);
  Future<PostItemModel> updatePost(PostItemModel post);
}
