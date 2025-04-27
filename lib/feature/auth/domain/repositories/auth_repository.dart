import 'package:dartz/dartz.dart';
import 'package:qtechy/feature/auth/domain/entities/user.dart';
import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
}