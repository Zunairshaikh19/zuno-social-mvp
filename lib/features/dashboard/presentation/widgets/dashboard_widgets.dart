import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zunosocial/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:zunosocial/core/theme/app_theme.dart';
import 'package:zunosocial/core/widgets/app_widgets.dart';

import 'package:zunosocial/core/l10n/app_localizations.dart';

class PersonaHeader extends StatelessWidget {
  final String activeSegment;
  final VoidCallback onSwitch;

  const PersonaHeader({
    super.key,
    required this.activeSegment,
    required this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        CircleAvatar(
          radius: 24.r,
          backgroundColor: AppTheme.accentIndigo.withOpacity(0.1),
          child: Icon(Icons.auto_awesome, color: AppTheme.accentIndigo, size: 20.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.translate('active_persona'),
                style: TextStyle(color: Colors.grey, fontSize: 11.sp),
              ),
              GestureDetector(
                onTap: onSwitch,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        activeSegment,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down_rounded, size: 18.sp, color: AppTheme.accentIndigo),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppTheme.successEmerald.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            l10n.translate('connected'),
            style: TextStyle(
              color: AppTheme.successEmerald,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class NextPostCountdownCard extends StatelessWidget {
  final DateTime? scheduledTime;

  const NextPostCountdownCard({super.key, this.scheduledTime});

  String _getRemainingTime(DateTime? time) {
    if (time == null) return 'No posts scheduled';
    final now = DateTime.now();
    final difference = time.difference(now);
    if (difference.isNegative) return 'Post pending...';
    
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed('/automation-details'),
      borderRadius: BorderRadius.circular(24.r),
      child: GlassCard(
        height: 90.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.timer_outlined, color: Theme.of(context).primaryColor, size: 22.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.translate('next_post'),
                      style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '${_getRemainingTime(scheduledTime)} ${scheduledTime != null ? l10n.translate('remaining') : ""}',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade400, size: 14.sp),
            ],
          ),
        ),
      ),
    );
  }
}

class UsageProgressCard extends StatelessWidget {
  final int used;
  final int total;
  final String planType;

  const UsageProgressCard({super.key, required this.used, required this.total, required this.planType});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progress = used / total;
    return Card(
      elevation: 0,
      color: Theme.of(context).cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.translate('quota'),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                ),
                Text(
                  '$used / $total posts',
                  style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4.r),
              backgroundColor: Colors.grey.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                progress > 0.8 ? AppTheme.errorRose : AppTheme.successEmerald,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              '${planType.toUpperCase()} PLAN ACTIVE',
              style: TextStyle(fontSize: 11.sp, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickActionButtons extends StatelessWidget {
  const QuickActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.translate('manage_workspace'),
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12.w,
          crossAxisSpacing: 12.w,
          childAspectRatio: 1.4,
          children: [
            _ActionItem(
              icon: Icons.link,
              label: l10n.translate('connect_meta'),
              color: Colors.blue,
              onTap: () {},
            ),
            _ActionItem(
              icon: Icons.person_add_rounded,
              label: l10n.translate('new_persona'),
              color: Colors.orange,
              onTap: () async {
                final dashboardBloc = context.read<DashboardBloc>();
                final result = await Navigator.of(context).pushNamed('/segments');
                if (result == true) {
                  dashboardBloc.add(LoadDashboardData());
                }
              },
            ),
            _ActionItem(
              icon: Icons.card_giftcard,
              label: l10n.translate('referrals'),
              color: Colors.teal,
              onTap: () => Navigator.of(context).pushNamed('/referral'),
            ),
            _ActionItem(
              icon: Icons.help_outline_rounded,
              label: l10n.translate('support'),
              color: Colors.indigo,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: color.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24.sp),
              SizedBox(height: 8.h),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                  color: color.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
