import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focusflow/core/widgets/loading_spinner_widget.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_event.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_state.dart';
import 'package:focusflow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';

enum ProfileButtonType { profileAvatar, logoutIcon }

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final String title;
  final ProfileButtonType profileButtonType;

  const MainAppBar({
    super.key,
    this.showBackButton = true,
    required this.title,
    this.profileButtonType = ProfileButtonType.profileAvatar,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      leading:
          showBackButton
              ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => Navigator.of(context).pop(),
              )
              : null,
      actions: [
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: LoadingSpinnerWidget(),
              );
            } else if (state is AuthAuthenticated) {
              switch (profileButtonType) {
                case ProfileButtonType.profileAvatar:
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'logout') {
                          context.read<AuthBloc>().add(SignOutRequested());
                        } else if (value == 'user_name') {
                          GoRouter.of(context).push('/profile');
                        }
                      },
                      itemBuilder:
                          (context) => [
                            PopupMenuItem<String>(
                              value: 'user_name',
                              child: Row(
                                children: [
                                  Icon(Icons.account_circle), // Profile icon
                                  SizedBox(width: 8),
                                  Text(state.user.name),
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'logout',
                              child: Row(
                                children: [
                                  Icon(Icons.logout),
                                  SizedBox(width: 8),
                                  Text('Logout'),
                                ],
                              ),
                            ),
                          ],
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.white,
                        child: Text(
                          state.user.name[0],
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );

                case ProfileButtonType.logoutIcon:
                  return IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      context.read<AuthBloc>().add(SignOutRequested());
                    },
                  );
              }
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
