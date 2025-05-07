import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/injection/injection_container.dart';
import 'package:focusflow/core/services/add_member_dialog.dart';
import 'package:focusflow/core/services/user_service.dart';
import 'package:focusflow/core/widgets/main_app_bar_widget.dart';
import 'package:focusflow/features/board/domain/entities/board.dart';
import 'package:focusflow/core/entities/member.dart';
import 'package:focusflow/features/board/presentation/cubit/board_cubit.dart';
import 'package:uuid/uuid.dart';
import 'board_form_fields.dart';

class BoardForm extends StatefulWidget {
  final String workspaceId;
  final String userId;
  final String userName;

  const BoardForm({
    super.key,
    required this.workspaceId,
    required this.userId,
    required this.userName,
  });

  @override
  State<BoardForm> createState() => _BoardFormState();
}

class _BoardFormState extends State<BoardForm> {
  final _formKey = GlobalKey<FormState>();
  String _boardName = '';
  String _boardDescription = '';
  final List<Member> _members = [];

  @override
  void initState() {
    super.initState();
    _members.add(Member(id: widget.userId, name: widget.userName));
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      final newBoard = Board(
        id: const Uuid().v4(),
        name: _boardName,
        description: _boardDescription,
        numberOfMembers: _members.length,
        numberOfTasks: 0,
        workspaceId: widget.workspaceId,
        createdById: widget.userId,
        createdByName: widget.userName,
        members: _members,
      );

      context.read<BoardCubit>().createBoard(newBoard);
      Navigator.of(context).pop();
    }
  }

  void _addMember(BuildContext context) {
    AddMemberDialog.open(
      context: context,
      title: 'Add Board Member',
      getUsers: () => sl<UserService>().getWorkspaceMembers(widget.workspaceId),
      onUserSelected: (selectedUser) {
        final alreadyExists = _members.any((m) => m.id == selectedUser.id);
        if (!alreadyExists) {
          setState(() {
            _members.add(selectedUser);
          });
        }
        return Future.value();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: 'Create Board'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              BoardFormFields(
                onNameSaved: (val) => _boardName = val ?? '',
                onDescriptionSaved: (val) => _boardDescription = val ?? '',
                onSubmit: _submitForm,
                members: _members,
                onAddMember: () => _addMember(context),
                creatorId: widget.userId,
                onRemoveMember: (id) {
                  setState(() {
                    _members.removeWhere((m) => m.id == id);
                  });
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
