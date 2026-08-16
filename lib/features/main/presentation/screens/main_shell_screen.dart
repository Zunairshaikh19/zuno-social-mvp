import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:zunosocial/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:zunosocial/features/queue/presentation/screens/queue_screen.dart';
import 'package:zunosocial/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:zunosocial/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/l10n/app_localizations.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const QueueScreen(),
    const AnalyticsScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_selectedIndex],
      ),
      floatingActionButton: FadeInUp(
        duration: const Duration(milliseconds: 500),
        child: FloatingActionButton(
          onPressed: () => Navigator.of(context).pushNamed('/ai-studio'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          highlightElevation: 0,
          child: Container(
            width: 56.r,
            height: 56.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor,
                  const Color(0xFF8B5CF6), // Glow Violet
                ],
              ),
            ),
            child: Icon(Icons.auto_awesome, color: Colors.white, size: 28.sp),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        elevation: 0,
        padding: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: Container(
          height: 70.h,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(
                color: isDark ? const Color(0xFF1F2937) : Colors.grey.shade200,
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.grid_view_rounded, Icons.grid_view_rounded, l10n.translate('dashboard')),
              _buildNavItem(1, Icons.calendar_today_rounded, Icons.calendar_today_rounded, l10n.translate('schedule')),
              SizedBox(width: 40.w), // Space for FAB
              _buildNavItem(2, Icons.analytics_outlined, Icons.analytics_rounded, l10n.translate('growth_reports')),
              _buildNavItem(3, Icons.person_outline_rounded, Icons.person_rounded, l10n.translate('profile')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? Theme.of(context).primaryColor : Colors.grey;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onItemTapped(index),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isSelected
                  ? _GlowIcon(icon: activeIcon)
                  : Icon(icon, color: color, size: 24.sp),
              SizedBox(height: 4.h),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 10.sp,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlowIcon extends StatelessWidget {
  final IconData icon;
  const _GlowIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(icon, color: Theme.of(context).primaryColor, size: 24.sp),
      ),
    );
  }
}
