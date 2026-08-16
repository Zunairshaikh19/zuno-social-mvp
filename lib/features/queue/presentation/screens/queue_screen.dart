import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zunosocial/core/di/injection_container.dart';
import 'package:zunosocial/core/theme/app_theme.dart';
import 'package:zunosocial/features/queue/presentation/bloc/queue_bloc.dart';
import 'package:zunosocial/features/queue/data/models/post_item_model.dart';
import 'package:zunosocial/features/queue/presentation/widgets/post_detail_modal.dart';
import 'package:zunosocial/core/l10n/app_localizations.dart';

class QueueScreen extends StatelessWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (context) => sl<QueueBloc>()..add(LoadQueuePosts()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.translate('schedule'),
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24.sp),
          ),
          actions: [
            IconButton(
              icon: Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: AppTheme.accentIndigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.calendar_month_rounded, color: AppTheme.accentIndigo, size: 20.sp),
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocBuilder<QueueBloc, QueueState>(
          builder: (context, state) {
            if (state is QueueLoading) return _buildLoading();
            if (state is QueueLoaded) return _buildContent(context, state);
            if (state is QueueError) return Center(child: Text(state.message));
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, QueueLoaded state) {
    final filteredPosts = state.posts.where((p) {
      if (state.selectedFilter != null && p.status != state.selectedFilter) return false;
      return true;
    }).toList();

    return Column(
      children: [
        _buildDateStrip(context, state.selectedDate),
        _buildFilterTabs(context, state.selectedFilter),
        Expanded(
          child: filteredPosts.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  itemCount: filteredPosts.length,
                  itemBuilder: (context, index) {
                    return FadeInUp(
                      delay: Duration(milliseconds: index * 50),
                      child: _PostCard(post: filteredPosts[index]),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildDateStrip(BuildContext context, DateTime selectedDate) {
    return Container(
      height: 100.h,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: 14, // 2 weeks
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index - 2));
          final isSelected = date.day == selectedDate.day && date.month == selectedDate.month;
          return GestureDetector(
            onTap: () => context.read<QueueBloc>().add(FilterPostsByDate(date)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 64.w,
              margin: EdgeInsets.symmetric(horizontal: 6.w),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppTheme.accentIndigo, AppTheme.glowViolet.withOpacity(0.8)],
                      )
                    : null,
                color: isSelected ? null : Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppTheme.accentIndigo.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : [],
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey.withOpacity(0.1),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEE').format(date).toUpperCase(),
                    style: TextStyle(
                      color: isSelected ? Colors.white.withOpacity(0.8) : Colors.grey,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : null,
                      fontWeight: FontWeight.w900,
                      fontSize: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterTabs(BuildContext context, PostStatus? selected) {
    final l10n = AppLocalizations.of(context);
    final filters = [
      {'label': l10n.translate('all'), 'value': null},
      {'label': l10n.translate('scheduled'), 'value': PostStatus.scheduled},
      {'label': l10n.translate('drafts'), 'value': PostStatus.draft},
      {'label': l10n.translate('published'), 'value': PostStatus.published},
      {'label': l10n.translate('failed'), 'value': PostStatus.failed},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        children: filters.map((filter) {
          final isSelected = selected == filter['value'];
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: ChoiceChip(
              label: Text(filter['label'] as String),
              selected: isSelected,
              onSelected: (_) => context.read<QueueBloc>().add(FilterPostsByStatus(filter['value'] as PostStatus?)),
              backgroundColor: Colors.transparent,
              selectedColor: AppTheme.accentIndigo,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 13.sp,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
                side: BorderSide(
                  color: isSelected ? AppTheme.accentIndigo : Colors.grey.shade300,
                ),
              ),
              showCheckmark: false,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: FadeIn(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.auto_awesome_motion_rounded, size: 48.sp, color: Colors.grey.shade300),
            ),
            SizedBox(height: 16.h),
            Text(
              l10n.translate('no_posts'),
              style: TextStyle(color: Colors.grey.shade800, fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.h),
            Text(
              'Try changing your filters or create a post.',
              style: TextStyle(color: Colors.grey, fontSize: 13.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        padding: EdgeInsets.all(20.w),
        itemCount: 5,
        itemBuilder: (_, __) => Container(
          height: 110.h,
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.r)),
        ),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final PostItemModel post;
  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: InkWell(
        onTap: () => PostDetailModal.show(context, post),
        borderRadius: BorderRadius.circular(24.r),
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Row(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: CachedNetworkImage(
                      imageUrl: post.mediaUrl,
                      width: 85.w,
                      height: 85.w,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: Colors.grey.shade100),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.image_rounded, color: Colors.white, size: 12.sp),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatusBadge(status: post.status),
                    SizedBox(height: 10.h),
                    Text(
                      post.caption,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, height: 1.3),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 12.sp, color: Colors.grey),
                        SizedBox(width: 4.w),
                        Text(
                          DateFormat('MMM dd • hh:mm a').format(post.scheduledFor),
                          style: TextStyle(color: Colors.grey, fontSize: 11.sp, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade300, size: 14.sp),
              SizedBox(width: 4.w),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final PostStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case PostStatus.published:
        color = AppTheme.successEmerald;
        break;
      case PostStatus.scheduled:
        color = AppTheme.accentIndigo;
        break;
      case PostStatus.draft:
        color = Colors.orange;
        break;
      case PostStatus.failed:
        color = AppTheme.errorRose;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(color: color, fontSize: 9.sp, fontWeight: FontWeight.w900, letterSpacing: 0.5),
      ),
    );
  }
}
