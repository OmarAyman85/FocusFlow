import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_cubit.dart';
import 'package:focusflow/features/workspace/presentation/pages/workspace_form.dart';
import 'package:focusflow/features/workspace/presentation/pages/workspace_page.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/pages/sign_in_page.dart';
import '../features/auth/presentation/pages/sign_up_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => SignInPage()),
    GoRoute(path: '/signin', builder: (context, state) => SignInPage()),
    GoRoute(path: '/signup', builder: (context, state) => SignUpPage()),

    ShellRoute(
      builder: (context, state, child) {
        return BlocProvider(create: (_) => WorkspaceCubit(), child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
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
  ],
);
