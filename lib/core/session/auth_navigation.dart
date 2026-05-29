import 'package:farmtracker/core/session/auth_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Expira a sessão e redireciona para a tela de login.
Future<void> redirectToLoginOnSessionExpired(BuildContext context) async {
  await context.read<AuthCubit>().onSessionExpired();
  if (context.mounted) context.go('/');
}
