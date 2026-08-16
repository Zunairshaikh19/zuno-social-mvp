import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zunosocial/core/api/dio_client.dart';
import 'package:zunosocial/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:zunosocial/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:zunosocial/features/auth/domain/repositories/auth_repository.dart';
import 'package:zunosocial/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:zunosocial/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:zunosocial/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:zunosocial/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:zunosocial/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:zunosocial/features/segments/data/datasources/segments_remote_data_source.dart';
import 'package:zunosocial/features/segments/data/repositories/segments_repository_impl.dart';
import 'package:zunosocial/features/segments/domain/repositories/segments_repository.dart';
import 'package:zunosocial/features/segments/presentation/bloc/segment_wizard_bloc.dart';
import 'package:zunosocial/features/queue/data/datasources/queue_remote_data_source.dart';
import 'package:zunosocial/features/queue/data/repositories/queue_repository_impl.dart';
import 'package:zunosocial/features/queue/domain/repositories/queue_repository.dart';
import 'package:zunosocial/features/queue/presentation/bloc/queue_bloc.dart';
import 'package:zunosocial/features/subscription/data/datasources/subscription_remote_data_source.dart';
import 'package:zunosocial/features/subscription/data/repositories/subscription_repository_impl.dart';
import 'package:zunosocial/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:zunosocial/features/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:zunosocial/features/referral/data/datasources/referral_remote_data_source.dart';
import 'package:zunosocial/features/referral/data/repositories/referral_repository_impl.dart';
import 'package:zunosocial/features/referral/domain/repositories/referral_repository.dart';
import 'package:zunosocial/features/referral/presentation/bloc/referral_bloc.dart';
import 'package:zunosocial/features/analytics/data/datasources/analytics_remote_data_source.dart';
import 'package:zunosocial/features/analytics/data/repositories/analytics_repository_impl.dart';
import 'package:zunosocial/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:zunosocial/features/analytics/presentation/bloc/analytics_bloc.dart';
import 'package:zunosocial/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:zunosocial/features/integrations/data/datasources/integrations_remote_data_source.dart';
import 'package:zunosocial/features/integrations/data/repositories/integrations_repository_impl.dart';
import 'package:zunosocial/features/integrations/domain/repositories/integrations_repository.dart';
import 'package:zunosocial/features/integrations/presentation/bloc/integrations_bloc.dart';
import 'package:zunosocial/features/ai_studio/data/datasources/ai_remote_data_source.dart';
import 'package:zunosocial/features/ai_studio/presentation/bloc/ai_studio_bloc.dart';
import 'package:zunosocial/core/theme/theme_cubit.dart';
import 'package:zunosocial/core/l10n/locale_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  print('DI: Starting initialization...');
  
  // External Tools
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  print('DI: External tools registered');

  // Core Networking
  sl.registerLazySingleton(() => DioClient(storage: sl()));
  sl.registerLazySingleton<Dio>(() => sl<DioClient>().dio);
  print('DI: Networking registered');

  // BLoCs
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
  sl.registerFactory(() => DashboardBloc(
        dashboardRepository: sl(),
        segmentsRepository: sl(),
      ));
  sl.registerFactory(() => SegmentWizardBloc(segmentsRepository: sl()));
  sl.registerFactory(() => QueueBloc(queueRepository: sl()));
  sl.registerFactory(() => IntegrationsBloc(repository: sl()));
  sl.registerFactory(() => AiStudioBloc(
        aiRemoteDataSource: sl(),
        queueRepository: sl(),
        segmentsRepository: sl(),
      ));
  sl.registerFactory(() => SubscriptionBloc(subscriptionRepository: sl()));
  sl.registerFactory(() => ReferralBloc(referralRepository: sl()));
  sl.registerFactory(() => AnalyticsBloc(analyticsRepository: sl()));
  sl.registerFactory(() => NotificationsBloc());
  sl.registerLazySingleton(() => ThemeCubit(prefs: sl()));
  sl.registerLazySingleton(() => LocaleCubit(prefs: sl()));
  print('DI: BLoCs registered');

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        remoteDataSource: sl(),
        storage: sl(),
      ));
  sl.registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<SegmentsRepository>(
      () => SegmentsRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<QueueRepository>(
      () => QueueRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<IntegrationsRepository>(
      () => IntegrationsRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<SubscriptionRepository>(
      () => SubscriptionRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<ReferralRepository>(
      () => ReferralRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<AnalyticsRepository>(
      () => AnalyticsRepositoryImpl(remoteDataSource: sl()));

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<DashboardRemoteDataSource>(
      () => DashboardRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<AiRemoteDataSource>(
      () => AiRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<SegmentsRemoteDataSource>(
      () => SegmentsRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<QueueRemoteDataSource>(
      () => QueueRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<SubscriptionRemoteDataSource>(
      () => SubscriptionRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<IntegrationsRemoteDataSource>(
      () => IntegrationsRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<ReferralRemoteDataSource>(
      () => ReferralRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<AnalyticsRemoteDataSource>(
      () => AnalyticsRemoteDataSourceImpl(dio: sl()));
  
  print('DI: Initialization complete');
}
