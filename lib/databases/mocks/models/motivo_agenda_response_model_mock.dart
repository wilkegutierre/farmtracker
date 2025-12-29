import 'package:farmtracker/databases/models/response/motivo_agenda_response_model.dart';

MotivoAgendaResponseModel mockMotivoAgendaResponseModel() {
  return MotivoAgendaResponseModel(
    uuid: '550e8400-e29b-41d4-a716-446655440000', // UUID example
    nome: 'Visita de rotina',
    descricao: 'Consulta de rotina',
  );
}

MotivoAgendaResponseModel mockMotivoAgendaResponseModel2() {
  return MotivoAgendaResponseModel(
    uuid: '550e8400-e29b-41d4-a716-446655440001',
    nome: 'Atendimento emergencial',
    descricao: 'Visita não programada para atendimento urgente',
  );
}

MotivoAgendaResponseModel mockMotivoAgendaResponseModel3() {
  return MotivoAgendaResponseModel(
    uuid: '550e8400-e29b-41d4-a716-446655440002',
    nome: 'Avaliação técnica',
    descricao: 'Visita para análise e diagnóstico técnico',
  );
}

List<MotivoAgendaResponseModel> mockMotivoAgendaModelList() {
  return [
    mockMotivoAgendaResponseModel(),
    mockMotivoAgendaResponseModel2(),
    mockMotivoAgendaResponseModel3(),
  ];
}
