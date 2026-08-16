import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zunosocial/features/ai_studio/data/models/ai_generated_post_model.dart';
import 'package:zunosocial/features/ai_studio/data/datasources/ai_remote_data_source.dart';
import 'package:zunosocial/features/queue/domain/repositories/queue_repository.dart';
import 'package:zunosocial/features/queue/data/models/post_item_model.dart';
import 'package:zunosocial/features/segments/domain/repositories/segments_repository.dart';
import 'package:zunosocial/features/segments/data/models/segment_model.dart';

// --- Events ---
abstract class AiStudioEvent extends Equatable {
  const AiStudioEvent();
  @override
  List<Object?> get props => [];
}

class LoadAiStudioData extends AiStudioEvent {}

class GenerateInstantPostRequested extends AiStudioEvent {
  final String segmentId;
  final String promptTopic;
  final bool usePersonaReference;

  const GenerateInstantPostRequested({
    required this.segmentId,
    required this.promptTopic,
    this.usePersonaReference = true,
  });

  @override
  List<Object?> get props => [segmentId, promptTopic, usePersonaReference];
}

class RegenerateCaptionOnly extends AiStudioEvent {
  final String currentPrompt;
  const RegenerateCaptionOnly(this.currentPrompt);
  @override
  List<Object?> get props => [currentPrompt];
}

class RegenerateImageOnly extends AiStudioEvent {
  final String referenceImageUrl;
  final String style;
  const RegenerateImageOnly({required this.referenceImageUrl, required this.style});
  @override
  List<Object?> get props => [referenceImageUrl, style];
}

class ScheduleGeneratedPost extends AiStudioEvent {
  final AiGeneratedPostModel post;
  final DateTime scheduleDate;
  const ScheduleGeneratedPost(this.post, this.scheduleDate);
  @override
  List<Object?> get props => [post, scheduleDate];
}

// --- States ---
abstract class AiStudioState extends Equatable {
  const AiStudioState();
  @override
  List<Object?> get props => [];
}

class AiStudioInitial extends AiStudioState {
  final List<SegmentModel> segments;
  const AiStudioInitial({this.segments = const []});
  @override
  List<Object?> get props => [segments];
}

class AiGeneratingText extends AiStudioState {}
class AiGeneratingImage extends AiStudioState {}
class AiGenerationSuccess extends AiStudioState {
  final AiGeneratedPostModel post;
  const AiGenerationSuccess(this.post);
  @override
  List<Object?> get props => [post];
}
class AiGenerationFailure extends AiStudioState {
  final String message;
  const AiGenerationFailure(this.message);
  @override
  List<Object?> get props => [message];
}
class AiActionSuccess extends AiStudioState {
  final String message;
  const AiActionSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

// --- Bloc ---
class AiStudioBloc extends Bloc<AiStudioEvent, AiStudioState> {
  final AiRemoteDataSource aiRemoteDataSource;
  final QueueRepository queueRepository;
  final SegmentsRepository segmentsRepository;

  AiStudioBloc({
    required this.aiRemoteDataSource,
    required this.queueRepository,
    required this.segmentsRepository,
  }) : super(const AiStudioInitial()) {
    on<LoadAiStudioData>(_onLoadAiStudioData);
    on<GenerateInstantPostRequested>(_onGenerateInstantPostRequested);
    on<RegenerateCaptionOnly>(_onRegenerateCaptionOnly);
    on<RegenerateImageOnly>(_onRegenerateImageOnly);
    on<ScheduleGeneratedPost>(_onScheduleGeneratedPost);
  }

  Future<void> _onLoadAiStudioData(LoadAiStudioData event, Emitter<AiStudioState> emit) async {
    try {
      final segments = await segmentsRepository.getSegments();
      emit(AiStudioInitial(segments: segments));
    } catch (e) {
      emit(AiGenerationFailure(e.toString()));
    }
  }

  Future<void> _onGenerateInstantPostRequested(
    GenerateInstantPostRequested event,
    Emitter<AiStudioState> emit,
  ) async {
    final segments = state is AiStudioInitial ? (state as AiStudioInitial).segments : <SegmentModel>[];
    emit(AiGeneratingText());
    try {
      // Small delays to show UI transitions
      await Future.delayed(const Duration(milliseconds: 500));
      emit(AiGeneratingImage());
      
      final post = await aiRemoteDataSource.generatePost(
        segmentId: event.segmentId,
        promptTopic: event.promptTopic,
        usePersonaReference: event.usePersonaReference,
      );
      
      emit(AiGenerationSuccess(post.copyWith(segmentId: event.segmentId)));
    } catch (e) {
      emit(AiGenerationFailure(e.toString()));
      emit(AiStudioInitial(segments: segments));
    }
  }

  Future<void> _onRegenerateCaptionOnly(
    RegenerateCaptionOnly event,
    Emitter<AiStudioState> emit,
  ) async {
    if (state is AiGenerationSuccess) {
      final currentPost = (state as AiGenerationSuccess).post;
      emit(AiGeneratingText());
      try {
        final newCaption = await aiRemoteDataSource.regenerateCaption(event.currentPrompt);
        emit(AiGenerationSuccess(currentPost.copyWith(caption: newCaption)));
      } catch (e) {
        emit(AiGenerationFailure(e.toString()));
      }
    }
  }

  Future<void> _onRegenerateImageOnly(
    RegenerateImageOnly event,
    Emitter<AiStudioState> emit,
  ) async {
    if (state is AiGenerationSuccess) {
      final currentPost = (state as AiGenerationSuccess).post;
      emit(AiGeneratingImage());
      try {
        final newImageUrl = await aiRemoteDataSource.regenerateImage(
          event.referenceImageUrl,
          event.style,
        );
        emit(AiGenerationSuccess(currentPost.copyWith(imageUrl: newImageUrl)));
      } catch (e) {
        emit(AiGenerationFailure(e.toString()));
      }
    }
  }

  Future<void> _onScheduleGeneratedPost(
    ScheduleGeneratedPost event,
    Emitter<AiStudioState> emit,
  ) async {
    if (state is AiGenerationSuccess) {
      final currentState = state as AiGenerationSuccess;
      emit(AiGeneratingText()); // Reuse a loading state or add a specific one
      try {
        final postToSchedule = PostItemModel(
          id: '', // Backend generates UUID
          segmentId: event.post.segmentId ?? '', 
          topic: 'AI Generated',
          caption: event.post.caption,
          hashtags: event.post.hashtags,
          mediaUrl: event.post.imageUrl,
          status: PostStatus.scheduled,
          scheduledFor: event.scheduleDate,
        );
        
        await queueRepository.schedulePost(postToSchedule);
        emit(const AiActionSuccess('Post added to your automation queue!'));
        emit(currentState); // Keep the generated post in view
      } catch (e) {
        emit(AiGenerationFailure(e.toString()));
      }
    }
  }
}
