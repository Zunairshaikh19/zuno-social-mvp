import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zunosocial/features/notifications/data/models/notification_model.dart';

// --- Events ---
abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();
  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationsEvent {}
class MarkAsRead extends NotificationsEvent {
  final String id;
  const MarkAsRead(this.id);
  @override
  List<Object?> get props => [id];
}
class MarkAllAsRead extends NotificationsEvent {}
class DeleteNotification extends NotificationsEvent {
  final String id;
  const DeleteNotification(this.id);
  @override
  List<Object?> get props => [id];
}

// --- States ---
abstract class NotificationsState extends Equatable {
  const NotificationsState();
  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {}
class NotificationsLoading extends NotificationsState {}
class NotificationsLoaded extends NotificationsState {
  final List<NotificationModel> notifications;
  const NotificationsLoaded(this.notifications);
  @override
  List<Object?> get props => [notifications];
}

// --- Bloc ---
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(NotificationsInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkAsRead>(_onMarkAsRead);
    on<MarkAllAsRead>(_onMarkAllAsRead);
    on<DeleteNotification>(_onDeleteNotification);
  }

  final List<NotificationModel> _mockData = [
    const NotificationModel(
      id: '1',
      title: 'AI Generation Complete',
      message: 'Your 3 new drafts for "Tech Guru" are ready for review.',
      time: '2m ago',
      type: NotificationType.aiComplete,
      isRead: false,
    ),
    const NotificationModel(
      id: '2',
      title: 'Successfully Published',
      message: 'Your post "Morning Coffee" is now live on Instagram.',
      time: '1h ago',
      type: NotificationType.postPublished,
      isRead: false,
    ),
    const NotificationModel(
      id: '3',
      title: 'System Update',
      message: 'Version 1.0.2 is now available with improved image consistency.',
      time: 'Yesterday',
      type: NotificationType.system,
      isRead: true,
    ),
  ];

  void _onLoadNotifications(LoadNotifications event, Emitter<NotificationsState> emit) async {
    emit(NotificationsLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(NotificationsLoaded(List.from(_mockData)));
  }

  void _onMarkAsRead(MarkAsRead event, Emitter<NotificationsState> emit) {
    if (state is NotificationsLoaded) {
      final updated = (state as NotificationsLoaded).notifications.map((n) {
        return n.id == event.id ? n.copyWith(isRead: true) : n;
      }).toList();
      emit(NotificationsLoaded(updated));
    }
  }

  void _onMarkAllAsRead(MarkAllAsRead event, Emitter<NotificationsState> emit) {
    if (state is NotificationsLoaded) {
      final updated = (state as NotificationsLoaded).notifications.map((n) {
        return n.copyWith(isRead: true);
      }).toList();
      emit(NotificationsLoaded(updated));
    }
  }

  void _onDeleteNotification(DeleteNotification event, Emitter<NotificationsState> emit) {
    if (state is NotificationsLoaded) {
      final updated = (state as NotificationsLoaded).notifications
          .where((n) => n.id != event.id)
          .toList();
      emit(NotificationsLoaded(updated));
    }
  }
}
