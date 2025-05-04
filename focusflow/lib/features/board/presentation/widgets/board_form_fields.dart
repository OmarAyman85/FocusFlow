import 'package:flutter/material.dart';
import 'package:focusflow/core/theme/app_pallete.dart';
import 'package:focusflow/core/widgets/text_form_field_widget.dart';

class BoardFormFields extends StatelessWidget {
  final FormFieldSetter<String> onNameSaved;
  final FormFieldSetter<String> onDescriptionSaved;
  final VoidCallback onSubmit;

  const BoardFormFields({
    super.key,
    required this.onNameSaved,
    required this.onDescriptionSaved,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextFormField(
          label: 'Board Name',
          validator:
              (value) => value == null || value.isEmpty ? 'Required' : null,
          onSaved: onNameSaved,
        ),
        const SizedBox(height: 20),
        AppTextFormField(
          label: 'Board Description',
          validator:
              (value) => value == null || value.isEmpty ? 'Required' : null,
          onSaved: onDescriptionSaved,
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
