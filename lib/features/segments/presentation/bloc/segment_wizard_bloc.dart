import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zunosocial/features/segments/data/models/segment_model.dart';
import 'package:zunosocial/features/segments/domain/repositories/segments_repository.dart';

// --- Events ---
abstract class SegmentWizardEvent extends Equatable {
  const SegmentWizardEvent();
  @override
  List<Object?> get props => [];
}

class UpdateSegmentData extends SegmentWizardEvent {
  final SegmentModel segment;
  const UpdateSegmentData(this.segment);
  @override
  List<Object?> get props => [segment];
}

class NextStep extends SegmentWizardEvent {}
class PreviousStep extends SegmentWizardEvent {}
class SubmitSegment extends SegmentWizardEvent {}

// --- States ---
class SegmentWizardState extends Equatable {
  final int currentStep;
  final SegmentModel segment;
  final bool isSubmitting;
  final bool isSuccess;

  const SegmentWizardState({
    this.currentStep = 0,
    this.segment = const SegmentModel(name: '', niche: 'AI Influencer'),
    this.isSubmitting = false,
    this.isSuccess = false,
  });

  SegmentWizardState copyWith({
    int? currentStep,
    SegmentModel? segment,
    bool? isSubmitting,
    bool? isSuccess,
  }) {
    return SegmentWizardState(
      currentStep: currentStep ?? this.currentStep,
      segment: segment ?? this.segment,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [currentStep, segment, isSubmitting, isSuccess];
}

// --- Bloc ---
class SegmentWizardBloc extends Bloc<SegmentWizardEvent, SegmentWizardState> {
  final SegmentsRepository segmentsRepository;

  SegmentWizardBloc({required this.segmentsRepository}) : super(const SegmentWizardState()) {
    on<UpdateSegmentData>((event, emit) {
      emit(state.copyWith(segment: event.segment));
    });

    on<NextStep>((event, emit) {
      if (state.currentStep < 2) {
        emit(state.copyWith(currentStep: state.currentStep + 1));
      }
    });

    on<PreviousStep>((event, emit) {
      if (state.currentStep > 0) {
        emit(state.copyWith(currentStep: state.currentStep - 1));
      }
    });

    on<SubmitSegment>((event, emit) async {
      emit(state.copyWith(isSubmitting: true));
      try {
        await segmentsRepository.createSegment(state.segment);
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      } catch (e) {
        emit(state.copyWith(isSubmitting: false, isSuccess: false));
        // In a real app, you might want to emit an error state or show a snackbar
      }
    });
  }
}
