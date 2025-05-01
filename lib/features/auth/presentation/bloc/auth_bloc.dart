import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/features/auth/data/models/user_model.dart';
import 'package:focusflow/features/auth/domain/usecases/sign_up.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase signUp;

  AuthBloc({required this.signUp}) : super(AuthInitial()) {
    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final result = await signUp.call(
          params: UserModel(
            email: event.email,
            name: event.name,
            password: event.password,
            uid: '',
          ),
        );

        result.fold(
          (failure) => emit(AuthError(failure.toString())),
          (user) => emit(AuthAuthenticated(user)),
        );
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    // on<SignInRequested>((event, emit) async {
    //   emit(AuthLoading());
    //   try {
    //     // Implement sign-in logic here
    //     // For example, call a sign-in use case and emit the appropriate state
    //   } catch (e) {
    //     emit(AuthError(e.toString()));
    //   }
    // });
  }
}
