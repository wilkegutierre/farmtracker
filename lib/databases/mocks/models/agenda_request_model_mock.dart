import 'package:farmtracker/databases/models/request/agenda_request_model.dart';

class AgendaRequestModelMock {
  AgendaRequestModel getMockAgendaRequest() {
    return AgendaRequestModel(
      uuid: '987feda-b654-12d3-a456-426614174000',
      usuario: '123e4567-e89b-12d3-a456-426614174000',
      titulo: 'Visita Técnica',
      descricao: 'Visita para avaliação de pragas',
      dataCriacao: DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  List<AgendaRequestModel> getMockAgendaRequestList() {
    return [
      AgendaRequestModel(
        uuid: '987feda-b654-12d3-a456-426614174000',
        usuario: '123e4567-e89b-12d3-a456-426614174000',
        titulo: 'Visita Técnica',
        descricao: 'Visita para avaliação de pragas',
        dataCriacao: DateTime.now().millisecondsSinceEpoch.toString(),
      ),
      AgendaRequestModel(
        uuid: '987feda-b654-12d3-a456-426614174001',
        usuario: '123e4567-e89b-12d3-a456-426614174001',
        titulo: 'Manutenção Preventiva',
        descricao: 'Manutenção de equipamentos',
        dataCriacao: DateTime.now().millisecondsSinceEpoch.toString(),
      ),
      AgendaRequestModel(
        uuid: '987feda-b654-12d3-a456-426614174002',
        usuario: '123e4567-e89b-12d3-a456-426614174002',
        titulo: 'Consultoria',
        descricao: 'Consultoria sobre manejo de cultivo',
        dataCriacao: DateTime.now().millisecondsSinceEpoch.toString(),
      ),
    ];
  }
}
