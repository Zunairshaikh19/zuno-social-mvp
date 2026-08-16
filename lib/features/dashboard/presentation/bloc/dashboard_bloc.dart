import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zunosocial/features/dashboard/data/models/dashboard_stats_model.dart';
import 'package:zunosocial/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:zunosocial/features/segments/domain/repositories/segments_repository.dart';
import 'package:zunosocial/features/segments/data/models/segment_model.dart';

// --- Events ---
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object?> get props => [];
}

class LoadDashboardData extends DashboardEvent {}

class SwitchActiveSegment extends DashboardEvent {
  final String segmentId;
  const SwitchActiveSegment(this.segmentId);
  @override
  List<Object?> get props => [segmentId];
}

// --- States ---
abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}
class DashboardLoading extends DashboardState {}
class DashboardLoaded extends DashboardState {
  final DashboardStatsModel stats;
  final List<SegmentModel> segments;
  final String? activeSegmentId;
  
  const DashboardLoaded({
    required this.stats, 
    required this.segments,
    this.activeSegmentId,
  });
  
  @override
  List<Object?> get props => [stats, segments, activeSegmentId];

  DashboardLoaded copyWith({
    DashboardStatsModel? stats,
    List<SegmentModel>? segments,
    String? activeSegmentId,
  }) {
    return DashboardLoaded(
      stats: stats ?? this.stats,
      segments: segments ?? this.segments,
      activeSegmentId: activeSegmentId ?? this.activeSegmentId,
    );
  }
}
class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
  @override
  List<Object?> get props => [message];
}

// --- Bloc ---
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository dashboardRepository;
  final SegmentsRepository segmentsRepository;

  DashboardBloc({
    required this.dashboardRepository,
    required this.segmentsRepository,
  }) : super(DashboardInitial()) {
    on<LoadDashboardData>((event, emit) async {
      final currentActiveId = state is DashboardLoaded ? (state as DashboardLoaded).activeSegmentId : null;
      emit(DashboardLoading());
      try {
        final stats = await dashboardRepository.getDashboardStats(segmentId: currentActiveId);
        final segments = await segmentsRepository.getSegments();
        emit(DashboardLoaded(
          stats: stats, 
          segments: segments,
          activeSegmentId: stats.activeSegmentId ?? currentActiveId ?? (segments.isNotEmpty ? segments.first.id : null),
        ));
      } catch (e) {
        emit(DashboardError(e.toString()));
      }
    });

    on<SwitchActiveSegment>((event, emit) async {
      if (state is DashboardLoaded) {
        final currentState = state as DashboardLoaded;
        emit(DashboardLoading());
        try {
          final stats = await dashboardRepository.getDashboardStats(segmentId: event.segmentId);
          emit(DashboardLoaded(
            stats: stats, 
            segments: currentState.segments,
            activeSegmentId: event.segmentId,
          ));
        } catch (e) {
          emit(DashboardError(e.toString()));
        }
      }
    });
  }
}
