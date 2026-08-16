import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zunosocial/core/di/injection_container.dart';
import 'package:zunosocial/core/theme/app_theme.dart';
import 'package:zunosocial/core/widgets/app_widgets.dart';
import 'package:zunosocial/features/referral/presentation/bloc/referral_bloc.dart';
import 'package:zunosocial/core/l10n/app_localizations.dart';
import 'package:zunosocial/features/referral/data/models/referral_stats_model.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (context) => sl<ReferralBloc>()..add(LoadReferralStats()),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.translate('referrals'))),
        body: BlocConsumer<ReferralBloc, ReferralState>(
          listener: (context, state) {
            if (state is ReferralError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is ReferralLoading) return const Center(child: CircularProgressIndicator());
            if (state is ReferralLoaded) return _buildContent(context, state);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ReferralLoaded state) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          _buildReferralHeader(),
          SizedBox(height: 32.h),
          _buildStatsRow(state.stats),
          SizedBox(height: 40.h),
          _buildReferralCodeCard(context, state.stats.referralCode),
          SizedBox(height: 40.h),
          _buildRewardsTimeline(state.stats),
        ],
      ),
    );
  }

  Widget _buildReferralHeader() {
    return FadeInDown(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(color: Colors.teal.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(Icons.card_giftcard_rounded, color: Colors.teal, size: 48.sp),
          ),
          SizedBox(height: 24.h),
          Text('Invite Friends, Earn Credits', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          Text(
            'Share ZUNO with other creators and get 1 month of Pro for every 3 referrals.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(ReferralStatsModel stats) {
    return Row(
      children: [
        _StatItem(label: 'Total Invites', value: stats.totalInvited.toString()),
        SizedBox(width: 16.w),
        _StatItem(label: 'Credits Earned', value: '${stats.creditsEarnedUsd.toInt()} mo'),
      ],
    );
  }

  Widget _buildReferralCodeCard(BuildContext context, String code) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          const Text('Your Unique Code', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(code, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w900, letterSpacing: 2)),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, color: AppTheme.accentIndigo),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Code copied!')));
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          AppButton(label: 'Share Link', onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildRewardsTimeline(ReferralStatsModel stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Your Progress', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 16.h),
        _RewardTile(
          title: '3 Referrals', 
          desc: '1 Month Pro Credit', 
          isCompleted: stats.totalInvited >= 3
        ),
        _RewardTile(
          title: '10 Referrals', 
          desc: 'Custom AI Persona Training', 
          isCompleted: stats.totalInvited >= 10
        ),
        _RewardTile(
          title: '25 Referrals', 
          desc: 'Early Beta Access & Founder Badge', 
          isCompleted: stats.totalInvited >= 25
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _RewardTile extends StatelessWidget {
  final String title;
  final String desc;
  final bool isCompleted;
  const _RewardTile({required this.title, required this.desc, required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Icon(isCompleted ? Icons.check_circle : Icons.radio_button_unchecked, 
               color: isCompleted ? AppTheme.successEmerald : Colors.grey),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isCompleted ? null : Colors.grey)),
              Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
