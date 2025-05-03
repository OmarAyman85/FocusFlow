import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/theme/app_pallete.dart';
import 'package:focusflow/core/widgets/main_app_bar_widget.dart';
import 'package:focusflow/features/board/presentation/services/add_member_dialog.dart';
import 'package:go_router/go_router.dart';
import '../cubit/board_cubit.dart';
import '../cubit/board_state.dart';

class BoardPage extends StatefulWidget {
  final String workspaceId;

  const BoardPage({super.key, required this.workspaceId});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  @override
  void initState() {
    super.initState();
    // Delay ensures context is fully initialized before use
    Future.microtask(() {
      context.read<BoardCubit>().loadBoards(widget.workspaceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: 'Boards'),
      body: BlocBuilder<BoardCubit, BoardState>(
        builder: (context, state) {
          if (state is BoardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BoardLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.boards.length,
              itemBuilder: (context, index) {
                final board = state.boards[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  elevation: 3,
                  color: AppPallete.gradient2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Board name
                        Text(
                          board.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppPallete.gradient1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Board description
                        Text(
                          board.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Info row
                        Row(
                          children: [
                            Text(
                              'Tasks: ${board.numberOfTasks}',
                              style: const TextStyle(fontSize: 13),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Members: ${board.numberOfMembers}',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Created by: ${board.createdByName}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.person_add),
                              onPressed: () {
                                AddBoardMemberDialog.openAddBoardMemberDialog(
                                  context,
                                  board.id,
                                  widget.workspaceId,
                                );
                              },
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final workspaceId = widget.workspaceId;
                                final boardId = board.id;
                                GoRouter.of(context).push(
                                  '/workspace/$workspaceId/board/$boardId/tasks',
                                );
                              },
                              child: const Text('Enter'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is BoardError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final workspaceId = widget.workspaceId;
          GoRouter.of(context).push('/workspace/$workspaceId/board-form');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
