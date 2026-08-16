import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zunosocial/core/di/injection_container.dart';
import 'package:zunosocial/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:zunosocial/features/notifications/data/models/notification_model.dart';

import '../../../../core/l10n/app_localizations.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (context) => sl<NotificationsBloc>()..add(LoadNotifications()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.translate('notifications'),
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24.sp),
          ),
          actions: [
            Builder(
              builder: (context) => TextButton(
                onPressed: () => context.read<NotificationsBloc>().add(MarkAllAsRead()),
                child: Text(l10n.translate('mark_all_read')),
              ),
            ),
          ],
        ),
        body: BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is NotificationsLoaded) {
              if (state.notifications.isEmpty) {
                return _buildEmptyState();
              }
              return _buildList(context, state.notifications);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_rounded, size: 64.sp, color: Colors.grey.shade300),
          SizedBox(height: 16.h),
          const Text('All caught up!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, List<NotificationModel> notifications) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return Dismissible(
          key: Key(notification.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20.w),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: const Icon(Icons.delete_outline, color: Colors.red),
          ),
          onDismissed: (_) {
            context.read<NotificationsBloc>().add(DeleteNotification(notification.id));
          },
          child: _NotificationTile(
            notification: notification,
            onTap: () {
              context.read<NotificationsBloc>().add(MarkAsRead(notification.id));
            },
          ),
        );
      },
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: notification.isRead 
            ? Colors.transparent 
            : Theme.of(context).primaryColor.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: notification.isRead 
              ? Colors.grey.withOpacity(0.1) 
              : Theme.of(context).primaryColor.withOpacity(0.1),
          ),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          leading: Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: notification.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(notification.icon, color: notification.color, size: 22.sp),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                notification.title,
                style: TextStyle(
                  fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w800,
                  fontSize: 15.sp,
                ),
              ),
              if (!notification.isRead)
                Container(
                  width: 8.r,
                  height: 8.r,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4.h),
              Text(
                notification.message,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey.shade600,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                notification.time,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
