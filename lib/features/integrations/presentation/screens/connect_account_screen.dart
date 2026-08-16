import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zunosocial/core/di/injection_container.dart';
import 'package:zunosocial/core/theme/app_theme.dart';
import 'package:zunosocial/core/widgets/app_widgets.dart';
import 'package:zunosocial/features/integrations/presentation/bloc/integrations_bloc.dart';
import 'package:zunosocial/features/integrations/data/models/connected_account_model.dart';

class ConnectAccountScreen extends StatelessWidget {
  final String segmentId;

  const ConnectAccountScreen({super.key, this.segmentId = '1'});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<IntegrationsBloc>()..add(LoadConnectedAccounts(segmentId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Integrations')),
        body: BlocConsumer<IntegrationsBloc, IntegrationsState>(
          listener: (context, state) {
            if (state is IntegrationsActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: AppTheme.successEmerald),
              );
            }
          },
          builder: (context, state) {
            if (state is IntegrationsLoading) return const Center(child: CircularProgressIndicator());
            if (state is IntegrationsLoaded) return _buildContent(context, state.accounts);
            if (state is IntegrationsError) return Center(child: Text(state.message));
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<ConnectedAccountModel> accounts) {
    final isConnected = accounts.isNotEmpty;

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPlatformCard(context, isConnected, isConnected ? accounts.first : null),
          SizedBox(height: 32.h),
          Text(
            'Permissions Checklist',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          _PermissionItem(
            label: 'instagram_content_publish',
            description: 'Required to auto-post your AI content directly to your feed.',
            isGranted: isConnected,
          ),
          _PermissionItem(
            label: 'pages_manage_posts',
            description: 'Needed to manage scheduled content and drafts.',
            isGranted: isConnected,
          ),
          _PermissionItem(
            label: 'instagram_basic',
            description: 'Access to profile info for consistent persona rendering.',
            isGranted: isConnected,
          ),
          SizedBox(height: 40.h),
          _buildSafetyBadge(context),
          SizedBox(height: 40.h),
          if (!isConnected)
            AppButton(
              label: 'Connect with Instagram',
              onPressed: () => context.read<IntegrationsBloc>().add(ConnectMetaAccount(
                    segmentId: segmentId,
                    accessToken: 'mock_token',
                  )),
            )
          else
            AppButton(
              label: 'Disconnect Account',
              isSecondary: true,
              onPressed: () => context.read<IntegrationsBloc>().add(DisconnectAccount(
                    accountId: accounts.first.id,
                    segmentId: segmentId,
                  )),
            ),
        ],
      ),
    );
  }

  Widget _buildPlatformCard(BuildContext context, bool isConnected, ConnectedAccountModel? account) {
    return FadeInDown(
      child: GlassCard(
        height: 180.h,
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.pink.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.camera_alt_outlined, color: Colors.pink, size: 32.sp),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Instagram Business', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                        Text(
                          isConnected ? account!.accountName : 'Not Connected',
                          style: TextStyle(color: isConnected ? AppTheme.successEmerald : Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  if (isConnected) const Icon(Icons.check_circle, color: AppTheme.successEmerald),
                ],
              ),
              if (isConnected) ...[
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Token expires in:', style: TextStyle(color: Colors.grey)),
                    Text('45 days', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSafetyBadge(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppTheme.accentIndigo.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppTheme.accentIndigo.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_user_outlined, color: AppTheme.accentIndigo, size: 24.sp),
          SizedBox(width: 12.w),
          const Expanded(
            child: Text(
              'Official Meta Graph API Integration. Your login is handled securely via Meta OAuth.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionItem extends StatelessWidget {
  final String label;
  final String description;
  final bool isGranted;

  const _PermissionItem({required this.label, required this.description, required this.isGranted});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isGranted ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isGranted ? AppTheme.successEmerald : Colors.grey,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp)),
                Text(description, style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
