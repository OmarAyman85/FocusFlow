import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/features/task/presentation/cubit/task_cubit.dart';

class TaskUserHelper {
  static Future<Map<String, String>> getUserIdToNameMap(BuildContext context) async {
    try {
      final members = await context.read<TaskCubit>().getUsers();
      return {for (var member in members) member.id: member.name};
    } catch (_) {
      return {};
    }
  }
}
