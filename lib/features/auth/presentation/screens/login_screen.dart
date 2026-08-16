import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zunosocial/core/widgets/app_widgets.dart';
import 'package:zunosocial/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            LoginRequested(_emailController.text.trim(), _passwordController.text),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.of(context).pushReplacementNamed('/dashboard');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: Stack(
          children: [
            // Background Elements
            _buildBackground(),
            
            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 60.h),
                      FadeInDown(
                        duration: const Duration(milliseconds: 600),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.r),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Icon(Icons.auto_awesome_rounded, color: Theme.of(context).primaryColor, size: 32.sp),
                            ),
                            SizedBox(height: 24.h),
                            Text(
                              'ZUNO AI',
                              style: TextStyle(
                                fontSize: 32.sp,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              l10n.translate('run_autopilot'),
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50.h),
                      FadeInUp(
                        duration: const Duration(milliseconds: 600),
                        child: Column(
                          children: [
                            AppTextField(
                              label: l10n.translate('email_address'),
                              hint: 'name@work.com',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icon(Icons.alternate_email_rounded, size: 20.sp),
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Email is required';
                                if (!value.contains('@')) return 'Enter a valid email';
                                return null;
                              },
                            ),
                            SizedBox(height: 20.h),
                            AppTextField(
                              label: l10n.translate('password'),
                              hint: '••••••••',
                              controller: _passwordController,
                              isPassword: _obscurePassword,
                              prefixIcon: Icon(Icons.lock_outline_rounded, size: 20.sp),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                  size: 18.sp,
                                ),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) return 'Password is required';
                                return null;
                              },
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () => Navigator.of(context).pushNamed('/forgot-password'),
                                child: Text(l10n.translate('forgot_password'), style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.sp)),
                              ),
                            ),
                            SizedBox(height: 32.h),
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                return AppButton(
                                  label: l10n.translate('sign_in'),
                                  isLoading: state is AuthLoading,
                                  onPressed: _onLogin,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.h),
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Expanded(child: Divider()),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                                  child: Text(
                                    l10n.translate('alternative_login'),
                                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12.sp, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const Expanded(child: Divider()),
                              ],
                            ),
                            SizedBox(height: 24.h),
                            Row(
                              children: [
                                Expanded(
                                  child: _SocialButton(
                                    icon: FontAwesomeIcons.google,
                                    label: 'Google',
                                    onTap: () {},
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: _SocialButton(
                                    icon: FontAwesomeIcons.apple,
                                    label: 'Apple',
                                    onTap: () {},
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 40.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(l10n.translate('new_to_zuno'), style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pushNamed('/register'),
                                  child: Text(l10n.translate('create_account'), style: TextStyle(fontWeight: FontWeight.w800, color: Theme.of(context).primaryColor)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned(
      top: -100.h,
      right: -100.w,
      child: Container(
        width: 300.r,
        height: 300.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor.withOpacity(0.05),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final dynamic icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(icon, size: 18.sp),
              SizedBox(width: 10.w),
              Text(label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp)),
            ],
          ),
        ),
      ),
    );
  }
}
