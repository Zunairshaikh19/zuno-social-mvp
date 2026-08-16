import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zunosocial/core/di/injection_container.dart';
import 'package:zunosocial/core/theme/app_theme.dart';
import 'package:zunosocial/core/widgets/app_widgets.dart';
import 'package:zunosocial/features/dashboard/presentation/widgets/dashboard_widgets.dart';
import 'package:zunosocial/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:zunosocial/features/analytics/data/models/analytics_overview_model.dart';

import 'package:zunosocial/core/l10n/app_localizations.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (context) => sl<AnalyticsBloc>()..add(const LoadAnalytics(segmentId: 'all', timeframe: 'Weekly')),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.translate('growth_reports'))),
        body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
          builder: (context, state) {
            if (state is AnalyticsLoading) return const Center(child: CircularProgressIndicator());
            if (state is AnalyticsLoaded) return _buildContent(context, state.data);
            if (state is AnalyticsError) return Center(child: Text(state.message));
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AnalyticsOverviewModel data) {
    final l10n = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMetricsGrid(context, data),
          SizedBox(height: 32.h),
          Text(l10n.translate('trajectory'), style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 16.h),
          _buildChart(context, data.weeklyPerformance),
          if (data.topPerformingPosts.isNotEmpty) ...[
            SizedBox(height: 32.h),
            Text(l10n.translate('top_posts'), style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 16.h),
            _buildTopPostsList(data.topPerformingPosts),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(BuildContext context, AnalyticsOverviewModel data) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            label: l10n.translate('impressions'),
            value: data.totalImpressions.toString(),
            trend: '+15%',
            isPositive: true,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _MetricCard(
            label: l10n.translate('eng_rate'),
            value: '${data.engagementRate}%',
            trend: '+2.4%',
            isPositive: true,
          ),
        ),
      ],
    );
  }

  Widget _buildChart(BuildContext context, List<double> values) {
    return Container(
      height: 200.h,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: values.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
              isCurved: true,
              color: AppTheme.accentIndigo,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppTheme.accentIndigo.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopPostsList(List topPosts) {
    return SizedBox(
      height: 120.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: topPosts.length,
        itemBuilder: (context, index) {
          final post = topPosts[index];
          return Container(
            width: 280.w,
            margin: EdgeInsets.only(right: 16.w),
            child: Card(
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(post.mediaUrl, width: 50.w, height: 50.h, fit: BoxFit.cover),
                ),
                title: Text(post.topic, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text('${(post.id.hashCode % 1000)} likes', style: const TextStyle(color: AppTheme.successEmerald)),
                trailing: const Icon(Icons.trending_up, color: AppTheme.successEmerald),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String trend;
  final bool isPositive;

  const _MetricCard({required this.label, required this.value, required this.trend, required this.isPositive});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      height: 120.h,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            SizedBox(height: 4.h),
            Text(value, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(isPositive ? Icons.arrow_upward : Icons.arrow_downward, 
                     size: 12, color: isPositive ? AppTheme.successEmerald : AppTheme.errorRose),
                Text(trend, style: TextStyle(color: isPositive ? AppTheme.successEmerald : AppTheme.errorRose, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
