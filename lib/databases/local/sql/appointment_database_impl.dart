import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/farmtracker_database.dart';
import 'package:farmtracker/databases/local/repositories/appointment_local_repository.dart';
import 'package:farmtracker/databases/local/tables/appointment_table.dart';
import 'package:farmtracker/models/domain/appointment_model.dart';
import 'package:flutter/foundation.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sqflite/sqflite.dart';

class AppointmentDatabaseImpl implements AppointmentLocalRepository {
  late Database db;

  @override
  AsyncResult<List<AppointmentModel>> appointments() async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final data = await db.query(appointmentTable, orderBy: 'datetime');
      return Success(_mapRows(data));
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<List<AppointmentModel>> obterPorData(DateTime date) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final String datePrefix =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final data = await db.query(
        appointmentTable,
        where: 'datetime LIKE ?',
        whereArgs: ['$datePrefix%'],
        orderBy: 'datetime',
      );
      return Success(_mapRows(data));
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<AppointmentModel> obterPorId(String id) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final data = await db.query(appointmentTable, where: 'id = ?', whereArgs: [id]);
      if (data.isNotEmpty) {
        return Success(AppointmentModel.fromJson(Map<String, dynamic>.from(data.first)));
      }
      return Failure(NotFoundDataBaseError());
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<bool> gravar(AppointmentModel appointment) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      await db.insert(appointmentTable, appointment.toJson());
      return const Success(true);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return Failure(InsertDataBaseError());
    }
  }

  @override
  AsyncResult<bool> alterar(AppointmentModel appointment) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final result = await db.update(
        appointmentTable,
        appointment.toJson(),
        where: 'id = ?',
        whereArgs: [appointment.id],
      );
      return Success(result == 1);
    } catch (_) {
      return Failure(InsertDataBaseError());
    }
  }

  List<AppointmentModel> _mapRows(List<Map<String, Object?>> data) {
    return data.map((row) => AppointmentModel.fromJson(Map<String, dynamic>.from(row))).toList();
  }
}
