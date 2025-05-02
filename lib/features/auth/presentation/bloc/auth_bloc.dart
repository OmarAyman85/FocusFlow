import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/features/auth/data/models/user_model.dart';
import 'package:focusflow/features/auth/domain/usecases/get_all_users_use_case.dart';
import 'package:focusflow/features/auth/domain/usecases/get_current_user.dart';
import 'package:focusflow/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:focusflow/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:focusflow/features/auth/domain/usecases/sign_in_use_case.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignUpUseCase signUp;
  final SignInUseCase signIn;
  final SignOutUseCase signOut;
  final GetCurrentUserUseCase getCurrentUser;
  final GetAllUsersUseCase getAllUsers;

  AuthBloc({
    required this.signUp,
    required this.signIn,
    required this.signOut,
    required this.getCurrentUser,
    required this.getAllUsers,
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

    on<GetCurrentUserRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final result = await getCurrentUser.call();
        result.fold(
          (failure) => emit(AuthError(failure.toString())),
          (user) => emit(AuthAuthenticated(user)),
        );
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<AppStarted>((event, emit) async {
      final result = await getCurrentUser.call();
      result.fold(
        (failure) => emit(AuthUnauthenticated()),
        (user) => emit(AuthAuthenticated(user)),
      );
    });

    on<GetAllUsersRequested>((event, emit) async {
      emit(AuthLoading());
      final result = await getAllUsers.call();
      result.fold(
        (failure) => emit(AuthError(failure.toString())),
        (users) => emit(AuthUsersFetched(users)),
      );
    });
  }
}
