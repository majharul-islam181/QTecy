import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qtechy/feature/auth/domain/usecase/login_use_case.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/storage_service.dart';
// import '../../domain/entities/user.dart';
import 'login_state.dart';


class LoginCubit extends Cubit<LoginState> { 
  final LoginUseCase loginUseCase;
  final StorageService storageService;

  LoginCubit({required this.loginUseCase, required this.storageService}) : super(LoginInitial());

  Future<void> loginUser(String email, String password) async {
    emit(LoginLoading());

    final result = await loginUseCase(LoginParams(email: email, password: password));

    result.fold(
      (failure) {
        emit(LoginError(message: _mapFailureToMessage(failure)));
      },
      (user) async {
        await storageService.saveToken(user.token);
        await storageService.saveUserData(user);
        emit(LoginSuccess(user: user));
      },
    );
  }


  Future<void> logoutUser() async {
  await storageService.clearData();
  emit(LoginInitial()); 
}


String _mapFailureToMessage(Failure failure) {
  if (failure is ServerFailure) {
    return failure.error;
  } else if (failure is ApiFailure) {
    return failure.error;
  } else if (failure is DioFailure) {
    return failure.error; 
  } else {
    return 'Unexpected error occurred.';
  }
}
}

