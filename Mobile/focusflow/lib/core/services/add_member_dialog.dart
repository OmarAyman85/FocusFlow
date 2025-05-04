import 'package:flutter/material.dart';
import 'package:focusflow/core/entities/member.dart';


class AddMemberDialog {
  static Future<void> open<T>({
    required BuildContext context,
    required Future<List<Member>> Function() getUsers,
    required Future<void> Function(Member user) onUserSelected,
    String title = 'Add Member',
  }) async {
    final users = await getUsers();
    final selectedUser = await showDialog<Member>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<Member>(
                  hint: const Text("Select a User"),
                  onChanged: (Member? user) {
                    Navigator.of(ctx).pop(user);
                  },
                  items:
                      users
                          .map(
                            (user) => DropdownMenuItem<Member>(
                              value: user,
                              child: Text(user.name),
                            ),
                          )
                          .toList(),
                ),
              ],
            ),
          ),
    );

    if (selectedUser != null) {
      await onUserSelected(selectedUser);
    }
  }
}
