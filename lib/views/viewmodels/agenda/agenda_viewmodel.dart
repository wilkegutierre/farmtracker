import 'package:farmtracker/databases/local/repositories/motivo_agenda_local_repository.dart';
import 'package:farmtracker/domains/repositories/agenda/agenda_repository.dart';
import 'package:farmtracker/domains/repositories/motivo_agenda/motivo_agenda_repository.dart';
import 'package:farmtracker/views/viewmodels/agenda/agenda_data.dart';
import 'package:flutter/foundation.dart';

class AgendaViewmodel extends ChangeNotifier {
  final AgendaRepository agendaRepository;
  final MotivoAgendaRepository motivoAgendaRepository;
  final MotivoAgendaLocalRepository motivoAgendaLocalRepository;

  AgendaViewmodel(this.agendaRepository, this.motivoAgendaRepository, this.motivoAgendaLocalRepository);

  final agendaData = AgendaData();

  Future<void> buscarMotivosAgenda(String userUuid) async {
    final result = await motivoAgendaRepository.getMotivos(userUuid);
    result.fold(
      (success) {
        for (var motivo in success) {
          motivoAgendaLocalRepository.salvar(motivo);
        }
        agendaData.motivosAgendaModel = success;
      },
      (failure) {
        // Handle failure
      },
    );
    notifyListeners();
  }
}
