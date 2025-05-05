import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/features/auth/presentation/pages/profile_page.dart';
import 'package:focusflow/features/board/presentation/cubit/board_cubit.dart';
import 'package:focusflow/features/board/presentation/pages/board_form.dart';
import 'package:focusflow/features/board/presentation/pages/board_page.dart';
import 'package:focusflow/features/task/domain/entities/task_entity.dart';
import 'package:focusflow/features/task/presentation/pages/task_detail_page.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_cubit.dart';
import 'package:focusflow/features/workspace/presentation/pages/workspace_form.dart';
import 'package:focusflow/features/workspace/presentation/pages/workspace_page.dart';
import 'package:focusflow/features/task/presentation/cubit/task_cubit.dart';
import 'package:focusflow/features/task/presentation/pages/task_form.dart';
import 'package:focusflow/features/task/presentation/pages/task_page.dart';
import 'package:focusflow/core/injection/injection_container.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/pages/sign_in_page.dart';
import '../features/auth/presentation/pages/sign_up_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => SignInPage()),
    GoRoute(path: '/signin', builder: (context, state) => SignInPage()),
    GoRoute(path: '/signup', builder: (context, state) => SignUpPage()),
    GoRoute(path: '/home', builder: (context, state) => ProfilePage()),

    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(create: (_) => sl<WorkspaceCubit>(), child: child);
      },
      routes: [
        GoRoute(
          path: '/workspace',
          builder: (context, state) => const WorkspacePage(),
        ),
        GoRoute(
          path: '/workspace-form/:uid',
          builder: (context, state) {
            final uid = state.pathParameters['uid']!;
            return WorkspaceForm(userId: uid);
          },
        ),
      ],
    ),

    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(create: (_) => sl<BoardCubit>(), child: child);
      },
      routes: [
        GoRoute(
          path: '/workspace/:id/boards',
          builder: (context, state) {
            final workspaceId = state.pathParameters['id']!;
            return BoardPage(workspaceId: workspaceId);
          },
        ),
        GoRoute(
          path: '/workspace/:workspaceId/board-form',
          builder: (context, state) {
            final workspaceId = state.pathParameters['workspaceId']!;
            return BoardFormPage(workspaceId: workspaceId);
          },
        ),
      ],
    ),

    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(create: (_) => sl<TaskCubit>(), child: child);
      },
      routes: [
        GoRoute(
          path: '/workspace/:workspaceId/board/:boardId/tasks',
          builder: (context, state) {
            final workspaceId = state.pathParameters['workspaceId']!;
            final boardId = state.pathParameters['boardId']!;
            return TaskPage(workspaceId: workspaceId, boardId: boardId);
          },
        ),
        GoRoute(
          path: '/workspace/:workspaceId/board/:boardId/task-form',
          builder: (context, state) {
            final workspaceId = state.pathParameters['workspaceId']!;
            final boardId = state.pathParameters['boardId']!;
            return TaskForm(workspaceId: workspaceId, boardId: boardId);
          },
        ),
        GoRoute(
          path: '/workspace/:workspaceId/board/:boardId/task/:taskId',
          builder: (context, state) {
            // Retrieve the task entity and createdByName from extra
            final extra = state.extra as Map<String, dynamic>;
            final task = extra['task'] as TaskEntity;
            final createdByName = extra['createdByName'] as String;

            // Retrieve workspaceId, boardId, and taskId from the route parameters
            final workspaceId = state.pathParameters['workspaceId']!;
            final boardId = state.pathParameters['boardId']!;
            // final taskId = state.pathParameters['taskId']!;

            // Pass all necessary data to the TaskDetailPage
            return TaskDetailPage(
              task: task,
              createdByName: createdByName,
              workspaceId: workspaceId,
              boardId: boardId,
            );
          },
        ),
      ],
    ),
  ],
);
