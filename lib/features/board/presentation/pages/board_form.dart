import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/widgets/main_app_bar_widget.dart';
import 'package:focusflow/core/widgets/text_form_field_widget.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_state.dart';
import 'package:focusflow/features/board/domain/entities/board.dart';
import 'package:focusflow/core/entities/member.dart';
import 'package:focusflow/features/board/presentation/cubit/board_cubit.dart';
import 'package:uuid/uuid.dart';

class BoardForm extends StatefulWidget {
  final String workspaceId;
  const BoardForm({super.key, required this.workspaceId});

  @override
  State<BoardForm> createState() => _BoardFormState();
}

class _BoardFormState extends State<BoardForm> {
  final _formKey = GlobalKey<FormState>();
  String _boardName = '';
  String _boardDescription = '';

  void _submitForm(String userId, String userName) {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      final newBoard = Board(
        id: const Uuid().v4(),
        name: _boardName,
        description: _boardDescription,
        numberOfMembers: 1,
        numberOfTasks: 0,
        workspaceId: widget.workspaceId,
        createdById: userId,
        createdByName: userName,
        members: [Member(id: userId, name: userName)],
      );

      context.read<BoardCubit>().createBoard(newBoard);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final userId = state.user.uid;
          final userName = state.user.name;

          return Scaffold(
            appBar: MainAppBar(title: 'Create Board',),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextFormField(
                      label: 'Board Name',
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Required'
                                  : null,
                      onSaved: (value) => _boardName = value ?? '',
                    ),
                    const SizedBox(height: 20),
                    AppTextFormField(
                      label: 'Board Description',
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Required'
                                  : null,
                      onSaved: (value) => _boardDescription = value ?? '',
                    ),
                    const SizedBox(height: 20),
                    // Add a member selection widget here to populate the members list
                    // You would want to provide a way for the user to select members and add them to _members
                    ElevatedButton(
                      onPressed: () => _submitForm(userId, userName),
                      child: const Text('Create Board'),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
