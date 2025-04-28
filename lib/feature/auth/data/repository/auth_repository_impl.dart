import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/return_failure.dart';
import '../../../../core/network/return_response.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/login_response.dart';


class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;

  AuthRepositoryImpl({required this.apiClient});

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final response = await apiClient.dio.post('/auth/login', data: {
        "email": email,
        "password": password,
      });

      // Parse flat JSON directly into LoginResponse
      final loginResponse = ReturnResponse<LoginResponse>()
          .call(response, (data) => LoginResponse.fromJson(data));

      final user = User(
        id: loginResponse.id,           
        name: loginResponse.name,
        email: loginResponse.email,
        mobile: loginResponse.phone,
        token: loginResponse.token,
      );

      return Right(user);
    } catch (e) {
      return ReturnFailure<User>().call(Exception(e.toString()));
    }
  }
}