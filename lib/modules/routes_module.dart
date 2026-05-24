import 'package:farmtracker/core/session/auth_session_controller.dart';
import 'package:farmtracker/databases/local/repositories/cliente_cultura_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/cliente_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/cultura_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/endereco_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/lote_cultura_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/lote_local_repository.dart';
import 'package:farmtracker/databases/local/repositories/projeto_local_repository.dart';
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
import 'package:farmtracker/domains/repositories/cliente/cliente_repository.dart';
import 'package:farmtracker/domains/repositories/cultura/cultura_repository.dart';
import 'package:farmtracker/domains/repositories/endereco/endereco_repository.dart';
import 'package:farmtracker/databases/services/http/authenticated_http_client.dart';
import 'package:farmtracker/databases/services/http/custom_http_client.dart';
import 'package:farmtracker/databases/services/http/http_interface.dart';
import 'package:farmtracker/databases/local/repositories/session_manager_repository.dart';
import 'package:farmtracker/databases/local/auth/session_manager_impl.dart';
import 'package:farmtracker/databases/services/usuario/usuario_service.dart';
import 'package:farmtracker/databases/services/usuario/usuario_service_impl.dart';
import 'package:farmtracker/domains/repositories/usuario/usuario_repository.dart';
import 'package:farmtracker/views/appointment/pages/appointment_page.dart';
import 'package:farmtracker/views/appointment/pages/client_appointment_page.dart';
import 'package:farmtracker/views/appointment/pages/execute_appointment_page.dart';
import 'package:farmtracker/views/clients/page/cadastro_cliente_page.dart';
import 'package:farmtracker/views/clients/page/relacao_cliente_page.dart';
import 'package:farmtracker/views/core/auth/auth_gate_page.dart';
import 'package:farmtracker/views/culture/page/cultura_page.dart';
import 'package:farmtracker/views/dashboard/page/dashboard_page.dart';
import 'package:farmtracker/views/lot/page/lote_page.dart';
import 'package:farmtracker/views/project/page/projeto_page.dart';
import 'package:farmtracker/views/viewmodels/cliente/cliente_viewmodel.dart';
import 'package:farmtracker/views/viewmodels/usuario/usuario_viewmodel.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RouteModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(
      '/',
      child: (context) => const AuthGatePage(),
      children: [
        ChildRoute('/home', child: (context) => const DashboardPage()),
        ChildRoute('/clienteRelacao', child: (context) => const RelacaoClientePage()),
        ChildRoute('/clienteCadastro', child: (context) => const CadastroClientePage()),
        ChildRoute('/cultura', child: (context) => const CulturaPage()),
        ChildRoute('/projeto', child: (context) => const ProjetoPage()),
        ChildRoute('/lote', child: (context) => const LotePage()),
        ChildRoute(
          '/appointment',
          child: (context) {
            final args = r.args.data;
            return AppointmentPage(
              clientName: args?['clientName'] as String?,
              farmName: args?['farmName'] as String?,
              projectTitle: args?['projectTitle'] as String?,
              projectBatch: args?['projectBatch'] as String?,
              projectArea: args?['projectArea'] as double?,
            );
          },
        ),
        ChildRoute(
          '/executeAppointment',
          child: (context) {
            final args = r.args.data;
            return ExecuteAppointmentPage(clientName: args?['clientName'] as String?);
          },
        ),
        ChildRoute('/clientAppointment', child: (context) => const ClientAppointmentPage()),
      ],
    );
  }

  @override
  void binds(Injector i) {
    i.addSingleton<AuthSessionController>(() => AuthSessionController(i.get<SessionManagerRepository>()));
    i.addLazySingleton(CustomHttpClient.new);
    i.addLazySingleton<HttpClientInterface>(
      () => AuthenticatedHttpClient(i.get<CustomHttpClient>(), i.get<SessionManagerRepository>()),
    );
    i.addLazySingleton<UsuarioService>(UsuarioServiceImpl.new);
    i.addLazySingleton<UsuarioRepository>(UsuarioRepositoryImpl.new);
    i.addLazySingleton<UsuarioLocalRepository>(UsuarioDatabaseImpl.new);
    i.addLazySingleton<SessionManagerRepository>(SessionManagerImpl.new);
    i.addLazySingleton(UsuarioViewmodel.new);
    i.addLazySingleton<ClienteService>(ClienteServiceImpl.new);
    i.addLazySingleton<CulturaService>(CutluraServiceImpl.new);
    i.addLazySingleton<EnderecoService>(EnderecoServiceImpl.new);
    i.addLazySingleton<ClienteRepository>(ClienteRepositoryImpl.new);
    i.addLazySingleton<EnderecoRepository>(EnderecoRepositoryImpl.new);
    i.addLazySingleton<CulturaRepository>(CulturaRepositoryImpl.new);
    i.addLazySingleton<ClienteLocalRepository>(ClienteDatabaseImpl.new);
    i.addLazySingleton<ClienteCulturaLocalRepository>(ClienteCulturaDatabaseImpl.new);
    i.addLazySingleton<EnderecoLocalRepository>(EnderecoDatabaseImpl.new);
    i.addLazySingleton<ProjetoLocalRepository>(ProjetoDatabaseImpl.new);
    i.addLazySingleton<LoteLocalRepository>(LoteDatabaseImpl.new);
    i.addLazySingleton<LoteCulturaLocalRepository>(LoteCulturaDatabaseImpl.new);
    i.addLazySingleton<CulturaLocalRepository>(CulturaDatabaseImpl.new);
    i.addLazySingleton(ClienteViewmodel.new);
    super.binds(i);
    // Services
    // i.addLazySingleton<HttpClientInterface>(CustomHttpClient.new);
    // i.addLazySingleton<UsuarioService>(UsuarioServiceImpl.new);
    // i.addLazySingleton<ClienteService>(ClienteServiceImpl.new);
    // i.addLazySingleton<CulturaService>(CutluraServiceImpl.new);
    // i.addLazySingleton<EnderecoService>(EnderecoServiceImpl.new);

    // // Repositories
    // i.addLazySingleton<UsuarioRepository>(UsuarioRepositoryImpl.new);
    // i.addLazySingleton<ClienteRepository>(ClienteRepositoryImpl.new);
    // i.addLazySingleton<EnderecoRepository>(EnderecoRepositoryImpl.new);
    // i.addLazySingleton<CulturaRepository>(CulturaRepositoryImpl.new);

    // // Local Database
    // i.addLazySingleton<UsuarioLocalRepository>(UsuarioDatabaseImpl.new);
    // i.addLazySingleton<ClienteLocalRepository>(ClienteDatabaseImpl.new);
    // i.addLazySingleton<ClienteCulturaLocalRepository>(ClienteCulturaDatabaseImpl.new);
    // i.addLazySingleton<EnderecoLocalRepository>(EnderecoDatabaseImpl.new);
    // i.addLazySingleton<ProjetoLocalRepository>(ProjetoDatabaseImpl.new);
    // i.addLazySingleton<LoteLocalRepository>(LoteDatabaseImpl.new);
    // i.addLazySingleton<LoteCulturaLocalRepository>(LoteCulturaDatabaseImpl.new);
    // i.addLazySingleton<CulturaLocalRepository>(CulturaDatabaseImpl.new);

    // // Viewmodels
    // i.addLazySingleton(UsuarioViewmodel.new);
    // i.addLazySingleton(ClienteViewmodel.new);
    // i.addLazySingleton(EnderecoViewmodel.new);
    // i.addLazySingleton(CulturaViewmodel.new);
    // i.addLazySingleton(ProjetoViewmodel.new);
    // i.addLazySingleton(LoteViewmodel.new);
  }
}
