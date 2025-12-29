import 'package:farmtracker/databases/errors/app_failure_interface.dart';
import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/farmtracker_database.dart';
import 'package:farmtracker/databases/local/repositories/motivo_agenda_local_repository.dart';
import 'package:farmtracker/databases/local/tables/motivo_agenda_table.dart';
import 'package:farmtracker/databases/models/response/motivo_agenda_response_model.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sqflite/sqflite.dart';

class MotivoAgendaDatabaseImpl implements MotivoAgendaLocalRepository {
  late Database db;

  @override
  AsyncResult<MotivoAgendaResponseModel> motivoAgenda(String uuid) async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      String whereField = 'uuid';
      final data = await db.query(motivoAgendaTable, where: '$whereField = ?', whereArgs: [uuid]);
      if (data.isNotEmpty) {
        final result = List<Map<String, dynamic>>.generate(
          data.length,
          (index) => Map<String, dynamic>.from(data[index]),
        ).first;
        return Success(MotivoAgendaResponseModel.fromJson(result));
      }
      return Failure(NotFoundDataBaseError());
    } catch (exception) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<List<MotivoAgendaResponseModel>> motivosAgenda() async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      final data = await db.query(motivoAgendaTable, where: null, whereArgs: [null]);
      if (data.isNotEmpty) {
        final result = List<Map<String, dynamic>>.generate(
          data.length,
          (index) => Map<String, dynamic>.from(data[index]),
        );

        List<MotivoAgendaResponseModel> motivosResult = [];
        for (var item in result as List) {
          motivosResult.add(MotivoAgendaResponseModel.fromJson(item));
        }
        return Success(motivosResult);
      }
      return Failure(NotFoundDataBaseError());
    } catch (exception) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<bool> salvar(MotivoAgendaResponseModel motivoAgenda) async {
    db = await FarmTrackerDatabase.instance.dataBase;
    try {
      await db.insert(motivoAgendaTable, motivoAgenda.toJson());
      return const Success(true);
    } catch (e) {
      return Failure(InsertDataBaseError());
    }
  }
}
