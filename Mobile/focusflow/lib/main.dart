import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_event.dart';
import 'package:focusflow/core/injection/injection_container.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'firebase_options.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await init();

  runApp(
    BlocProvider<AuthBloc>(
      create: (context) => sl<AuthBloc>()..add(AppStarted()),
      child: const MyApp(),
    ),
  );
}
