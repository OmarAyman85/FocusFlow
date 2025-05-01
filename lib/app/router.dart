import 'package:focusflow/core/temporary/home_page.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/pages/sign_in_page.dart';
import '../features/auth/presentation/pages/sign_up_page.dart';

final router = GoRouter(
  routes: [
    // Home screen route
    GoRoute(path: '/home', builder: (context, state) => HomePage()),
    // SignIn screen route
    GoRoute(path: '/signin', builder: (context, state) => SignInPage()),

    // SignUp screen route
    GoRoute(path: '/signup', builder: (context, state) => SignUpPage()),

    // Default route (if user is not authenticated, or on the first visit)
    GoRoute(path: '/', builder: (context, state) => SignInPage()),
  ],
);
