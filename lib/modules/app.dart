import 'package:equatable/equatable.dart';
import 'package:farmtracker/core/session/auth_cubit.dart';
import 'package:farmtracker/databases/local/auth/session_manager_impl.dart';
import 'package:farmtracker/databases/local/repositories/address_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/appointment_execution_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/appointment_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/base_entity_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/customer_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/session_manager_repository.dart';
import 'package:farmtracker/databases/local/repositories/pest_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/type_visit_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/wallet_local_repository.dart';
import 'package:farmtracker/databases/local/sql/address_database_impl.dart';
import 'package:farmtracker/databases/local/sql/appointment_execution_database_impl.dart';
import 'package:farmtracker/databases/local/sql/appointment_database_impl.dart';
import 'package:farmtracker/databases/local/sql/base_entity_database_impl.dart';
import 'package:farmtracker/databases/local/sql/customer_database_impl.dart';
import 'package:farmtracker/databases/local/sql/pest_database_impl.dart';
import 'package:farmtracker/databases/local/sql/type_visit_database_impl.dart';
import 'package:farmtracker/databases/local/sql/wallet_database_impl.dart';
import 'package:farmtracker/databases/repositories/appointment_execution/appointment_execution_repository_impl.dart';
import 'package:farmtracker/databases/repositories/address/address_repository_impl.dart';
import 'package:farmtracker/databases/repositories/base_entity/base_entity_repository_impl.dart';
import 'package:farmtracker/databases/repositories/customer/customer_repository_impl.dart';
import 'package:farmtracker/databases/repositories/pest/pest_repository_impl.dart';
import 'package:farmtracker/databases/repositories/type_visit/type_visit_repository_impl.dart';
import 'package:farmtracker/databases/repositories/usuario/usuario_repository_impl.dart';
import 'package:farmtracker/databases/repositories/wallet/wallet_repository_impl.dart';
import 'package:farmtracker/databases/services/appointment_execution/appointment_execution_service.dart';
import 'package:farmtracker/databases/services/appointment_execution/appointment_execution_service_impl.dart';
import 'package:farmtracker/databases/services/http/authenticated_http_client.dart';
import 'package:farmtracker/databases/services/http/custom_http_client.dart';
import 'package:farmtracker/databases/services/http/http_interface.dart';
import 'package:farmtracker/databases/services/address/address_service.dart';
import 'package:farmtracker/databases/services/address/address_service_impl.dart';
import 'package:farmtracker/databases/services/base_entity/base_entity_service.dart';
import 'package:farmtracker/databases/services/base_entity/base_entity_service_impl.dart';
import 'package:farmtracker/databases/services/customer/customer_service.dart';
import 'package:farmtracker/databases/services/customer/customer_service_impl.dart';
import 'package:farmtracker/databases/services/wallet/wallet_service.dart';
import 'package:farmtracker/databases/services/wallet/wallet_service_impl.dart';
import 'package:farmtracker/databases/services/pest/pest_service.dart';
import 'package:farmtracker/databases/services/pest/pest_service_impl.dart';
import 'package:farmtracker/databases/services/type_visit/type_visit_service.dart';
import 'package:farmtracker/databases/services/type_visit/type_visit_service_impl.dart';
import 'package:farmtracker/databases/services/user/usuario_service.dart';
import 'package:farmtracker/databases/services/user/usuario_service_impl.dart';
import 'package:farmtracker/domains/repositories/appointment_execution/appointment_execution_repository.dart';
import 'package:farmtracker/domains/repositories/address/address_repository.dart';
import 'package:farmtracker/domains/repositories/base_entity/base_entity_repository.dart';
import 'package:farmtracker/domains/repositories/customer/customer_repository.dart';
import 'package:farmtracker/domains/repositories/pest/pest_repository.dart';
import 'package:farmtracker/domains/repositories/type_visit/type_visit_repository.dart';
import 'package:farmtracker/domains/repositories/user/usuario_repository.dart';
import 'package:farmtracker/domains/repositories/wallet/wallet_repository.dart';
import 'package:farmtracker/modules/app_material_route.dart';

import 'package:farmtracker/views/cubits/address/address_cubit.dart';
import 'package:farmtracker/views/cubits/appointment/appointment_cubit.dart';
import 'package:farmtracker/views/cubits/base_entity/base_entity_cubit.dart';
import 'package:farmtracker/views/cubits/customer/customer_cubit.dart';
import 'package:farmtracker/views/cubits/pest/pest_cubit.dart';
import 'package:farmtracker/views/cubits/type_visit/type_visit_cubit.dart';
import 'package:farmtracker/views/cubits/usuario/usuario_cubit.dart';
import 'package:farmtracker/views/cubits/wallet/wallet_cubit.dart';
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
        RepositoryProvider<CustomerService>(create: (ctx) => CustomerServiceImpl(ctx.read<HttpClientInterface>())),
        RepositoryProvider<WalletService>(create: (ctx) => WalletServiceImpl(ctx.read<HttpClientInterface>())),
        RepositoryProvider<AddressService>(create: (ctx) => AddressServiceImpl(ctx.read<HttpClientInterface>())),
        RepositoryProvider<BaseEntityService>(create: (ctx) => BaseEntityServiceImpl(ctx.read<HttpClientInterface>())),
        RepositoryProvider<TypeVisitService>(create: (ctx) => TypeVisitServiceImpl(ctx.read<HttpClientInterface>())),
        RepositoryProvider<PestService>(create: (ctx) => PestServiceImpl(ctx.read<HttpClientInterface>())),
        // RepositoryProvider<ClienteService>(create: (ctx) => ClienteServiceImpl(ctx.read<HttpClientInterface>())),
        // RepositoryProvider<CulturaService>(create: (ctx) => CutluraServiceImpl(ctx.read<HttpClientInterface>())),
        // RepositoryProvider<EnderecoService>(create: (ctx) => EnderecoServiceImpl(ctx.read<HttpClientInterface>())),

        // Remote repositories
        RepositoryProvider<UsuarioRepository>(
          create: (ctx) => UsuarioRepositoryImpl(service: ctx.read<UsuarioService>()),
        ),
        RepositoryProvider<CustomerRepository>(
          create: (ctx) => CustomerRepositoryImpl(service: ctx.read<CustomerService>()),
        ),
        RepositoryProvider<WalletRepository>(create: (ctx) => WalletRepositoryImpl(service: ctx.read<WalletService>())),
        RepositoryProvider<AddressRepository>(
          create: (ctx) => AddressRepositoryImpl(service: ctx.read<AddressService>()),
        ),
        RepositoryProvider<BaseEntityRepository>(
          create: (ctx) => BaseEntityRepositoryImpl(service: ctx.read<BaseEntityService>()),
        ),
        RepositoryProvider<TypeVisitRepository>(
          create: (ctx) => TypeVisitRepositoryImpl(service: ctx.read<TypeVisitService>()),
        ),
        RepositoryProvider<PestRepository>(
          create: (ctx) => PestRepositoryImpl(service: ctx.read<PestService>()),
        ),

        // RepositoryProvider<ClienteRepository>(create: (ctx) => ClienteRepositoryImpl(ctx.read<ClienteService>())),
        // RepositoryProvider<CulturaRepository>(create: (ctx) => CulturaRepositoryImpl(ctx.read<CulturaService>())),
        // RepositoryProvider<EnderecoRepository>(create: (ctx) => EnderecoRepositoryImpl(ctx.read<EnderecoService>())),

        // Local repositories
        RepositoryProvider<WalletLocalRepository>(create: (_) => WalletDatabaseImpl()),
        RepositoryProvider<CustomerLocalRepository>(create: (_) => CustomerDatabaseImpl()),
        RepositoryProvider<AddressLocalRepository>(create: (_) => AddressDatabaseImpl()),
        RepositoryProvider<BaseEntityLocalRepository>(create: (_) => BaseEntityDatabaseImpl()),
        RepositoryProvider<AppointmentLocalRepository>(create: (_) => AppointmentDatabaseImpl()),
        RepositoryProvider<TypeVisitLocalRepository>(create: (_) => TypeVisitDatabaseImpl()),
        RepositoryProvider<PestLocalRepository>(create: (_) => PestDatabaseImpl()),
        RepositoryProvider<AppointmentExecutionLocalRepository>(create: (_) => AppointmentExecutionDatabaseImpl()),
        RepositoryProvider<AppointmentExecutionService>(
          create: (ctx) => AppointmentExecutionServiceImpl(ctx.read<AppointmentExecutionLocalRepository>()),
        ),
        RepositoryProvider<AppointmentExecutionRepository>(
          create: (ctx) => AppointmentExecutionRepositoryImpl(service: ctx.read<AppointmentExecutionService>()),
        ),
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
          BlocProvider<WalletCubit>(
            create: (ctx) => WalletCubit(ctx.read<WalletRepository>(), ctx.read<WalletLocalRepository>()),
          ),
          BlocProvider<CustomerCubit>(
            create: (ctx) => CustomerCubit(ctx.read<CustomerRepository>(), ctx.read<CustomerLocalRepository>()),
          ),
          BlocProvider<AddressCubit>(
            create: (ctx) => AddressCubit(ctx.read<AddressRepository>(), ctx.read<AddressLocalRepository>()),
          ),
          BlocProvider<BaseEntityCubit>(
            create: (ctx) => BaseEntityCubit(ctx.read<BaseEntityRepository>(), ctx.read<BaseEntityLocalRepository>()),
          ),
          BlocProvider<AppointmentCubit>(
            create: (ctx) => AppointmentCubit(
              ctx.read<AppointmentLocalRepository>(),
              ctx.read<AppointmentExecutionRepository>(),
            ),
          ),
          BlocProvider<TypeVisitCubit>(
            create: (ctx) => TypeVisitCubit(ctx.read<TypeVisitRepository>(), ctx.read<TypeVisitLocalRepository>()),
          ),
          BlocProvider<PestCubit>(
            create: (ctx) => PestCubit(ctx.read<PestRepository>(), ctx.read<PestLocalRepository>()),
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
