import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/farmtracker_database.dart';
import 'package:farmtracker/databases/local/repositories/appointment_execution_local_repository.dart';
import 'package:farmtracker/databases/local/tables/appointment_execution_table.dart';
import 'package:farmtracker/models/domain/appointment_execution_model.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sqflite/sqflite.dart';

class AppointmentExecutionDatabaseImpl implements AppointmentExecutionLocalRepository {
  late Database db;

  @override
  AsyncResult<List<AppointmentExecutionModel>> executions() async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final data = await db.query(appointmentExecutionTable, orderBy: 'datetime DESC');
      return Success(_mapRows(data));
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<AppointmentExecutionModel> obterPorId(String id) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final data = await db.query(appointmentExecutionTable, where: 'id = ?', whereArgs: [id]);
      if (data.isNotEmpty) {
        return Success(AppointmentExecutionModel.fromJson(Map<String, dynamic>.from(data.first)));
      }
      return Failure(NotFoundDataBaseError());
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<AppointmentExecutionModel> obterPorAppointmentId(String appointmentId) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final data = await db.query(
        appointmentExecutionTable,
        where: 'appointmentId = ?',
        whereArgs: [appointmentId],
        orderBy: 'datetime DESC',
        limit: 1,
      );
      if (data.isNotEmpty) {
        return Success(AppointmentExecutionModel.fromJson(Map<String, dynamic>.from(data.first)));
      }
      return Failure(NotFoundDataBaseError());
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<bool> gravar(AppointmentExecutionModel execution) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      await db.insert(appointmentExecutionTable, execution.toJson());
      return const Success(true);
    } catch (_) {
      return Failure(InsertDataBaseError());
    }
  }

  @override
  AsyncResult<bool> alterar(AppointmentExecutionModel execution) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final result = await db.update(
        appointmentExecutionTable,
        execution.toJson(),
        where: 'id = ?',
        whereArgs: [execution.id],
      );
      return Success(result == 1);
    } catch (_) {
      return Failure(InsertDataBaseError());
    }
  }

  List<AppointmentExecutionModel> _mapRows(List<Map<String, Object?>> data) {
    return data.map((row) => AppointmentExecutionModel.fromJson(Map<String, dynamic>.from(row))).toList();
  }
}
