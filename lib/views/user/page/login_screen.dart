import 'package:farmtracker/core/session/auth_cubit.dart';
import 'package:farmtracker/core/session/auth_state.dart';
import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_spacing.dart';
import 'package:farmtracker/views/viewmodels/usuario/usuario_cubit.dart';
import 'package:farmtracker/views/viewmodels/usuario/usuario_state.dart';
import 'package:farmtracker/views/user/widgets/login_credential_fields.dart';
import 'package:farmtracker/views/user/widgets/login_forgot_password_link.dart';
import 'package:farmtracker/views/user/widgets/login_header.dart';
import 'package:farmtracker/views/user/widgets/login_primary_button.dart';
import 'package:farmtracker/views/user/widgets/login_signup_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (_, current) => current is AuthLoading,
      builder: (context, authState) {
        return BlocConsumer<UsuarioCubit, UsuarioState>(
          listenWhen: (_, current) => current is UsuarioLoginSuccess || current is UsuarioLoginFailure,
          listener: (context, state) async {
            if (state is UsuarioLoginSuccess) {
              await context.read<AuthCubit>().signIn(state.token);
            } else if (state is UsuarioLoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          buildWhen: (_, current) =>
              current is UsuarioLoading || current is UsuarioInitial || current is UsuarioLoginFailure,
          builder: (context, state) {
            return _buildForm(context, state is UsuarioLoading);
          },
        );
      },
    );
  }

  Widget _buildForm(BuildContext context, bool isLoading) {
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
                    LoginCredentialFields(
                      usernameController: _userController,
                      passwordController: _passwordController,
                      obscurePassword: _obscurePassword,
                      onTogglePasswordVisibility: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    const SizedBox(height: AppSpacing.s2),
                    LoginForgotPasswordLink(onPressed: () {}),
                    const SizedBox(height: AppSpacing.s6),
                    LoginPrimaryButton(onPressed: _performLogin, loading: isLoading),
                    const SizedBox(height: AppSpacing.s10),
                    LoginSignupFooter(onCreatePassword: () => context.push('/createPassword')),
                    const SizedBox(height: AppSpacing.s6),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _performLogin() {
    final String user = _userController.text.trim();
    final String pass = _passwordController.text.trim();
    if (user.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha usuário e senha')));
      return;
    }
    context.read<UsuarioCubit>().login(user, pass);
  }
}
