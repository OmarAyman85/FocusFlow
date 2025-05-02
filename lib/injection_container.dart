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
import 'package:focusflow/features/project/data/repositories/project_repository.dart';
import 'package:focusflow/features/project/data/sources/project_remote_data_source.dart';
import 'package:focusflow/features/project/domain/repositories/project_repository.dart';
import 'package:focusflow/features/project/domain/usecases/add_member_to_project_use_case.dart';
import 'package:focusflow/features/project/domain/usecases/create_page_use_case.dart';
import 'package:focusflow/features/project/domain/usecases/get_projects_use_case.dart';
import 'package:focusflow/features/project/domain/usecases/get_users_use_case.dart';
import 'package:focusflow/features/project/presentation/cubit/project_cubit.dart';
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
  // Remote Data Source
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      auth: sl<FirebaseAuth>(),
      firestore: sl<FirebaseFirestore>(),
    ),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());

  // Use Cases
  sl.registerLazySingleton<SignUpUseCase>(() => SignUpUseCase());
  sl.registerLazySingleton<SignInUseCase>(() => SignInUseCase());
  sl.registerLazySingleton<SignOutUseCase>(() => SignOutUseCase());
  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(),
  );
  sl.registerLazySingleton<GetAllUsersUseCase>(() => GetAllUsersUseCase());

  // Bloc
  sl.registerFactory<AuthBloc>(() => AuthBloc());

  // Workspace Feature
  // Remote Data Source
  sl.registerLazySingleton<WorkspaceRemoteDataSource>(
    () => WorkspaceRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );

  // Repository
  sl.registerLazySingleton<WorkspaceRepository>(
    () => WorkspaceRepositoryImpl(),
  );

  // Use Cases
  sl.registerLazySingleton<CreateWorkspaceUseCase>(
    () => CreateWorkspaceUseCase(),
  );
  sl.registerLazySingleton<GetWorkspacesUseCase>(() => GetWorkspacesUseCase());
  sl.registerLazySingleton<AddMemberToWorkspaceUseCase>(
    () => AddMemberToWorkspaceUseCase(),
  );
  sl.registerLazySingleton<GetWorkspaceUsersUseCase>(
    () => GetWorkspaceUsersUseCase(),
  );

  // Cubit
  sl.registerFactory<WorkspaceCubit>(() => WorkspaceCubit());

  // Project Feature
  // Remote Data Source
  sl.registerLazySingleton<ProjectRemoteDataSource>(
    () => ProjectRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );

  // Repository
  sl.registerLazySingleton<ProjectRepository>(() => ProjectRepositoryImpl());

  // Use Cases
  sl.registerLazySingleton<CreateProjectUseCase>(() => CreateProjectUseCase());
  sl.registerLazySingleton<GetProjectsUseCase>(() => GetProjectsUseCase());
  sl.registerLazySingleton<AddMemberToProjectUseCase>(
    () => AddMemberToProjectUseCase(),
  );
  sl.registerLazySingleton<GetProjectUsersUseCase>(
    () => GetProjectUsersUseCase(),
  );

  // Cubit
  sl.registerFactory<ProjectCubit>(() => ProjectCubit());
}
