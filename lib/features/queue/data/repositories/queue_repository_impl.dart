import '../../domain/repositories/queue_repository.dart';
import '../datasources/queue_remote_data_source.dart';
import '../models/post_item_model.dart';

class QueueRepositoryImpl implements QueueRepository {
  final QueueRemoteDataSource remoteDataSource;

  QueueRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PostItemModel> schedulePost(PostItemModel post) {
    return remoteDataSource.schedulePost(post);
  }

  @override
  Future<void> publishNow(String id) {
    return remoteDataSource.publishNow(id);
  }

  @override
  Future<List<PostItemModel>> getQueue() {
    return remoteDataSource.getQueue();
  }

  @override
  Future<void> deletePost(String id) {
    return remoteDataSource.deletePost(id);
  }

  @override
  Future<PostItemModel> updatePost(PostItemModel post) {
    return remoteDataSource.updatePost(post);
  }
}
