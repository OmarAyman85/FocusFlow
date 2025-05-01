import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:focusflow/features/auth/data/repositories/auth_repository.dart';
import 'package:focusflow/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:focusflow/features/auth/domain/repositories/auth_repository.dart';
import 'package:focusflow/features/auth/domain/usecases/sign_in.dart';
import 'package:focusflow/features/auth/domain/usecases/sign_out.dart';
import 'package:focusflow/features/auth/domain/usecases/sign_up.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/workspace/data/repositories/workspace_repository.dart';
import 'package:focusflow/features/workspace/data/sources/workspace_remote_data_source.dart';
import 'package:focusflow/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:focusflow/features/workspace/domain/usecases/create_workspace.dart';
import 'package:focusflow/features/workspace/domain/usecases/get_user_workspaces.dart';
import 'package:focusflow/features/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Firebase services as singletons (they will be needed throughout the app's lifetime)
  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

  // AuthRemoteDataSource as a lazy singleton (created only when needed)
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      auth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  // AuthRepository as a lazy singleton (created only when needed)
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  // Use cases as lazy singletons (created only when needed)
  sl.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignInUseCase>(
    () => SignInUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(sl<AuthRepository>()),
  );

  // Register AuthBloc
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      signUp: sl<SignUpUseCase>(),
      signIn: sl<SignInUseCase>(), // Pass SignInUseCase
      signOut: sl<SignOutUseCase>(),
    ),
  );

  // Register Workspace feature dependencies
  sl.registerLazySingleton<WorkspaceRemoteDataSource>(
    () => WorkspaceRemoteDataSource(sl<FirebaseFirestore>()),
  );

  sl.registerLazySingleton<WorkspaceRepository>(
    () => WorkspaceRepositoryImpl(sl<WorkspaceRemoteDataSource>()),
  );

  sl.registerLazySingleton<GetUserWorkspaces>(
    () => GetUserWorkspaces(sl<WorkspaceRepository>()),
  );

  sl.registerLazySingleton<CreateWorkspace>(
    () => CreateWorkspace(sl<WorkspaceRepository>()),
  );

  sl.registerFactory<WorkspaceBloc>(
    () => WorkspaceBloc(sl<GetUserWorkspaces>(), sl<CreateWorkspace>()),
  );
}
