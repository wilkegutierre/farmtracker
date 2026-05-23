import 'package:farmtracker/core/session/auth_session_controller.dart';
import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_spacing.dart';
import 'package:farmtracker/views/user/widgets/create_password_form_card.dart';
import 'package:farmtracker/views/user/widgets/create_password_login_footer.dart';
import 'package:farmtracker/views/user/widgets/login_header.dart';
import 'package:farmtracker/views/viewmodels/usuario/usuario_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
  final UsuarioViewmodel usuarioViewmodel = Modular.get<UsuarioViewmodel>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _submitting = false;

  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
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

    setState(() => _submitting = true);
    try {
      final String? token = await usuarioViewmodel.setPassword(email, password);
      if (!mounted) return;
      if (token == null || token.isEmpty) {
        _showMessage('Não foi possível criar a senha. Verifique os dados informados.');
        return;
      }

      final AuthSessionController auth = Modular.get<AuthSessionController>();
      await auth.signIn(token);

      if (!mounted) return;
      _showMessage('Senha criada com sucesso.');
      Modular.to.navigate('/home');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
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
                      loading: _submitting,
                    ),
                    const SizedBox(height: AppSpacing.s10),
                    CreatePasswordLoginFooter(onLogin: () => Navigator.of(context).pop()),
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
}
