import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:qtechy/core/error/failures.dart';
import 'package:qtechy/feature/auth/domain/usecase/login_use_case.dart';
import 'package:qtechy/feature/auth/presentation/cubit/login_cubit.dart';
import 'package:qtechy/feature/auth/domain/entities/user.dart';
import 'package:qtechy/core/services/storage_service.dart';
import 'package:qtechy/feature/auth/presentation/cubit/login_state.dart';


class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockStorageService extends Mock implements StorageService {}

void main() {
  late LoginCubit loginCubit;
  late MockLoginUseCase mockLoginUseCase;
  late MockStorageService mockStorageService;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockStorageService = MockStorageService();
    loginCubit = LoginCubit(
      loginUseCase: mockLoginUseCase,
      storageService: mockStorageService,
    );
  });

  group('LoginCubit Tests', () {
    test('should emit LoginSuccess state when login is successful', () async {
      // Arrange
      final user = User(
        id: '123',
        name: 'Test User',
        email: 'test@example.com',
        mobile: '123456789',
        token: 'some_token',
      );
      when(mockLoginUseCase.call(any)).thenAnswer(
        (_) async => Right(user),
      );

      // Act
      loginCubit.loginUser('test@example.com', 'password');

      // Assert
      expectLater(
        loginCubit.stream,
        emitsInOrder([
          LoginLoading(),
          LoginSuccess(user: user),
        ]),
      );
    });

    test('should emit LoginError state when login fails', () async {
      // Arrange
      final failure = ServerFailure(error: 'Server Error');
      when(mockLoginUseCase.call(any)).thenAnswer(
        (_) async => Left(failure),
      );

      // Act
      loginCubit.loginUser('wrong_email@example.com', 'wrong_password');

      // Assert
      expectLater(
        loginCubit.stream,
        emitsInOrder([
          LoginLoading(),
          LoginError(message: 'Server Error'),
        ]),
      );
    });

    test('should emit LoginLoading state when login is in progress', () async {
      // Arrange
      when(mockLoginUseCase.call(any)).thenAnswer(
        (_) async => Right(User(
          id: '123',
          name: 'Test User',
          email: 'test@example.com',
          mobile: '123456789',
          token: 'some_token',
        )),
      );

      // Act
      loginCubit.loginUser('test@example.com', 'password');

      // Assert
      expect(loginCubit.state, LoginLoading());
    });
  });
}
