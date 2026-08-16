import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum NotificationType { aiComplete, postPublished, system, quotaAlert, accountAction }

class NotificationModel extends Equatable {
  final String id;
  final String title;
  final String message;
  final String time;
  final NotificationType type;
  final bool isRead;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
  });

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      message: message,
      time: time,
      type: type,
      isRead: isRead ?? this.isRead,
    );
  }

  IconData get icon {
    switch (type) {
      case NotificationType.aiComplete: return Icons.auto_awesome_rounded;
      case NotificationType.postPublished: return Icons.check_circle_rounded;
      case NotificationType.system: return Icons.system_update_alt_rounded;
      case NotificationType.quotaAlert: return Icons.warning_amber_rounded;
      case NotificationType.accountAction: return Icons.link_rounded;
    }
  }

  Color get color {
    switch (type) {
      case NotificationType.aiComplete: return Colors.purple;
      case NotificationType.postPublished: return Colors.green;
      case NotificationType.system: return Colors.blue;
      case NotificationType.quotaAlert: return Colors.orange;
      case NotificationType.accountAction: return Colors.indigo;
    }
  }

  @override
  List<Object?> get props => [id, title, message, time, type, isRead];
}
