import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zunosocial/features/referral/data/models/referral_stats_model.dart';
import 'package:zunosocial/features/referral/domain/repositories/referral_repository.dart';

// --- Events ---
abstract class ReferralEvent extends Equatable {
  const ReferralEvent();
  @override
  List<Object?> get props => [];
}

class LoadReferralStats extends ReferralEvent {}
class CopyReferralCode extends ReferralEvent {}
class ShareReferralLink extends ReferralEvent {}

// --- States ---
abstract class ReferralState extends Equatable {
  const ReferralState();
  @override
  List<Object?> get props => [];
}

class ReferralInitial extends ReferralState {}
class ReferralLoading extends ReferralState {}
class ReferralLoaded extends ReferralState {
  final ReferralStatsModel stats;
  const ReferralLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}
class ReferralCopiedSuccess extends ReferralState {}
class ReferralError extends ReferralState {
  final String message;
  const ReferralError(this.message);
  @override
  List<Object?> get props => [message];
}

// --- Bloc ---
class ReferralBloc extends Bloc<ReferralEvent, ReferralState> {
  final ReferralRepository referralRepository;

  ReferralBloc({required this.referralRepository}) : super(ReferralInitial()) {
    on<LoadReferralStats>((event, emit) async {
      emit(ReferralLoading());
      try {
        final stats = await referralRepository.getReferralStats();
        emit(ReferralLoaded(stats));
      } catch (e) {
        emit(ReferralError(e.toString()));
      }
    });

    on<CopyReferralCode>((event, emit) {
      emit(ReferralCopiedSuccess());
    });
  }
}
