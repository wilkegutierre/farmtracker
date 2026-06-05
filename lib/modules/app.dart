import 'package:equatable/equatable.dart';
import 'package:farmtracker/core/session/auth_cubit.dart';
import 'package:farmtracker/databases/local/auth/session_manager_impl.dart';
import 'package:farmtracker/databases/local/repositories/session_manager_repository.dart';
import 'package:farmtracker/databases/repositories/usuario/usuario_repository_impl.dart';
import 'package:farmtracker/databases/services/http/authenticated_http_client.dart';
import 'package:farmtracker/databases/services/http/custom_http_client.dart';
import 'package:farmtracker/databases/services/http/http_interface.dart';
import 'package:farmtracker/databases/services/user/usuario_service.dart';
import 'package:farmtracker/databases/services/user/usuario_service_impl.dart';
import 'package:farmtracker/domains/repositories/user/usuario_repository.dart';
import 'package:farmtracker/modules/app_material_route.dart';

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
        // RepositoryProvider<ClienteService>(create: (ctx) => ClienteServiceImpl(ctx.read<HttpClientInterface>())),
        // RepositoryProvider<CulturaService>(create: (ctx) => CutluraServiceImpl(ctx.read<HttpClientInterface>())),
        // RepositoryProvider<EnderecoService>(create: (ctx) => EnderecoServiceImpl(ctx.read<HttpClientInterface>())),

        // Remote repositories
        RepositoryProvider<UsuarioRepository>(
          create: (ctx) => UsuarioRepositoryImpl(service: ctx.read<UsuarioService>()),
        ),

        // RepositoryProvider<ClienteRepository>(create: (ctx) => ClienteRepositoryImpl(ctx.read<ClienteService>())),
        // RepositoryProvider<CulturaRepository>(create: (ctx) => CulturaRepositoryImpl(ctx.read<CulturaService>())),
        // RepositoryProvider<EnderecoRepository>(create: (ctx) => EnderecoRepositoryImpl(ctx.read<EnderecoService>())),

        // Local repositories
        // RepositoryProvider<UsuarioLocalRepository>(create: (_) => UsuarioDatabaseImpl()),
        // RepositoryProvider<ClienteLocalRepository>(create: (_) => ClienteDatabaseImpl()),
        // RepositoryProvider<ClienteCulturaLocalRepository>(create: (_) => ClienteCulturaDatabaseImpl()),
        // RepositoryProvider<EnderecoLocalRepository>(create: (_) => EnderecoDatabaseImpl()),
      ],
      // Business layer
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(create: (ctx) => AuthCubit(ctx.read<SessionManagerRepository>())),
          BlocProvider<UsuarioCubit>(
            create: (ctx) => UsuarioCubit(
              ctx.read<UsuarioRepository>(),
              //ctx.read<UserLocalRepository>(),
              ctx.read<SessionManagerRepository>(),
            ),
          ),
          // BlocProvider<ClienteCubit>(
          //   create: (ctx) => ClienteCubit(
          //      ctx.read<ClienteRepository>(),
          //     ctx.read<CulturaRepository>(),
          //     ctx.read<CulturaLocalRepository>(),
          //   ),
          // ),
        ],
        child: const AppMaterialRoute(),
      ),
    );
  }
}
