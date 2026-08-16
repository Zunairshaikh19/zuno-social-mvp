import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zunosocial/core/di/injection_container.dart';
import 'package:zunosocial/core/theme/app_theme.dart';
import 'package:zunosocial/core/widgets/app_widgets.dart';
import 'package:zunosocial/features/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:zunosocial/core/l10n/app_localizations.dart';

import '../../data/models/subscription_plan_model.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  bool _isAnnual = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (context) => sl<SubscriptionBloc>()..add(LoadSubscriptionPlans()),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.translate('plans_billing'))),
        body: BlocConsumer<SubscriptionBloc, SubscriptionState>(
          listener: (context, state) {
            if (state is PurchaseSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: AppTheme.successEmerald),
              );
            }
          },
          builder: (context, state) {
            if (state is SubscriptionLoading || state is PurchaseInProgress) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is SubscriptionLoaded) {
              return _buildContent(context, state);
            }
            if (state is PurchaseFailure) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 48),
                      SizedBox(height: 16.h),
                      Text(state.error, textAlign: TextAlign.center),
                      SizedBox(height: 24.h),
                      AppButton(
                        label: 'Retry',
                        onPressed: () => context.read<SubscriptionBloc>().add(LoadSubscriptionPlans()),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, SubscriptionLoaded state) {
    if (state.availablePlans.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline, color: Colors.grey, size: 48),
            SizedBox(height: 16.h),
            const Text('No plans available at the moment.'),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          _buildUsageOverview(context, state),
          SizedBox(height: 40.h),
          _buildBillingToggle(context),
          SizedBox(height: 32.h),
          ...state.availablePlans.map((plan) => _PlanCard(
                plan: plan,
                isAnnual: _isAnnual,
                isCurrent: state.currentPlan?.id == plan.id,
              )),
          SizedBox(height: 24.h),
          _buildAddonCard(context),
          SizedBox(height: 40.h),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildUsageOverview(BuildContext context, SubscriptionLoaded state) {
    final l10n = AppLocalizations.of(context);
    return FadeInDown(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.translate('usage_overview'),
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          _SubscriptionUsageCard(used: state.postsUsed, total: state.currentPlan?.postsPerMonth ?? 16),
        ],
      ),
    );
  }

  Widget _buildBillingToggle(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(l10n.translate('monthly'), style: const TextStyle(fontWeight: FontWeight.w600)),
        Switch(
          value: _isAnnual,
          onChanged: (v) => setState(() => _isAnnual = v),
          activeThumbColor: AppTheme.accentIndigo,
        ),
        Row(
          children: [
            Text(l10n.translate('annual'), style: const TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppTheme.successEmerald.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                l10n.translate('off_20'),
                style: const TextStyle(color: AppTheme.successEmerald, fontWeight: FontWeight.bold, fontSize: 10),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddonCard(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.translate('power_ups'), style: const TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 12.h),
        Card(
          child: ListTile(
            leading: const Icon(Icons.add_circle_outline, color: AppTheme.accentIndigo),
            title: Text(l10n.translate('extra_slot')),
            subtitle: Text(l10n.translate('add_persona_desc')),
            trailing: const Text('\$4.99'),
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: TextButton(
        onPressed: () {},
        child: Text(l10n.translate('restore_purchases'), style: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final SubscriptionPlanModel plan;
  final bool isAnnual;
  final bool isCurrent;

  const _PlanCard({required this.plan, required this.isAnnual, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: isCurrent ? AppTheme.accentIndigo : Colors.grey.withOpacity(0.1), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(plan.name, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
              if (isCurrent)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(color: AppTheme.accentIndigo, borderRadius: BorderRadius.circular(20.r)),
                  child: Text(l10n.translate('current'), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(isAnnual ? '\$${(plan.priceMonthly * 0.8 * 12).toInt()}' : '\$${plan.priceMonthly}', 
                   style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w900)),
              Text(isAnnual ? '/yr' : '/mo', style: const TextStyle(color: Colors.grey)),
            ],
          ),
          SizedBox(height: 24.h),
          ...plan.features.map((f) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(children: [
                  const Icon(Icons.check_circle, color: AppTheme.successEmerald, size: 16),
                  SizedBox(width: 8.w),
                  Expanded(child: Text(f.toString())),
                ]),
              )),
          SizedBox(height: 32.h),
          AppButton(
            label: isCurrent ? l10n.translate('manage') : l10n.translate('select_plan'),
            onPressed: isCurrent ? null : () {
              context.read<SubscriptionBloc>().add(PurchasePlanRequested(plan.id));
            },
            isSecondary: isCurrent,
          ),
        ],
      ),
    );
  }
}

class _SubscriptionUsageCard extends StatelessWidget {
  final int used;
  final int total;

  const _SubscriptionUsageCard({required this.used, required this.total});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GlassCard(
      height: null,
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.translate('monthly_quota'), style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('$used / $total posts'),
              ],
            ),
            SizedBox(height: 16.h),
            LinearProgressIndicator(
              value: used / total,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
              backgroundColor: Colors.grey.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation(AppTheme.accentIndigo),
            ),
          ],
        ),
      ),
    );
  }
}
