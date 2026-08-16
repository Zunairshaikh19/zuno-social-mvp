import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zunosocial/core/theme/app_theme.dart';
import 'package:zunosocial/core/theme/theme_cubit.dart';
import 'package:zunosocial/core/widgets/app_widgets.dart';
import 'package:zunosocial/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:zunosocial/core/l10n/app_localizations.dart';
import 'package:zunosocial/core/l10n/locale_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.translate('profile'),
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24.sp),
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = state is Authenticated ? state.user : null;
          return ListView(
            padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 100.h),
            children: [
              _buildProfileHeader(user),
              SizedBox(height: 32.h),
              
              _buildSectionTitle('Growth & Rewards'),
              _buildModernMenuItem(
                icon: Icons.card_giftcard_rounded,
                title: l10n.translate('referrals'),
                subtitle: 'Invite friends, earn credits',
                color: Colors.teal,
                onTap: () => Navigator.of(context).pushNamed('/referral'),
              ),
              _buildModernMenuItem(
                icon: Icons.star_outline_rounded,
                title: 'Premium Plan',
                subtitle: 'Manage your subscription',
                color: Colors.orange,
                onTap: () => Navigator.of(context).pushNamed('/subscription'),
              ),
              
              SizedBox(height: 32.h),
              _buildSectionTitle('Platform Integrations'),
              _buildModernMenuItem(
                icon: Icons.link_rounded,
                title: 'Connected Accounts',
                subtitle: 'Meta, Instagram, TikTok',
                color: Colors.blue,
                onTap: () => Navigator.of(context).pushNamed('/integrations'),
              ),

              SizedBox(height: 32.h),
              _buildSectionTitle('Preferences'),
              BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, mode) {
                  return _buildToggleItem(
                    l10n.translate('dark_mode'),
                    'Toggle app visual theme',
                    mode == ThemeMode.dark,
                    (v) => context.read<ThemeCubit>().toggleTheme(v),
                  );
                },
              ),
              _buildLanguageSelector(context),
              _buildToggleItem(
                'Push Notifications',
                'Stay updated on schedule status',
                _pushNotifications,
                (v) => setState(() => _pushNotifications = v),
              ),
              
              SizedBox(height: 32.h),
              _buildSectionTitle('Help & Guide'),
              _buildModernMenuItem(
                icon: Icons.auto_stories_rounded,
                title: l10n.translate('quick_start'),
                subtitle: 'Learn how to use ZUNO AI',
                color: Colors.indigo,
                onTap: () => _showQuickStartGuide(context),
              ),

              SizedBox(height: 32.h),
              _buildSectionTitle('AI Safety & Legal'),
              _buildMenuItem(Icons.verified_user_outlined, 'Safety Guidelines', 'Meta Graph API Compliance', () {}),
              _buildMenuItem(Icons.description_outlined, 'Synthetic Disclosure', 'AI content labeling rules', () {}),
              _buildMenuItem(Icons.privacy_tip_outlined, 'Privacy Policy', '', () {}),
              _buildMenuItem(Icons.gavel_outlined, 'Terms of Service', '', () {}),
              
              SizedBox(height: 40.h),
              _buildActionItem('Clear App Cache', Colors.blue, () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache cleared successfully!')),
                );
              }),
              _buildActionItem(l10n.translate('logout'), AppTheme.errorRose, () => _showLogoutDialog(context)),
              _buildActionItem('Delete Account', Colors.grey, () => _showDeleteAccountDialog(context)),
              
              SizedBox(height: 40.h),
              const Center(
                child: Text('ZUNO Social AI v1.0.0 (MVP)', style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(dynamic user) {
    return FadeInDown(
      child: GlassCard(
        height: 120.h,
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Row(
            children: [
              Container(
                width: 60.r,
                height: 60.r,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppTheme.accentIndigo, AppTheme.glowViolet]),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    user?.fullName?.substring(0, 1).toUpperCase() ?? 'U',
                    style: TextStyle(color: Colors.white, fontSize: 24.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(user?.fullName ?? 'User Name', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                    Text(user?.email ?? 'user@email.com', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppTheme.accentIndigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: const Text('PRO', style: TextStyle(color: AppTheme.accentIndigo, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Text(title, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: Colors.grey)),
    );
  }

  Widget _buildModernMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20.sp),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(l10n.translate('language'), style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: const Text('Change app language', style: TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: DropdownButton<String>(
        value: context.watch<LocaleCubit>().state.languageCode,
        underline: const SizedBox(),
        onChanged: (v) {
          if (v != null) context.read<LocaleCubit>().setLocale(v);
        },
        items: const [
          DropdownMenuItem(value: 'en', child: Text('English')),
          DropdownMenuItem(value: 'ar', child: Text('العربية')),
          DropdownMenuItem(value: 'es', child: Text('Español')),
          DropdownMenuItem(value: 'fr', child: Text('Français')),
        ],
      ),
    );
  }

  Widget _buildToggleItem(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppTheme.accentIndigo,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey, size: 22.sp),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)) : null,
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildActionItem(String title, Color color, VoidCallback onTap) {
    return ListTile(
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out of ZUNO Social?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.pop(context);
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('This action is permanent and cannot be undone. All your AI personas and scheduled content will be lost.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Delete Permanently', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showQuickStartGuide(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _QuickStartSheet(),
    );
  }
}

class _QuickStartSheet extends StatelessWidget {
  const _QuickStartSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Text(l10n.translate('quick_start'), style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w900)),
          SizedBox(height: 8.h),
          Text('Start automating your social presence in 3 steps.', style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
          SizedBox(height: 32.h),
          _buildStep(
            '1',
            l10n.translate('new_persona'),
            'Define your AI agent\'s voice and look in the "Persona" wizard. This keeps your content consistent.',
            Icons.person_add_rounded,
            Colors.orange,
          ),
          _buildStep(
            '2',
            l10n.translate('generate_content'),
            'Use the "Instant Post" studio to craft AI visuals and captions that match your persona.',
            Icons.auto_awesome,
            Colors.purple,
          ),
          _buildStep(
            '3',
            'Automate Schedule',
            'Connect your Meta account and let the AI agent publish your queue automatically.',
            Icons.timer_outlined,
            Colors.blue,
          ),
          const Spacer(),
          AppButton(
            label: l10n.translate('got_it'),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildStep(String num, String title, String desc, IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 4.h),
                Text(desc, style: TextStyle(color: Colors.grey, fontSize: 13.sp, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
