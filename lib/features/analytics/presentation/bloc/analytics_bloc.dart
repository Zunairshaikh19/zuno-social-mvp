import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zunosocial/features/analytics/data/models/analytics_overview_model.dart';
import 'package:zunosocial/features/analytics/domain/repositories/analytics_repository.dart';

// --- Events ---
abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();
  @override
  List<Object?> get props => [];
}

class LoadAnalytics extends AnalyticsEvent {
  final String segmentId;
  final String timeframe;
  const LoadAnalytics({required this.segmentId, required this.timeframe});
  @override
  List<Object?> get props => [segmentId, timeframe];
}

class SwitchTimeframe extends AnalyticsEvent {
  final String segmentId;
  final String timeframe;
  const SwitchTimeframe({required this.segmentId, required this.timeframe});
  @override
  List<Object?> get props => [segmentId, timeframe];
}

// --- States ---
abstract class AnalyticsState extends Equatable {
  const AnalyticsState();
  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}
class AnalyticsLoading extends AnalyticsState {}
class AnalyticsLoaded extends AnalyticsState {
  final AnalyticsOverviewModel data;
  const AnalyticsLoaded(this.data);
  @override
  List<Object?> get props => [data];
}
class AnalyticsError extends AnalyticsState {
  final String message;
  const AnalyticsError(this.message);
  @override
  List<Object?> get props => [message];
}

// --- Bloc ---
class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final AnalyticsRepository analyticsRepository;

  AnalyticsBloc({required this.analyticsRepository}) : super(AnalyticsInitial()) {
    on<LoadAnalytics>((event, emit) async {
      emit(AnalyticsLoading());
      try {
        final data = await analyticsRepository.getAnalytics(
          segmentId: event.segmentId,
          timeframe: event.timeframe,
        );
        emit(AnalyticsLoaded(data));
      } catch (e) {
        emit(AnalyticsError(e.toString()));
      }
    });

    on<SwitchTimeframe>((event, emit) async {
      emit(AnalyticsLoading());
      try {
        final data = await analyticsRepository.getAnalytics(
          segmentId: event.segmentId,
          timeframe: event.timeframe,
        );
        emit(AnalyticsLoaded(data));
      } catch (e) {
        emit(AnalyticsError(e.toString()));
      }
    });
  }
}
