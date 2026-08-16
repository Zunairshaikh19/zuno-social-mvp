import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zunosocial/app.dart';
import 'package:zunosocial/core/di/injection_container.dart' as di;
import 'package:zunosocial/core/utils/auth_manager.dart';
import 'package:zunosocial/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:zunosocial/core/theme/theme_cubit.dart';
import 'package:zunosocial/core/l10n/locale_cubit.dart';

void main() async {
  print('APP: main() execution started');
  WidgetsFlutterBinding.ensureInitialized();
  print('APP: Flutter Binding initialized');
  
  try {
    // Initialize Dependency Injection
    await di.init();
    print('APP: Dependency Injection initialized');
  } catch (e) {
    print('APP: DI Initialization failed: $e');
  }
  
  runApp(const MainApp());
  print('APP: runApp() called');
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    print('APP: MainApp initState started');
    _authBloc = di.sl<AuthBloc>();
    
    // Add AppStarted in a separate microtask to avoid hanging constructor
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('APP: Adding AppStarted event');
      _authBloc.add(AppStarted());
    });

    // Global listener for session expiry (401 handled by interceptor)
    AuthManager.instance.logoutStream.listen((_) {
      print('APP: Logout requested via AuthManager');
      _authBloc.add(LogoutRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider(create: (_) => di.sl<ThemeCubit>()),
        BlocProvider(create: (_) => di.sl<LocaleCubit>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return const ZunoSocialApp();
        },
      ),
    );
  }
}
