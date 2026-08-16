import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zunosocial/core/di/injection_container.dart';
import 'package:zunosocial/core/l10n/app_localizations.dart';
import 'package:zunosocial/core/theme/app_theme.dart';
import 'package:zunosocial/core/widgets/app_widgets.dart';
import 'package:zunosocial/features/queue/presentation/bloc/queue_bloc.dart';

class AutomationDetailsScreen extends StatelessWidget {
  const AutomationDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return BlocProvider(
      create: (context) => sl<QueueBloc>()..add(LoadQueuePosts()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.translate('next_post'), style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20.sp)),
        ),
        body: BlocConsumer<QueueBloc, QueueState>(
          listener: (context, state) {
            if (state is QueueActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: AppTheme.successEmerald),
              );
              if (state.message.contains('published')) {
                Navigator.pop(context);
              }
            }
          },
          builder: (context, state) {
            if (state is QueueLoading) return const Center(child: CircularProgressIndicator());
            
            return SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCountdownHeader(context, l10n),
                  SizedBox(height: 32.h),
                  _buildPostPreview(context, l10n),
                  SizedBox(height: 32.h),
                  _buildAutomationSettings(context, l10n),
                  SizedBox(height: 40.h),
                  _buildActionButtons(context, l10n),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCountdownHeader(BuildContext context, AppLocalizations l10n) {
    return FadeInDown(
      child: Center(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 130.r,
                  height: 130.r,
                  child: CircularProgressIndicator(
                    value: 0.65,
                    strokeWidth: 10,
                    strokeCap: StrokeCap.round,
                    backgroundColor: Colors.grey.withOpacity(0.1),
                    valueColor: const AlwaysStoppedAnimation(AppTheme.accentIndigo),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('4h 20m', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900)),
                    Text(l10n.translate('remaining'), style: TextStyle(fontSize: 12.sp, color: Colors.grey, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_today_rounded, size: 14, color: AppTheme.accentIndigo),
                  SizedBox(width: 8.w),
                  Text(
                    'Today, 6:00 PM',
                    style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey.shade700, fontSize: 13.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostPreview(BuildContext context, AppLocalizations l10n) {
    return FadeInUp(
      delay: const Duration(milliseconds: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Content Preview', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800)),
          SizedBox(height: 16.h),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                  child: CachedNetworkImage(
                    imageUrl: 'https://images.unsplash.com/photo-1611162617474-5b21e879e113?q=80&w=1000',
                    height: 220.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: Colors.grey.shade100),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Optimizing neural networks for creative consistency in 2026. #AI #TechTrends',
                        style: TextStyle(fontSize: 14.sp, height: 1.5, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          _buildPlatformIcon(Icons.facebook, Colors.blue),
                          SizedBox(width: 10.w),
                          _buildPlatformIcon(Icons.camera_alt_rounded, Colors.pink),
                          SizedBox(width: 10.w),
                          _buildPlatformIcon(Icons.alternate_email_rounded, Colors.black),
                          const Spacer(),
                          Text('Target: 2.4k Reach', style: TextStyle(fontSize: 11.sp, color: Colors.grey, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformIcon(IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
      child: Icon(icon, color: color, size: 18.sp),
    );
  }

  Widget _buildAutomationSettings(BuildContext context, AppLocalizations l10n) {
    return FadeInUp(
      delay: const Duration(milliseconds: 400),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Automation Settings', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800)),
          SizedBox(height: 16.h),
          _buildSettingTile(
            context, 
            Icons.auto_awesome, 
            'AI Persona', 
            'AI Influencer Alpha', 
            onTap: () => Navigator.pushNamed(context, '/segments')
          ),
          _buildSettingTile(
            context, 
            Icons.tune_rounded, 
            'Post Style', 
            'Professional', 
            onTap: () => Navigator.pushNamed(context, '/persona-style')
          ),
          _buildSettingTile(
            context, 
            Icons.notifications_active_outlined, 
            'Alert me before posting', 
            'Enabled', 
            isSwitch: true
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(BuildContext context, IconData icon, String title, String value, {bool isSwitch = false, VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey.withOpacity(0.05)),
        ),
        child: ListTile(
          onTap: onTap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          leading: Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(color: AppTheme.accentIndigo.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: AppTheme.accentIndigo, size: 20.sp),
          ),
          title: Text(title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
          subtitle: !isSwitch ? Text(value, style: TextStyle(fontSize: 12.sp, color: Colors.grey)) : null,
          trailing: isSwitch 
            ? Switch(value: true, onChanged: (v){}, activeThumbColor: AppTheme.accentIndigo)
            : Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade300, size: 12.sp),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, AppLocalizations l10n) {
    return FadeInUp(
      delay: const Duration(milliseconds: 600),
      child: Column(
        children: [
          AppButton(
            label: 'Post Now', 
            onPressed: () {
              context.read<QueueBloc>().add(const PublishPostNow('1'));
            }
          ),
          SizedBox(height: 12.h),
          AppButton(
            label: 'Reschedule', 
            isSecondary: true, 
            onPressed: () => _showReschedulePicker(context)
          ),
          SizedBox(height: 12.h),
          TextButton(
            onPressed: () => _showCancelConfirmation(context),
            child: const Text('Cancel this automation', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showReschedulePicker(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (date != null && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null && context.mounted) {
        final fullDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        context.read<QueueBloc>().add(ReschedulePost('1', fullDateTime));
      }
    }
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel Automation?'),
        content: const Text('This post will be moved back to drafts and will not be published automatically.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Keep it')),
          TextButton(
            onPressed: () {
              context.read<QueueBloc>().add(const DeletePost('1'));
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: const Text('Cancel Post', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
