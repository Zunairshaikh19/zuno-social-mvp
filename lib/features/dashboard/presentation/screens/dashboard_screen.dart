import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zunosocial/core/di/injection_container.dart';
import 'package:zunosocial/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:zunosocial/features/dashboard/presentation/widgets/dashboard_widgets.dart';

import '../../../../core/l10n/app_localizations.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.translate('dashboard'),
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24.sp),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () => Navigator.of(context).pushNamed('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
          ),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return _buildLoadingState();
          } else if (state is DashboardLoaded) {
            return _buildDashboard(context, state);
          } else if (state is DashboardError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, DashboardLoaded state) {
    final l10n = AppLocalizations.of(context);
    
    return RefreshIndicator(
      onRefresh: () async {
        context.read<DashboardBloc>().add(LoadDashboardData());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 100.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInDown(
              duration: const Duration(milliseconds: 500),
              child: PersonaHeader(
                activeSegment: state.stats.activeSegmentName,
                onSwitch: () => _showSegmentSwitcher(context, state),
              ),
            ),
            if (state.stats.nextScheduledPost != null) ...[
              SizedBox(height: 32.h),
              FadeInLeft(
                delay: const Duration(milliseconds: 200),
                child: NextPostCountdownCard(
                  scheduledTime: state.stats.nextScheduledPost,
                ),
              ),
            ],
            SizedBox(height: 16.h),
            FadeInLeft(
              delay: const Duration(milliseconds: 400),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('/subscription'),
                child: UsageProgressCard(
                  used: state.stats.postsUsed,
                  total: state.stats.totalPostsQuota,
                  planType: state.stats.planType,
                ),
              ),
            ),
            SizedBox(height: 32.h),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: const QuickActionButtons(),
            ),
            SizedBox(height: 32.h),
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: _buildPerformanceSummary(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceSummary(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.translate('performance_overview'),
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                // Navigate to full stats tab
              },
              child: Text(l10n.translate('view_all')),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            _MiniStat(label: l10n.translate('avg_reach'), value: '1.2k', icon: Icons.trending_up, color: Colors.green),
            SizedBox(width: 12.w),
            _MiniStat(label: l10n.translate('engagement'), value: '4.8%', icon: Icons.favorite_border_rounded, color: Colors.pink),
          ],
        ),
      ],
    );
  }

  void _showSegmentSwitcher(BuildContext context, DashboardLoaded state) {
    final l10n = AppLocalizations.of(context);
    final dashboardBloc = context.read<DashboardBloc>();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Theme.of(modalContext).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 24.h),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(l10n.translate('switch_workspace'), style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w800)),
              SizedBox(height: 24.h),
              if (state.segments.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Text('No personas created yet.', style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                  ),
                ),
              ...state.segments.map((segment) => _SegmentSwitchTile(
                name: segment.name,
                isActive: segment.id == state.stats.activeSegmentId,
                onTap: () {
                  dashboardBloc.add(SwitchActiveSegment(segment.id ?? ''));
                  Navigator.pop(modalContext);
                },
              )),
              SizedBox(height: 16.h),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add_rounded),
                ),
                title: Text(l10n.translate('new_persona'), style: const TextStyle(fontWeight: FontWeight.w600)),
                onTap: () async {
                  Navigator.pop(modalContext);
                  final result = await Navigator.pushNamed(context, '/segments');
                  if (result == true) {
                    dashboardBloc.add(LoadDashboardData());
                  }
                },
              ),
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Container(height: 80.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
            SizedBox(height: 24.h),
            Container(height: 120.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
            SizedBox(height: 16.h),
            Container(height: 120.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
          ],
        ),
      ),
    );
  }
}

extension on Widget {
  Widget align(Alignment alignment) => Align(alignment: alignment, child: this);
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MiniStat({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18.sp),
            ),
            SizedBox(height: 12.h),
            Text(value, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800)),
            Text(label, style: TextStyle(fontSize: 11.sp, color: Colors.grey, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _SegmentSwitchTile extends StatelessWidget {
  final String name;
  final bool isActive;
  final VoidCallback onTap;

  const _SegmentSwitchTile({required this.name, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).primaryColor.withOpacity(0.05) : Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isActive ? Theme.of(context).primaryColor.withOpacity(0.2) : Colors.transparent,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        leading: CircleAvatar(
          backgroundColor: isActive ? Theme.of(context).primaryColor : Colors.grey.shade200,
          child: Icon(Icons.person_rounded, color: isActive ? Colors.white : Colors.grey, size: 20.sp),
        ),
        title: Text(name, style: TextStyle(fontWeight: isActive ? FontWeight.w800 : FontWeight.w500, fontSize: 15.sp)),
        trailing: isActive ? Icon(Icons.check_circle_rounded, color: Theme.of(context).primaryColor) : null,
        onTap: onTap,
      ),
    );
  }
}
