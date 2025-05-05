import 'package:flutter/material.dart';
import 'package:focusflow/core/theme/app_pallete.dart';
import 'package:focusflow/core/widgets/text_form_field_widget.dart';
import 'package:focusflow/core/entities/member.dart';

class BoardFormFields extends StatelessWidget {
  final FormFieldSetter<String> onNameSaved;
  final FormFieldSetter<String> onDescriptionSaved;
  final VoidCallback onSubmit;
  final List<Member> members;
  final VoidCallback onAddMember;
  final String creatorId;
  final void Function(String memberId) onRemoveMember;

  const BoardFormFields({
    super.key,
    required this.onNameSaved,
    required this.onDescriptionSaved,
    required this.onSubmit,
    required this.members,
    required this.onAddMember,
    required this.creatorId,
    required this.onRemoveMember,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextFormField(
          label: 'Board Name',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Board name is required';
            }
            if (value.trim().length < 3) {
              return 'Name must be at least 3 characters';
            }
            if (value.trim().length > 50) {
              return 'Name must be under 50 characters';
            }
            return null;
          },
          onSaved: onNameSaved,
        ),
        const SizedBox(height: 20),
        AppTextFormField(
          label: 'Board Description',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Description is required';
            }
            if (value.trim().length < 10) {
              return 'Description must be at least 10 characters';
            }
            return null;
          },
          onSaved: onDescriptionSaved,
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
              onPressed: onAddMember,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 8,
            children:
                members.map((member) {
                  return Chip(
                    label: Text(member.name),
                    onDeleted:
                        member.id == creatorId
                            ? null
                            : () => onRemoveMember(member.id),
                  );
                }).toList(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppPallete.backgroundColor,
            foregroundColor: AppPallete.gradient1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text('Create Board'),
        ),
      ],
    );
  }
}
