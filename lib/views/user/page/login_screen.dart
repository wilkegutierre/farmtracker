import 'package:farmtracker/core/session/auth_session_controller.dart';
import 'package:farmtracker/core/session/session_storage.dart';
import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_spacing.dart';
import 'package:farmtracker/views/viewmodels/usuario/usuario_viewmodel.dart';
import 'package:farmtracker/views/user/widgets/login_credential_fields.dart';
import 'package:farmtracker/views/user/widgets/login_forgot_password_link.dart';
import 'package:farmtracker/views/user/widgets/login_header.dart';
import 'package:farmtracker/views/user/widgets/login_primary_button.dart';
import 'package:farmtracker/views/user/page/create_password_screen.dart';
import 'package:farmtracker/views/user/widgets/login_signup_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// Tela de login.
/// Após integrar a API, substitua [_performLogin] pela chamada real e use o `tokenAcesso` (e expiração) na [AuthSessionController.signIn].
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UsuarioViewmodel usuarioViewmodel = Modular.get<UsuarioViewmodel>();
  bool _obscurePassword = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryRestoreStoredToken());
  }

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Recupera o token salvo no SharedPreferences e restaura a sessão.
  Future<void> _tryRestoreStoredToken() async {
    if (!await SessionStorage.hasValidSession()) return;

    final String? token = await SessionStorage.getToken();
    if (token == null || token.isEmpty || !mounted) return;

    final AuthSessionController auth = Modular.get<AuthSessionController>();
    await auth.signIn(token);
    if (!mounted) return;
    Modular.to.navigate('/home');
  }

  Future<void> _performLogin() async {
    final String user = _userController.text.trim();
    final String pass = _passwordController.text.trim();
    if (user.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha usuário e senha')));
      return;
    }

    setState(() => _submitting = true);
    try {
      final AuthSessionController auth = Modular.get<AuthSessionController>();
      final String? storedToken = await SessionStorage.getToken();

      if (storedToken != null && storedToken.isNotEmpty) {
        await auth.signIn(storedToken);
      } else {
        final String? token = await usuarioViewmodel.login(user, pass);
        if (!mounted) return;
        if (token == null || token.isEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Nao foi possivel efetuar login. Verifique os dados.')));
          return;
        }
        await auth.signIn(token);
      }
      if (!mounted) return;
      Modular.to.navigate('/home');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
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
                    LoginCredentialFields(
                      usernameController: _userController,
                      passwordController: _passwordController,
                      obscurePassword: _obscurePassword,
                      onTogglePasswordVisibility: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    const SizedBox(height: AppSpacing.s2),
                    LoginForgotPasswordLink(
                      onPressed: () {
                        // Navegação / recuperação — quando existir fluxo
                      },
                    ),
                    const SizedBox(height: AppSpacing.s6),
                    LoginPrimaryButton(onPressed: _performLogin, loading: _submitting),
                    const SizedBox(height: AppSpacing.s10),
                    LoginSignupFooter(
                      onCreatePassword: () {
                        Navigator.of(
                          context,
                        ).push(MaterialPageRoute<void>(builder: (_) => const CreatePasswordScreen()));
                      },
                    ),
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
