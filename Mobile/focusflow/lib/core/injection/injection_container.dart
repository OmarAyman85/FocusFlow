import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:focusflow/core/services/user_service.dart';
import 'package:focusflow/features/auth/data/repositories/auth_repository.dart';
import 'package:focusflow/features/auth/data/sources/auth_remote_data_source.dart';
import 'package:focusflow/features/auth/domain/repositories/auth_repository.dart';
import 'package:focusflow/features/auth/domain/usecases/get_all_users_use_case.dart';
import 'package:focusflow/features/auth/domain/usecases/get_current_user.dart';
import 'package:focusflow/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:focusflow/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:focusflow/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/board/data/repositories/board_repository.dart';
import 'package:focusflow/features/board/data/sources/board_remote_data_source.dart';
import 'package:focusflow/features/board/domain/repositories/board_repository.dart';
import 'package:focusflow/features/board/domain/usecases/add_member_to_board_use_case.dart';
import 'package:focusflow/features/board/domain/usecases/create_board_use_case.dart';
import 'package:focusflow/features/board/domain/usecases/delete_board_use_case.dart';
import 'package:focusflow/features/board/domain/usecases/get_boards_use_case.dart';
import 'package:focusflow/features/board/domain/usecases/get_task_count.dart';
import 'package:focusflow/features/board/domain/usecases/update_board_use_case.dart';
import 'package:focusflow/features/board/presentation/cubit/board_cubit.dart';
import 'package:focusflow/features/task/data/repositories/task_repository.dart';
import 'package:focusflow/features/task/data/sources/task_remote_data_source.dart';
import 'package:focusflow/features/task/domain/repositories/task_repository.dart';
import 'package:focusflow/features/task/domain/usecases/create_task_use_case.dart';
import 'package:focusflow/features/task/domain/usecases/delete_task_use_case.dart';
import 'package:focusflow/features/task/domain/usecases/get_tasks_use_case.dart';
import 'package:focusflow/features/task/domain/usecases/update_task_use_case.dart';
import 'package:focusflow/features/task/presentation/cubit/task_cubit.dart';
import 'package:focusflow/features/workspace/data/repositories/workspace_repository.dart';
import 'package:focusflow/features/workspace/data/sources/remote_workspace_data_source.dart';

import 'package:focusflow/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:focusflow/features/workspace/domain/usecases/add_member_to_workspace_use_case.dart';
import 'package:focusflow/features/workspace/domain/usecases/create_workspace.dart';
import 'package:focusflow/features/workspace/domain/usecases/delete_workspace_use_case.dart';
import 'package:focusflow/features/workspace/domain/usecases/get_board_count.dart';
import 'package:focusflow/features/workspace/domain/usecases/get_workspace_use_case.dart';
import 'package:focusflow/features/workspace/domain/usecases/update_workspace_use_case.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_cubit.dart';

import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ***************************************************************************
  // *****************Firebase Services*****************************************
  // ***************************************************************************
  sl.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

  // ***************************************************************************
  // *****************Shared Services*******************************************
  // ***************************************************************************
  sl.registerLazySingleton<UserService>(
    () => UserServiceImpl(firestore: sl<FirebaseFirestore>()),
  );
  // ***************************************************************************
  // *****************Auth Feature**********************************************
  // ***************************************************************************

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

  // ***************************************************************************
  // *****************Workspace Feature*****************************************
  // ***************************************************************************

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
  sl.registerLazySingleton<GetBoardCountUseCase>(() => GetBoardCountUseCase());
  sl.registerLazySingleton<UpdateWorkspaceUseCase>(
    () => UpdateWorkspaceUseCase(),
  );
  sl.registerLazySingleton<DeleteWorkspaceUseCase>(
    () => DeleteWorkspaceUseCase(),
  );

  // Cubit
  sl.registerFactory<WorkspaceCubit>(() => WorkspaceCubit());

  // ***************************************************************************
  // *****************Board Feature*********************************************
  // ***************************************************************************

  // Remote Data Source
  sl.registerLazySingleton<BoardRemoteDataSource>(
    () => BoardRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );

  // Repository
  sl.registerLazySingleton<BoardRepository>(() => BoardRepositoryImpl());

  // Use Cases
  sl.registerLazySingleton<CreateBoardUseCase>(() => CreateBoardUseCase());
  sl.registerLazySingleton<GetBoardsUseCase>(() => GetBoardsUseCase());
  sl.registerLazySingleton<AddMemberToBoardUseCase>(
    () => AddMemberToBoardUseCase(),
  );
  sl.registerLazySingleton<GetTaskCountUseCase>(() => GetTaskCountUseCase());
  sl.registerLazySingleton<DeleteBoardUseCase>(() => DeleteBoardUseCase());
  sl.registerLazySingleton<UpdateBoardUseCase>(() => UpdateBoardUseCase());

  // Cubit
  sl.registerFactory<BoardCubit>(() => BoardCubit());

  // ***************************************************************************
  // *****************Task Feature**********************************************
  // ***************************************************************************

  // Remote Data Source
  sl.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );

  // Repository
  sl.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl());

  // Use Cases
  sl.registerLazySingleton<CreateTaskUseCase>(() => CreateTaskUseCase());
  sl.registerLazySingleton<GetTasksUseCase>(() => GetTasksUseCase());
  sl.registerLazySingleton<DeleteTaskUseCase>(() => DeleteTaskUseCase());
  sl.registerLazySingleton<UpdateTaskUseCase>(() => UpdateTaskUseCase());

  // Cubit
  sl.registerFactory<TaskCubit>(() => TaskCubit());
}
