import 'package:farmtracker/app/router/app_router.dart';
import 'package:farmtracker/core/session/auth_cubit.dart';
import 'package:farmtracker/views/core/theme/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

class AppMaterialRoute extends StatefulWidget {
  const AppMaterialRoute({super.key});

  @override
  State<AppMaterialRoute> createState() => _AppMaterialRouteState();
}

class _AppMaterialRouteState extends State<AppMaterialRoute> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createAppRouter(context.read<AuthCubit>());
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FarmTracker',
      debugShowCheckedModeBanner: kDebugMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [Locale('pt')],
    );
  }
}
