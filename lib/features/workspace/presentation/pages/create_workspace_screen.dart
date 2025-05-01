import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/workspace_bloc.dart';
import '../bloc/workspace_event.dart';

class CreateWorkspaceScreen extends StatefulWidget {
  final String userId;

  const CreateWorkspaceScreen({super.key, required this.userId});

  @override
  State<CreateWorkspaceScreen> createState() => _CreateWorkspaceScreenState();
}

class _CreateWorkspaceScreenState extends State<CreateWorkspaceScreen> {
  final _formKey = GlobalKey<FormState>();
  String _workspaceName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Workspace')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Workspace Name'),
                validator:
                    (value) =>
                        value == null || value.isEmpty ? 'Enter a name' : null,
                onSaved: (value) => _workspaceName = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState!.save();
                    context.read<WorkspaceBloc>().add(
                      SubmitWorkspaceForm(
                        name: _workspaceName,
                        userId: widget.userId,
                      ),
                    );
                    context.push('/workspace?uid=${widget.userId}');
                  }
                },
                child: const Text('Create Workspace'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
