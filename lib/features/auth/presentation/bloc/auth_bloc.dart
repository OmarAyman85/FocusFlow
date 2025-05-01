import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/features/auth/data/models/user_model.dart';
import 'package:focusflow/features/auth/domain/usecases/sign_up.dart';
import 'package:focusflow/features/auth/domain/usecases/sign_out.dart';
import 'package:focusflow/features/auth/domain/usecases/sign_in.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase signUp;
  final SignInUseCase signIn; // Add SignInUseCase
  final SignOutUseCase signOut;

  AuthBloc({
    required this.signUp,
    required this.signIn, // Initialize SignInUseCase
    required this.signOut,
  }) : super(AuthInitial()) {
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

    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final result = await signIn.call(
          params: UserModel(
            email: event.email,
            password: event.password,
            name: '',
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

    on<SignOutRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await signOut.call();
        emit(AuthUnauthenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
