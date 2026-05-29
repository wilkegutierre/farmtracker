import 'package:farmtracker/core/session/auth_cubit.dart';
import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_spacing.dart';
import 'package:farmtracker/views/user/widgets/create_password_form_card.dart';
import 'package:farmtracker/views/user/widgets/create_password_login_footer.dart';
import 'package:farmtracker/views/user/widgets/login_header.dart';
import 'package:farmtracker/views/viewmodels/usuario/usuario_cubit.dart';
import 'package:farmtracker/views/viewmodels/usuario/usuario_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Cadastro de senha para usuário que ainda não definiu credenciais de acesso.
class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showMessage('Preencha e-mail, senha e confirmação.');
      return;
    }
    if (!_emailPattern.hasMatch(email)) {
      _showMessage('Informe um e-mail válido.');
      return;
    }
    if (password.length < 6) {
      _showMessage('A senha deve ter pelo menos 6 caracteres.');
      return;
    }
    if (password != confirmPassword) {
      _showMessage('As senhas não coincidem.');
      return;
    }

    context.read<UsuarioCubit>().setPassword(email, password);
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UsuarioCubit, UsuarioState>(
      listenWhen: (_, current) =>
          current is UsuarioPasswordSuccess || current is UsuarioPasswordFailure,
      listener: (context, state) async {
        if (state is UsuarioPasswordSuccess) {
          _showMessage('Senha criada com sucesso.');
          await context.read<AuthCubit>().bootstrap();
        } else if (state is UsuarioPasswordFailure) {
          _showMessage(state.message);
        }
      },
      buildWhen: (_, current) =>
          current is UsuarioLoading ||
          current is UsuarioInitial ||
          current is UsuarioPasswordSuccess ||
          current is UsuarioPasswordFailure,
      builder: (context, state) {
        final bool isLoading = state is UsuarioLoading;
        return Scaffold(
          backgroundColor: AppColors.surface,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: AppSpacing.s10),
                        const LoginHeader(),
                        const SizedBox(height: AppSpacing.s10),
                        CreatePasswordFormCard(
                          emailController: _emailController,
                          passwordController: _passwordController,
                          confirmPasswordController: _confirmPasswordController,
                          obscurePassword: _obscurePassword,
                          obscureConfirmPassword: _obscureConfirmPassword,
                          onTogglePasswordVisibility: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                          onToggleConfirmPasswordVisibility: () {
                            setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                          },
                          onSubmit: _submit,
                          loading: isLoading,
                        ),
                        const SizedBox(height: AppSpacing.s10),
                        CreatePasswordLoginFooter(onLogin: () => context.pop()),
                        const SizedBox(height: AppSpacing.s6),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
