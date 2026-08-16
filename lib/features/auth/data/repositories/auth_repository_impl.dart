import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zunosocial/core/error/app_exceptions.dart';
import 'package:zunosocial/core/error/failures.dart';
import 'package:zunosocial/features/auth/domain/repositories/auth_repository.dart';
import 'package:zunosocial/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:zunosocial/features/auth/data/models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage storage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.storage,
  });

  @override
  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    // --- TESTING BYPASS ---
    if (email == 'test@zuno.ai' && password == 'password123') {
      final mockUser = UserModel(
        id: 'mock_user_123',
        email: email,
        fullName: 'Test Creator',
        planType: 'Pro',
      );
      await storage.write(key: 'access_token', value: 'mock_jwt_token_xyz');
      await storage.write(key: 'user_data', value: jsonEncode(mockUser.toJson()));
      return Right(mockUser);
    }
    // -----------------------

    try {
      final data = await remoteDataSource.login(email, password);
      final user = UserModel.fromJson(data['user']);
      final token = data['token'] as String;

      await storage.write(key: 'access_token', value: token);
      await storage.write(key: 'user_data', value: jsonEncode(user.toJson()));

      return Right(user);
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> register({
    required String email,
    required String password,
    required String fullName,
    String? referralCode,
  }) async {
    try {
      final data = await remoteDataSource.register(email, password, fullName, referralCode);
      final user = UserModel.fromJson(data['user']);
      final token = data['token'] as String;

      await storage.write(key: 'access_token', value: token);
      await storage.write(key: 'user_data', value: jsonEncode(user.toJson()));

      return Right(user);
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, Unit>> forgotPassword(String email) async {
    try {
      await remoteDataSource.forgotPassword(email);
      return const Right(unit);
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    await storage.deleteAll();
    return const Right(unit);
  }

  @override
  Future<Either<Failure, UserModel?>> getAuthenticatedUser() async {
    final userData = await storage.read(key: 'user_data');
    if (userData != null) {
      return Right(UserModel.fromJson(jsonDecode(userData)));
    }
    return const Right(null);
  }
}
