import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zunosocial/features/integrations/data/models/connected_account_model.dart';
import 'package:zunosocial/features/integrations/domain/repositories/integrations_repository.dart';

// --- Events ---
abstract class IntegrationsEvent extends Equatable {
  const IntegrationsEvent();
  @override
  List<Object?> get props => [];
}

class LoadConnectedAccounts extends IntegrationsEvent {
  final String segmentId;
  const LoadConnectedAccounts(this.segmentId);
  @override
  List<Object?> get props => [segmentId];
}

class ConnectMetaAccount extends IntegrationsEvent {
  final String segmentId;
  final String accessToken;
  const ConnectMetaAccount({required this.segmentId, required this.accessToken});
  @override
  List<Object?> get props => [segmentId, accessToken];
}

class DisconnectAccount extends IntegrationsEvent {
  final String accountId;
  final String segmentId; // To reload accounts after disconnect
  const DisconnectAccount({required this.accountId, required this.segmentId});
  @override
  List<Object?> get props => [accountId, segmentId];
}

// --- States ---
abstract class IntegrationsState extends Equatable {
  const IntegrationsState();
  @override
  List<Object?> get props => [];
}

class IntegrationsInitial extends IntegrationsState {}
class IntegrationsLoading extends IntegrationsState {}
class IntegrationsLoaded extends IntegrationsState {
  final List<ConnectedAccountModel> accounts;
  const IntegrationsLoaded(this.accounts);
  @override
  List<Object?> get props => [accounts];
}
class IntegrationsActionSuccess extends IntegrationsState {
  final String message;
  const IntegrationsActionSuccess(this.message);
  @override
  List<Object?> get props => [message];
}
class IntegrationsError extends IntegrationsState {
  final String message;
  const IntegrationsError(this.message);
  @override
  List<Object?> get props => [message];
}

// --- Bloc ---
class IntegrationsBloc extends Bloc<IntegrationsEvent, IntegrationsState> {
  final IntegrationsRepository repository;

  IntegrationsBloc({required this.repository}) : super(IntegrationsInitial()) {
    on<LoadConnectedAccounts>((event, emit) async {
      emit(IntegrationsLoading());
      try {
        final accounts = await repository.getConnectedAccounts(event.segmentId);
        emit(IntegrationsLoaded(accounts));
      } catch (e) {
        emit(IntegrationsError(e.toString()));
      }
    });

    on<ConnectMetaAccount>((event, emit) async {
      emit(IntegrationsLoading());
      try {
        await repository.connectAccount(event.segmentId, 'Meta', event.accessToken);
        emit(const IntegrationsActionSuccess('Account connected successfully!'));
        add(LoadConnectedAccounts(event.segmentId));
      } catch (e) {
        emit(IntegrationsError(e.toString()));
      }
    });

    on<DisconnectAccount>((event, emit) async {
      emit(IntegrationsLoading());
      try {
        await repository.disconnectAccount(event.accountId);
        emit(const IntegrationsActionSuccess('Account disconnected'));
        add(LoadConnectedAccounts(event.segmentId));
      } catch (e) {
        emit(IntegrationsError(e.toString()));
      }
    });
  }
}
