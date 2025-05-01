import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_cubit.dart';

class WorkspaceForm extends StatefulWidget {
  final String userId;
  const WorkspaceForm({super.key, required this.userId});

  @override
  State<WorkspaceForm> createState() => _WorkspaceFormState();
}

class _WorkspaceFormState extends State<WorkspaceForm> {
  final _formKey = GlobalKey<FormState>();
  String _workspaceName = '';
  String _workspaceDescription = '';

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      context.read<WorkspaceCubit>().addWorkspace(
        _workspaceName,
        _workspaceDescription,
      );
      Navigator.of(context).pop(); // Return to previous screen
    }
  }

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
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Workspace Description',
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter a description'
                            : null,
                onSaved: (value) => _workspaceDescription = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Create Workspace'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
