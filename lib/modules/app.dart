import 'package:equatable/equatable.dart';
import 'package:farmtracker/core/session/auth_cubit.dart';
import 'package:farmtracker/databases/local/auth/session_manager_impl.dart';
import 'package:farmtracker/databases/local/repositories/cliente_cultura_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/cliente_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/cultura_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/endereco_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/lote_cultura_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/lote_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/projeto_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/session_manager_repository.dart';
import 'package:farmtracker/databases/local/repositories/usuario_local_repository.dart';
import 'package:farmtracker/databases/local/sql/cliente_cultura_database_impl.dart';
import 'package:farmtracker/databases/local/sql/cliente_database_impl.dart';
import 'package:farmtracker/databases/local/sql/cultura_database_impl.dart';
import 'package:farmtracker/databases/local/sql/endereco_database_impl.dart';
import 'package:farmtracker/databases/local/sql/lote_cultura_database_impl.dart';
import 'package:farmtracker/databases/local/sql/lote_database_impl.dart';
import 'package:farmtracker/databases/local/sql/projeto_database_impl.dart';
import 'package:farmtracker/databases/local/sql/usuario_database_impl.dart';
import 'package:farmtracker/databases/repositories/cliente/cliente_repository_impl.dart';
import 'package:farmtracker/databases/repositories/cultura/cultura_repository_impl.dart';
import 'package:farmtracker/databases/repositories/endereco/endereco_repository_impl.dart';
import 'package:farmtracker/databases/repositories/usuario/usuario_repository_impl.dart';
import 'package:farmtracker/databases/services/cliente/cliente_service.dart';
import 'package:farmtracker/databases/services/cliente/cliente_service_impl.dart';
import 'package:farmtracker/databases/services/cultura/cultura_service.dart';
import 'package:farmtracker/databases/services/cultura/cultura_service_impl.dart';
import 'package:farmtracker/databases/services/endereco/endereco_service.dart';
import 'package:farmtracker/databases/services/endereco/endereco_service_impl.dart';
import 'package:farmtracker/databases/services/http/authenticated_http_client.dart';
import 'package:farmtracker/databases/services/http/custom_http_client.dart';
import 'package:farmtracker/databases/services/http/http_interface.dart';
import 'package:farmtracker/databases/services/usuario/usuario_service.dart';
import 'package:farmtracker/databases/services/usuario/usuario_service_impl.dart';
import 'package:farmtracker/domains/repositories/cliente/cliente_repository.dart';
import 'package:farmtracker/domains/repositories/cultura/cultura_repository.dart';
import 'package:farmtracker/domains/repositories/endereco/endereco_repository.dart';
import 'package:farmtracker/domains/repositories/usuario/usuario_repository.dart';
import 'package:farmtracker/modules/app_material_route.dart';
import 'package:farmtracker/views/viewmodels/cliente/cliente_cubit.dart';
import 'package:farmtracker/views/viewmodels/usuario/usuario_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

void initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  _configGlobals();
  runApp(const FarmTrackerApp());
}

void _configGlobals() {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'pt_BR';

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  EquatableConfig.stringify = true;
}

class FarmTrackerApp extends StatelessWidget {
  const FarmTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Data layer
    return MultiRepositoryProvider(
      providers: [
        // HTTP
        RepositoryProvider<CustomHttpClient>(create: (_) => CustomHttpClient()),
        RepositoryProvider<SessionManagerRepository>(create: (_) => SessionManagerImpl()),
        RepositoryProvider<HttpClientInterface>(
          create: (ctx) => AuthenticatedHttpClient(ctx.read<CustomHttpClient>(), ctx.read<SessionManagerRepository>()),
        ),

        // Services
        RepositoryProvider<UsuarioService>(create: (ctx) => UsuarioServiceImpl(ctx.read<HttpClientInterface>())),
        RepositoryProvider<ClienteService>(create: (ctx) => ClienteServiceImpl(ctx.read<HttpClientInterface>())),
        RepositoryProvider<CulturaService>(create: (ctx) => CutluraServiceImpl(ctx.read<HttpClientInterface>())),
        RepositoryProvider<EnderecoService>(create: (ctx) => EnderecoServiceImpl(ctx.read<HttpClientInterface>())),

        // Remote repositories
        RepositoryProvider<UsuarioRepository>(
          create: (ctx) => UsuarioRepositoryImpl(service: ctx.read<UsuarioService>()),
        ),
        RepositoryProvider<ClienteRepository>(create: (ctx) => ClienteRepositoryImpl(ctx.read<ClienteService>())),
        RepositoryProvider<CulturaRepository>(create: (ctx) => CulturaRepositoryImpl(ctx.read<CulturaService>())),
        RepositoryProvider<EnderecoRepository>(create: (ctx) => EnderecoRepositoryImpl(ctx.read<EnderecoService>())),

        // Local repositories
        RepositoryProvider<UsuarioLocalRepository>(create: (_) => UsuarioDatabaseImpl()),
        RepositoryProvider<ClienteLocalRepository>(create: (_) => ClienteDatabaseImpl()),
        RepositoryProvider<ClienteCulturaLocalRepository>(create: (_) => ClienteCulturaDatabaseImpl()),
        RepositoryProvider<EnderecoLocalRepository>(create: (_) => EnderecoDatabaseImpl()),
        RepositoryProvider<ProjetoLocalRepository>(create: (_) => ProjetoDatabaseImpl()),
        RepositoryProvider<LoteLocalRepository>(create: (_) => LoteDatabaseImpl()),
        RepositoryProvider<LoteCulturaLocalRepository>(create: (_) => LoteCulturaDatabaseImpl()),
        RepositoryProvider<CulturaLocalRepository>(create: (_) => CulturaDatabaseImpl()),
      ],
      // Business layer
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(create: (ctx) => AuthCubit(ctx.read<SessionManagerRepository>())),
          BlocProvider<UsuarioCubit>(
            create: (ctx) => UsuarioCubit(
              ctx.read<UsuarioRepository>(),
              ctx.read<UsuarioLocalRepository>(),
              ctx.read<SessionManagerRepository>(),
            ),
          ),
          BlocProvider<ClienteCubit>(
            create: (ctx) => ClienteCubit(
              ctx.read<ClienteRepository>(),
              ctx.read<CulturaRepository>(),
              ctx.read<CulturaLocalRepository>(),
              ctx.read<ClienteCulturaLocalRepository>(),
              ctx.read<ClienteLocalRepository>(),
              ctx.read<EnderecoLocalRepository>(),
              ctx.read<EnderecoRepository>(),
              ctx.read<ProjetoLocalRepository>(),
              ctx.read<LoteLocalRepository>(),
              ctx.read<LoteCulturaLocalRepository>(),
            ),
          ),
        ],
        child: const AppMaterialRoute(),
      ),
    );
  }
}
