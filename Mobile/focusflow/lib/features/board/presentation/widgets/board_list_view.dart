import 'package:flutter/material.dart';
import 'package:focusflow/features/board/domain/entities/board.dart';
import 'board_card.dart';

class BoardListView extends StatelessWidget {
  final List<Board> boards;
  final String workspaceId;

  const BoardListView({
    super.key,
    required this.boards,
    required this.workspaceId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: boards.length,
      itemBuilder: (context, index) {
        final board = boards[index];
        return BoardCard(board: board, workspaceId: workspaceId);
      },
    );
  }
}
