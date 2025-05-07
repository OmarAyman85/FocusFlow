import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/injection/injection_container.dart';
import 'package:focusflow/core/services/add_member_dialog.dart';
import 'package:focusflow/core/services/user_service.dart';
import 'package:focusflow/core/widgets/text_form_field_widget.dart';
import 'package:focusflow/features/workspace/domain/entities/workspace.dart';
import 'package:focusflow/features/workspace/presentation/cubit/workspace_cubit.dart';
import 'package:focusflow/features/workspace/presentation/widgets/workspace_submit_button.dart';
import 'package:focusflow/core/entities/member.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class WorkspaceFormFields extends StatefulWidget {
  final String userId;
  final String userName;

  const WorkspaceFormFields({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  State<WorkspaceFormFields> createState() => _WorkspaceFormFieldsState();
}

class _WorkspaceFormFieldsState extends State<WorkspaceFormFields> {
  final _formKey = GlobalKey<FormState>();
  String _workspaceName = '';
  String _workspaceDescription = '';
  final int _workspacenumberOfBoards = 0;

  final List<Member> _members = [];

  @override
  void initState() {
    super.initState();
    _members.add(Member(id: widget.userId, name: widget.userName));
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      final newWorkspace = Workspace(
        id: const Uuid().v4(),
        name: _workspaceName,
        description: _workspaceDescription,
        numberOfMembers: _members.length,
        numberOfBoards: _workspacenumberOfBoards,
        createdById: widget.userId,
        createdByName: widget.userName,
        members: _members,
      );

      context.read<WorkspaceCubit>().createWorkspace(
        newWorkspace,
        widget.userId,
      );
      GoRouter.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextFormField(
              label: 'Workspace Name',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Workspace name is required';
                }
                if (value.trim().length < 3) {
                  return 'Name must be at least 3 characters';
                }
                if (value.trim().length > 50) {
                  return 'Name must be under 50 characters';
                }
                return null;
              },
              onSaved: (value) => _workspaceName = value ?? '',
            ),
            const SizedBox(height: 20),
            AppTextFormField(
              label: 'Workspace Description',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Description is required';
                }
                if (value.trim().length < 10) {
                  return 'Description must be at least 10 characters';
                }
                return null;
              },
              onSaved: (value) => _workspaceDescription = value ?? '',
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                const Text(
                  'Members:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.person_add),
                  onPressed:
                      () => AddMemberDialog.open(
                        context: context,
                        title: 'Add Workspace Member',
                        getUsers: () => sl<UserService>().getUsers(),
                        onUserSelected: (selectedUser) {
                          final alreadyExists = _members.any(
                            (m) => m.id == selectedUser.id,
                          );
                          if (!alreadyExists) {
                            setState(() {
                              _members.add(selectedUser);
                            });
                          }
                          return Future.value();
                        },
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children:
                  _members
                      .map(
                        (member) => Chip(
                          label: Text(member.name),
                          onDeleted:
                              member.id == widget.userId
                                  ? null
                                  : () {
                                    setState(() {
                                      _members.removeWhere(
                                        (m) => m.id == member.id,
                                      );
                                    });
                                  },
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 20),
            Center(child: WorkspaceSubmitButton(onPressed: _submitForm)),
          ],
        ),
      ),
    );
  }
}
