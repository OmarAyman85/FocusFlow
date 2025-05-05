import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/theme/app_pallete.dart';
import 'package:focusflow/core/widgets/loading_spinner_widget.dart';
import 'package:focusflow/core/widgets/main_app_bar_widget.dart';
import 'package:go_router/go_router.dart';
import '../cubit/board_cubit.dart';
import '../cubit/board_state.dart';
import '../widgets/board_list_view.dart';

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
    Future.microtask(() {
      context.read<BoardCubit>().loadBoards(widget.workspaceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(title: 'Boards'),
      body: BlocBuilder<BoardCubit, BoardState>(
        builder: (context, state) {
          if (state is BoardLoading) {
            return const Center(child: LoadingSpinnerWidget());
          } else if (state is BoardLoaded) {
            return BoardListView(
              boards: state.boards,
              workspaceId: widget.workspaceId,
            );
          } else if (state is BoardError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppPallete.backgroundColor,
        foregroundColor: AppPallete.gradient1,
        onPressed: () {
          GoRouter.of(
            context,
          ).push('/workspace/${widget.workspaceId}/board-form');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
