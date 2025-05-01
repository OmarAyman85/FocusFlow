import 'package:flutter/material.dart';
import 'package:focusflow/core/temporary/home_page.dart';
import 'package:focusflow/features/workspace/presentation/bloc/workspace_bloc.dart';
import 'package:focusflow/features/workspace/presentation/bloc/workspace_event.dart';
import 'package:focusflow/features/workspace/presentation/pages/workspace_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/injection_container.dart';
import '../features/auth/presentation/pages/sign_in_page.dart';
import '../features/auth/presentation/pages/sign_up_page.dart';
import 'package:focusflow/features/workspace/presentation/pages/create_workspace_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => SignInPage()),

    GoRoute(path: '/signin', builder: (context, state) => SignInPage()),
    GoRoute(path: '/signup', builder: (context, state) => SignUpPage()),

    GoRoute(path: '/home', builder: (context, state) => HomePage()),

    GoRoute(
      path: '/workspace',
      builder: (context, state) {
        final userId = state.uri.queryParameters['uid'];
        if (userId == null) {
          return const Center(child: Text("User ID is missing"));
        }
        return BlocProvider(
          create: (_) => sl<WorkspaceBloc>()..add(LoadWorkspaces(userId)),
          child: WorkspaceScreen(userId: userId),
        );
      },
    ),

    GoRoute(
      path: '/create-workspace',
      builder: (context, state) {
        final userId = state.uri.queryParameters['uid'];
        if (userId == null) {
          return const Center(child: Text("User ID is missing"));
        }
        return BlocProvider(
          create: (_) => sl<WorkspaceBloc>(),
          child: CreateWorkspaceScreen(userId: userId),
        );
      },
    ),
  ],
);
