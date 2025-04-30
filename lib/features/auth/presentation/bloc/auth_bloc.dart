import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/features/auth/data/models/user_model.dart';
import 'package:focusflow/features/auth/domain/entities/user_entity.dart';
import 'package:focusflow/injection_container.dart';
// import '../../domain/usecases/get_current_user.dart';
// import '../../domain/usecases/sign_in.dart';
// import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // final SignIn signIn;
  final SignUpUseCase signUp;
  // final SignOut signOut;
  // final GetCurrentUser getCurrentUser;

  AuthBloc({
    // required this.signIn,
    required this.signUp,
    // required this.signOut,
    // required this.getCurrentUser,
  }) : super(AuthInitial()) {
    // on<SignInRequested>((event, emit) async {
    //   emit(AuthLoading());
    //   try {
    //     final user = await signIn(event.email, event.password);
    //     user != null
    //         ? emit(AuthAuthenticated(user))
    //         : emit(AuthUnauthenticated());
    //   } catch (e) {
    //     emit(AuthError(e.toString()));
    //   }
    // });

    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        // final user = await signUp(name: event.name, email: event.email, password: event.password);
        final user = await sl<SignUpUseCase>().call(
          params: UserModel(
            email: event.email,
            name: event.name,
            password: event.password,
            uid: '',
          ),
        );
        emit(AuthAuthenticated(user as AppUser));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    // on<SignOutRequested>((event, emit) async {
    //   await signOut();
    //   emit(AuthUnauthenticated());
    // });

    // on<AppStarted>((event, emit) async {
    //   final user = await getCurrentUser();
    //   user != null
    //       ? emit(AuthAuthenticated(user))
    //       : emit(AuthUnauthenticated());
    // });
  }
}
