import 'package:dartz/dartz.dart';
import 'package:zunosocial/core/error/failures.dart';
import 'package:zunosocial/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserModel>> register({
    required String email,
    required String password,
    required String fullName,
    String? referralCode,
  });

  Future<Either<Failure, Unit>> forgotPassword(String email);

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, UserModel?>> getAuthenticatedUser();
}
