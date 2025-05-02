import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:focusflow/features/auth/data/repositories/auth_repository.dart';
import 'package:focusflow/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:focusflow/features/auth/domain/repositories/auth_repository.dart';
import 'package:focusflow/features/auth/domain/usecases/get_all_users_use_case.dart';
import 'package:focusflow/features/auth/domain/usecases/get_current_user.dart';
import 'package:focusflow/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:focusflow/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:focusflow/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/workspace/data/repositories/workspace_repository.dart';
import 'package:focusflow/features/workspace/data/sources/remote_workspace_data_source.dart';

import 'package:focusflow/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:focusflow/features/workspace/domain/usecases/add_member_to_workspace_use_case.dart';
import 'package:focusflow/features/workspace/domain/usecases/create_workspace.dart';
import 'package:focusflow/features/workspace/domain/usecases/get_users_use_case.dart';
import 'package:focusflow/features/workspace/domain/usecases/get_workspace_use_case.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_cubit.dart';

import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Firebase services
  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

  // Auth Feature
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      auth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  sl.registerLazySingleton<SignUpUseCase>(() => SignUpUseCase());
  sl.registerLazySingleton<SignInUseCase>(() => SignInUseCase());
  sl.registerLazySingleton<SignOutUseCase>(() => SignOutUseCase());
  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(),
  );
  sl.registerLazySingleton<GetAllUsersUseCase>(() => GetAllUsersUseCase());

  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      signUp: sl<SignUpUseCase>(),
      signIn: sl<SignInUseCase>(),
      signOut: sl<SignOutUseCase>(),
      getCurrentUser: sl<GetCurrentUserUseCase>(),
      getAllUsers: sl<GetAllUsersUseCase>(),
    ),
  );

  // Workspace Feature
  // Remote Data Source
  sl.registerLazySingleton<WorkspaceRemoteDataSource>(
    () => WorkspaceRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );

  // Repository
  sl.registerLazySingleton<WorkspaceRepository>(
    () => WorkspaceRepositoryImpl(
      remoteDataSource: sl<WorkspaceRemoteDataSource>(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton<CreateWorkspaceUseCase>(
    () => CreateWorkspaceUseCase(),
  );
  sl.registerLazySingleton<GetWorkspacesUseCase>(() => GetWorkspacesUseCase());
  sl.registerLazySingleton<AddMemberToWorkspaceUseCase>(
    () => AddMemberToWorkspaceUseCase(),
  );
  sl.registerLazySingleton<GetUsersUseCase>(() => GetUsersUseCase());

  // Cubit
  sl.registerFactory<WorkspaceCubit>(
    () => WorkspaceCubit(
      createWorkspaceUseCase: sl<CreateWorkspaceUseCase>(),
      getWorkspacesUseCase: sl<GetWorkspacesUseCase>(),
      addMemberToWorkspaceUseCase: sl<AddMemberToWorkspaceUseCase>(),
      getUsersUseCase: sl<GetUsersUseCase>(),
    ),
  );
}
