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
  
  const DashboardLoaded({required this.stats, required this.segments});
  
  @override
  List<Object?> get props => [stats, segments];
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
      emit(DashboardLoading());
      try {
        final stats = await dashboardRepository.getDashboardStats();
        final segments = await segmentsRepository.getSegments();
        emit(DashboardLoaded(stats: stats, segments: segments));
      } catch (e) {
        emit(DashboardError(e.toString()));
      }
    });

    on<SwitchActiveSegment>((event, emit) async {
      if (state is DashboardLoaded) {
        final currentState = state as DashboardLoaded;
        emit(DashboardLoading());
        try {
          // In a real app, you might notify the backend about the active segment change
          // For now, we just reload stats
          final stats = await dashboardRepository.getDashboardStats();
          emit(DashboardLoaded(stats: stats, segments: currentState.segments));
        } catch (e) {
          emit(DashboardError(e.toString()));
        }
      }
    });
  }
}
