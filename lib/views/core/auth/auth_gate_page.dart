import 'package:farmtracker/core/session/auth_session_controller.dart';
import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/user/page/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

/// Shell em `/`: exibe login ou o outlet das rotas autenticadas.
class AuthGatePage extends StatefulWidget {
  const AuthGatePage({super.key});

  @override
  State<AuthGatePage> createState() => _AuthGatePageState();
}

class _AuthGatePageState extends State<AuthGatePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Modular.get<AuthSessionController>().bootstrap();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthSessionController auth = Modular.get<AuthSessionController>();

    return ListenableBuilder(
      listenable: auth,
      builder: (BuildContext context, Widget? child) {
        if (!auth.isReady) {
          return Scaffold(
            backgroundColor: AppColors.surface,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }
        if (auth.isAuthenticated) {
          return const RouterOutlet();
        }
        return const LoginScreen();
      },
    );
  }
}
