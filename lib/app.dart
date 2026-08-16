import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zunosocial/core/theme/app_theme.dart';
import 'package:zunosocial/core/theme/theme_cubit.dart';
import 'package:zunosocial/core/l10n/app_localizations.dart';
import 'package:zunosocial/core/l10n/locale_cubit.dart';
import 'package:zunosocial/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:zunosocial/features/auth/presentation/screens/login_screen.dart';
import 'package:zunosocial/features/auth/presentation/screens/register_screen.dart';
import 'package:zunosocial/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:zunosocial/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:zunosocial/features/segments/presentation/screens/segment_wizard_screen.dart';
import 'package:zunosocial/features/ai_studio/presentation/screens/ai_studio_screen.dart';
import 'package:zunosocial/features/subscription/presentation/screens/subscription_screen.dart';
import 'package:zunosocial/features/referral/presentation/screens/referral_screen.dart';
import 'package:zunosocial/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:zunosocial/features/settings/presentation/screens/settings_screen.dart';
import 'package:zunosocial/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:zunosocial/features/queue/presentation/screens/automation_details_screen.dart';
import 'package:zunosocial/features/segments/presentation/screens/persona_style_screen.dart';
import 'package:zunosocial/features/main/presentation/screens/main_shell_screen.dart';
import 'package:zunosocial/features/integrations/presentation/screens/connect_account_screen.dart';

class ZunoSocialApp extends StatelessWidget {
  const ZunoSocialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp(
              title: 'ZUNO Social AI',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              locale: locale,
              supportedLocales: const [
                Locale('en'),
                Locale('ar'),
                Locale('es'),
                Locale('fr'),
              ],
              localizationsDelegates: const [
                AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              home: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is Authenticated) {
                    return const MainShellScreen();
                  }
                  return const LoginScreen();
                },
              ),
              routes: {
                '/login': (_) => const LoginScreen(),
                '/register': (_) => const RegisterScreen(),
                '/forgot-password': (_) => const ForgotPasswordScreen(),
                '/segments': (_) => const SegmentWizardScreen(),
                '/ai-studio': (_) => const AiStudioScreen(),
                '/subscription': (_) => const SubscriptionScreen(),
                '/referral': (_) => const ReferralScreen(),
                '/analytics': (_) => const AnalyticsScreen(),
                '/settings': (_) => const SettingsScreen(),
                '/notifications': (_) => const NotificationsScreen(),
                '/automation-details': (_) => const AutomationDetailsScreen(),
                '/persona-style': (_) => const PersonaStyleScreen(),
                '/integrations': (_) => const ConnectAccountScreen(),
              },
            );
          },
        );
      },
    );
  }
}
