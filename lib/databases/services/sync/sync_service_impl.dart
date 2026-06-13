// import 'package:farmtracker/domains/repositories/customer/customer_repository.dart';

// class SyncEngine {
//   final CustomerRepository _customerRepo;
//   final AppointmentRepository _appointmentRepo;
//   final SyncQueueDao _syncQueueDao; // Sua classe que acessa o Sqflite

//   SyncEngine(this._customerRepo, this._appointmentRepo, this._syncQueueDao);

//   // O "Segredo" está aqui: mapear a tabela para o repositório correto
//   SyncRepository _getRepository(SyncTable table) {
//     switch (table) {
//       case SyncTable.customer:
//         return _customerRepo;
//       case SyncTable.appointment:
//         return _appointmentRepo;
//       default:
//         throw UnimplementedError('Repositório não configurado para a tabela ${table.name}');
//     }
//   }

//   // O Loop de sincronização que roda em segundo plano
//   Future<void> processSyncQueue() async {
//     // 1. Busca o primeiro item PENDING da fila local
//     final queueItem = await _syncQueueDao.getNextPendingItem();
//     if (queueItem == null) return; // Fila vazia, encerra.

//     // 2. Transforma as strings da fila em Enums seguros
//     final table = SyncTable.fromString(queueItem.tableName);
//     final action = SyncAction.values.byName(queueItem.action);

//     // 3. Obtém dinamicamente o repositório correto sem usar IFs
//     final repository = _getRepository(table);

//     // 4. Altera o status local para evitar duplicidade
//     await _syncQueueDao.updateStatus(queueItem.id, 'SYNCING');

//     // 5. Executa a requisição HTTP mapeada
//     final result = await repository.sendToServer(
//       recordId: queueItem.recordId,
//       action: action,
//       payload: queueItem.payload, // O JSON que já estava salvo na fila
//     );

//     // 6. Trata o retorno da API
//     await result.fold(
//       (success) async {
//         // Deleta da fila se deu certo no Spring Boot
//         await _syncQueueDao.delete(queueItem.id);
//         // Chama recursivamente para processar o próximo item da fila
//         processSyncQueue(); 
//       },
//       (failure) async {
//         // Se a API rejeitou, marca o erro para o usuário corrigir na UI
//         await _syncQueueDao.markAsError(queueItem.id, failure.message);
//       },
//     );
//   }
// }