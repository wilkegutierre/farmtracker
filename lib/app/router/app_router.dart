import 'package:farmtracker/app/router/go_router_refresh_stream.dart';
import 'package:farmtracker/core/session/auth_cubit.dart';
import 'package:farmtracker/core/session/auth_state.dart';
import 'package:farmtracker/databases/local/repositories/lote_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/projeto_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/cultura_local_repository.dart';
import 'package:farmtracker/domains/repositories/cultura/cultura_repository.dart';
import 'package:farmtracker/views/appointment/pages/appointment_page.dart';
import 'package:farmtracker/views/appointment/pages/client_appointment_page.dart';
import 'package:farmtracker/views/appointment/pages/execute_appointment_page.dart';
import 'package:farmtracker/views/clients/page/cadastro_cliente_page.dart';
import 'package:farmtracker/views/clients/page/relacao_cliente_page.dart';
import 'package:farmtracker/views/culture/page/cultura_page.dart';
import 'package:farmtracker/views/dashboard/page/dashboard_page.dart';
import 'package:farmtracker/views/lot/page/lote_page.dart';
import 'package:farmtracker/views/project/page/projeto_page.dart';
import 'package:farmtracker/views/user/page/create_password_screen.dart';
import 'package:farmtracker/views/user/page/login_screen.dart';
import 'package:farmtracker/views/viewmodels/cultura/cultura_viewmodel.dart';
import 'package:farmtracker/views/viewmodels/lote/lote_viewmodel.dart';
import 'package:farmtracker/views/viewmodels/projeto/projeto_viewmodel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

GoRouter createAppRouter(AuthCubit authCubit) {
  final refreshStream = GoRouterRefreshStream(authCubit.stream);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshStream,
    redirect: (context, state) {
      final authState = authCubit.state;
      final currentPath = state.matchedLocation;

      if (authState is AuthLoading) return null;

      final isAuthenticated = authState is AuthAuthenticated;
      final isPublicRoute = currentPath == '/' || currentPath == '/createPassword';

      if (!isAuthenticated && !isPublicRoute) return '/';
      if (isAuthenticated && currentPath == '/') return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/createPassword',
        builder: (context, state) => const CreatePasswordScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: '/clienteRelacao',
        builder: (context, state) => const RelacaoClientePage(),
      ),
      GoRoute(
        path: '/clienteCadastro',
        builder: (context, state) => const CadastroClientePage(),
      ),
      GoRoute(
        path: '/projeto',
        builder: (context, state) => RepositoryProvider<ProjetoViewmodel>(
          create: (ctx) => ProjetoViewmodel(ctx.read<ProjetoLocalRepository>()),
          child: const ProjetoPage(),
        ),
      ),
      GoRoute(
        path: '/lote',
        builder: (context, state) => RepositoryProvider<LoteViewmodel>(
          create: (ctx) => LoteViewmodel(ctx.read<LoteLocalRepository>()),
          child: const LotePage(),
        ),
      ),
      GoRoute(
        path: '/cultura',
        builder: (context, state) => RepositoryProvider<CulturaViewmodel>(
          create: (ctx) => CulturaViewmodel(
            ctx.read<CulturaRepository>(),
            ctx.read<CulturaLocalRepository>(),
          ),
          child: const CulturaPage(),
        ),
      ),
      GoRoute(
        path: '/appointment',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return AppointmentPage(
            clientName: extra?['clientName'] as String?,
            farmName: extra?['farmName'] as String?,
            projectTitle: extra?['projectTitle'] as String?,
            projectBatch: extra?['projectBatch'] as String?,
            projectArea: extra?['projectArea'] as double?,
          );
        },
      ),
      GoRoute(
        path: '/executeAppointment',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ExecuteAppointmentPage(
            clientName: extra?['clientName'] as String?,
          );
        },
      ),
      GoRoute(
        path: '/clientAppointment',
        builder: (context, state) => const ClientAppointmentPage(),
      ),
    ],
  );
}
