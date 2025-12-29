import 'package:farmtracker/views/appointment/pages/appointment_page.dart';
import 'package:farmtracker/views/appointment/pages/client_appointment_page.dart';
import 'package:farmtracker/views/appointment/pages/execute_appointment_page.dart';
import 'package:farmtracker/views/clients/page/cadastro_cliente_page.dart';
import 'package:farmtracker/views/clients/page/relacao_cliente_page.dart';
import 'package:farmtracker/views/culture/page/cultura_page.dart';
import 'package:farmtracker/views/dashboard/page/dashboard_page.dart';
import 'package:farmtracker/views/lot/page/lote_page.dart';
import 'package:farmtracker/views/project/page/projeto_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RouteModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child('/', child: (context) => const DashboardPage()); //LoginPage());
    r.child('/clienteRelacao', child: (context) => const RelacaoClientePage());
    r.child('/clienteCadastro', child: (context) => const CadastroClientePage());
    r.child('/cultura', child: (context) => const CulturaPage());
    r.child('/projeto', child: (context) => const ProjetoPage());
    r.child('/lote', child: (context) => const LotePage());
    r.child(
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
    );
    r.child(
      '/executeAppointment',
      child: (context) {
        final args = r.args.data;
        return ExecuteAppointmentPage(clientName: args?['clientName'] as String?);
      },
    );
    r.child('/clientAppointment', child: (context) => const ClientAppointmentPage());
  }

  @override
  void binds(Injector i) {
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
