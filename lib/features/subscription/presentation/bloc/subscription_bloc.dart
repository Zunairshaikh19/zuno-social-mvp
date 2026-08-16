import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zunosocial/features/subscription/data/models/subscription_plan_model.dart';
import 'package:zunosocial/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:zunosocial/features/dashboard/data/models/dashboard_stats_model.dart';

// --- Events ---
abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();
  @override
  List<Object?> get props => [];
}

class LoadSubscriptionPlans extends SubscriptionEvent {}

class PurchasePlanRequested extends SubscriptionEvent {
  final String planId;
  const PurchasePlanRequested(this.planId);
  @override
  List<Object?> get props => [planId];
}

class RestorePurchasesRequested extends SubscriptionEvent {}

class PurchaseAddonSegment extends SubscriptionEvent {}

// --- States ---
abstract class SubscriptionState extends Equatable {
  const SubscriptionState();
  @override
  List<Object?> get props => [];
}

class SubscriptionInitial extends SubscriptionState {}
class SubscriptionLoading extends SubscriptionState {}
class SubscriptionLoaded extends SubscriptionState {
  final SubscriptionPlanModel? currentPlan;
  final List<SubscriptionPlanModel> availablePlans;
  final bool isSubscribed;
  final int postsUsed;

  const SubscriptionLoaded({
    this.currentPlan,
    required this.availablePlans,
    required this.isSubscribed,
    this.postsUsed = 0,
  });

  @override
  List<Object?> get props => [currentPlan, availablePlans, isSubscribed, postsUsed];
}

class PurchaseInProgress extends SubscriptionState {}
class PurchaseSuccess extends SubscriptionState {
  final String message;
  const PurchaseSuccess(this.message);
  @override
  List<Object?> get props => [message];
}
class PurchaseFailure extends SubscriptionState {
  final String error;
  const PurchaseFailure(this.error);
  @override
  List<Object?> get props => [error];
}

// --- Bloc ---
class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionRepository subscriptionRepository;

  SubscriptionBloc({required this.subscriptionRepository}) : super(SubscriptionInitial()) {
    on<LoadSubscriptionPlans>((event, emit) async {
      emit(SubscriptionLoading());
      try {
        final plans = await subscriptionRepository.getSubscriptionPlans();
        
        DashboardStatsModel? stats;
        try {
          stats = await subscriptionRepository.getSubscriptionStats();
        } catch (e) {
          print('SubscriptionBloc: Error fetching stats: $e');
          // Non-critical failure, continue with defaults
        }
        
        // Find current plan based on stats
        final currentPlan = plans.firstWhere(
          (p) => p.id == stats?.planType,
          orElse: () => plans.isNotEmpty ? plans.first : SubscriptionPlanModel(
            id: 'starter', name: 'Starter', priceMonthly: 19, postsPerMonth: 16, segmentLimit: 1, features: [],
          ),
        );

        emit(SubscriptionLoaded(
          currentPlan: currentPlan,
          availablePlans: plans,
          isSubscribed: plans.isNotEmpty,
          postsUsed: stats?.postsUsed ?? 0,
        ));
      } catch (e) {
        print('SubscriptionBloc: Critical error: $e');
        emit(PurchaseFailure(e.toString()));
      }
    });

    on<PurchasePlanRequested>((event, emit) async {
      emit(PurchaseInProgress());
      try {
        await subscriptionRepository.subscribe(event.planId);
        emit(const PurchaseSuccess('Subscription upgraded successfully!'));
        add(LoadSubscriptionPlans());
      } catch (e) {
        emit(PurchaseFailure(e.toString()));
      }
    });

    on<RestorePurchasesRequested>((event, emit) async {
      emit(PurchaseInProgress());
      await Future.delayed(const Duration(seconds: 1));
      emit(const PurchaseSuccess('Purchases restored.'));
      add(LoadSubscriptionPlans());
    });

    on<PurchaseAddonSegment>((event, emit) async {
      emit(PurchaseInProgress());
      await Future.delayed(const Duration(seconds: 1));
      emit(const PurchaseSuccess('New persona slot unlocked!'));
      add(LoadSubscriptionPlans());
    });
  }
}
