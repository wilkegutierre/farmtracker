import 'package:farmtracker/databases/models/enum/sync_table_action.dart';
import 'package:result_dart/result_dart.dart';

abstract class SyncRepository {
  // Método que o motor de sincronização vai chamar de forma genérica
  Future<AsyncResult<dynamic>> sendToServer({
    required String recordId,
    required SyncAction action,
    required Map<String, dynamic> payload,
  });
}
