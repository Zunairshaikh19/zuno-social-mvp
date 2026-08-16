import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zunosocial/features/queue/data/models/post_item_model.dart';
import 'package:zunosocial/features/queue/domain/repositories/queue_repository.dart';

// --- Events ---
abstract class QueueEvent extends Equatable {
  const QueueEvent();
  @override
  List<Object?> get props => [];
}

class LoadQueuePosts extends QueueEvent {}

class FilterPostsByStatus extends QueueEvent {
  final PostStatus? status;
  const FilterPostsByStatus(this.status);
  @override
  List<Object?> get props => [status];
}

class FilterPostsByDate extends QueueEvent {
  final DateTime date;
  const FilterPostsByDate(this.date);
  @override
  List<Object?> get props => [date];
}

class PublishPostNow extends QueueEvent {
  final String postId;
  const PublishPostNow(this.postId);
  @override
  List<Object?> get props => [postId];
}

class DeletePost extends QueueEvent {
  final String postId;
  const DeletePost(this.postId);
  @override
  List<Object?> get props => [postId];
}

class UpdatePostContent extends QueueEvent {
  final String postId;
  final String caption;
  final List<String> hashtags;
  const UpdatePostContent({
    required this.postId,
    required this.caption,
    required this.hashtags,
  });
  @override
  List<Object?> get props => [postId, caption, hashtags];
}

class ReschedulePost extends QueueEvent {
  final String postId;
  final DateTime newDate;
  const ReschedulePost(this.postId, this.newDate);
  @override
  List<Object?> get props => [postId, newDate];
}

// --- States ---
abstract class QueueState extends Equatable {
  const QueueState();
  @override
  List<Object?> get props => [];
}

class QueueInitial extends QueueState {}
class QueueLoading extends QueueState {}
class QueueLoaded extends QueueState {
  final List<PostItemModel> posts;
  final PostStatus? selectedFilter;
  final DateTime selectedDate;

  const QueueLoaded({
    required this.posts,
    this.selectedFilter,
    required this.selectedDate,
  });

  @override
  List<Object?> get props => [posts, selectedFilter, selectedDate];

  QueueLoaded copyWith({
    List<PostItemModel>? posts,
    PostStatus? selectedFilter,
    DateTime? selectedDate,
  }) {
    return QueueLoaded(
      posts: posts ?? this.posts,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}

class QueueActionSuccess extends QueueState {
  final String message;
  const QueueActionSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class QueueError extends QueueState {
  final String message;
  const QueueError(this.message);
  @override
  List<Object?> get props => [message];
}

// --- Bloc ---
class QueueBloc extends Bloc<QueueEvent, QueueState> {
  final QueueRepository queueRepository;

  QueueBloc({required this.queueRepository}) : super(QueueInitial()) {
    on<LoadQueuePosts>(_onLoadQueuePosts);
    on<FilterPostsByStatus>(_onFilterPostsByStatus);
    on<FilterPostsByDate>(_onFilterPostsByDate);
    on<PublishPostNow>(_onPublishPostNow);
    on<DeletePost>(_onDeletePost);
    on<UpdatePostContent>(_onUpdatePostContent);
    on<ReschedulePost>(_onReschedulePost);
  }

  Future<void> _onLoadQueuePosts(LoadQueuePosts event, Emitter<QueueState> emit) async {
    emit(QueueLoading());
    try {
      final posts = await queueRepository.getQueue();
      emit(QueueLoaded(
        posts: posts,
        selectedDate: DateTime.now(),
      ));
    } catch (e) {
      emit(QueueError(e.toString()));
    }
  }

  void _onFilterPostsByStatus(FilterPostsByStatus event, Emitter<QueueState> emit) {
    if (state is QueueLoaded) {
      final currentState = state as QueueLoaded;
      emit(currentState.copyWith(selectedFilter: event.status));
    }
  }

  void _onFilterPostsByDate(FilterPostsByDate event, Emitter<QueueState> emit) {
    if (state is QueueLoaded) {
      final currentState = state as QueueLoaded;
      emit(currentState.copyWith(selectedDate: event.date));
    }
  }

  Future<void> _onPublishPostNow(PublishPostNow event, Emitter<QueueState> emit) async {
    if (state is QueueLoaded) {
      final currentState = state as QueueLoaded;
      emit(QueueLoading());
      try {
        await queueRepository.publishNow(event.postId);
        final updatedPosts = currentState.posts.map((p) {
          if (p.id == event.postId) {
            return p.copyWith(status: PostStatus.published, publishedAt: DateTime.now());
          }
          return p;
        }).toList();
        
        emit(const QueueActionSuccess('Post published successfully!'));
        emit(currentState.copyWith(posts: List<PostItemModel>.from(updatedPosts)));
      } catch (e) {
        emit(QueueError(e.toString()));
        emit(currentState);
      }
    }
  }

  Future<void> _onDeletePost(DeletePost event, Emitter<QueueState> emit) async {
    if (state is QueueLoaded) {
      final currentState = state as QueueLoaded;
      emit(QueueLoading());
      try {
        await queueRepository.deletePost(event.postId);
        final updatedPosts = currentState.posts.where((p) => p.id != event.postId).toList();
        emit(const QueueActionSuccess('Post deleted'));
        emit(currentState.copyWith(posts: updatedPosts));
      } catch (e) {
        emit(QueueError(e.toString()));
        emit(currentState);
      }
    }
  }

  void _onUpdatePostContent(UpdatePostContent event, Emitter<QueueState> emit) async {
    if (state is QueueLoaded) {
      final currentState = state as QueueLoaded;
      final postToUpdate = currentState.posts.firstWhere((p) => p.id == event.postId);
      final updatedPost = postToUpdate.copyWith(caption: event.caption, hashtags: event.hashtags);
      
      emit(QueueLoading());
      try {
        await queueRepository.updatePost(updatedPost);
        final updatedPosts = currentState.posts.map((p) {
          return p.id == event.postId ? updatedPost : p;
        }).toList();
        emit(currentState.copyWith(posts: List<PostItemModel>.from(updatedPosts)));
      } catch (e) {
        emit(QueueError(e.toString()));
        emit(currentState);
      }
    }
  }

  Future<void> _onReschedulePost(ReschedulePost event, Emitter<QueueState> emit) async {
    if (state is QueueLoaded) {
      final currentState = state as QueueLoaded;
      final postToUpdate = currentState.posts.firstWhere((p) => p.id == event.postId);
      final updatedPost = postToUpdate.copyWith(scheduledFor: event.newDate);

      emit(QueueLoading());
      try {
        await queueRepository.updatePost(updatedPost);
        final updatedPosts = currentState.posts.map((p) {
          return p.id == event.postId ? updatedPost : p;
        }).toList();
        
        emit(const QueueActionSuccess('Post rescheduled successfully'));
        emit(currentState.copyWith(posts: List<PostItemModel>.from(updatedPosts)));
      } catch (e) {
        emit(QueueError(e.toString()));
        emit(currentState);
      }
    }
  }
}
