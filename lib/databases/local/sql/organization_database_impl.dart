import 'package:farmtracker/databases/errors/database_error.dart';
import 'package:farmtracker/databases/local/farmtracker_database.dart';
import 'package:farmtracker/databases/local/repositories/organization_local_repository.dart';
import 'package:farmtracker/databases/local/tables/organization_table.dart';
import 'package:farmtracker/databases/models/response/organization_response_model.dart';
import 'package:result_dart/result_dart.dart';
import 'package:sqflite/sqflite.dart';

class OrganizationDatabaseImpl implements OrganizationLocalRepository {
  late Database db;

  @override
  AsyncResult<List<OrganizationResponseModel>> organizations() async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final data = await db.query(organizationTable, orderBy: 'description');
      return Success(_mapRows(data));
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<OrganizationResponseModel> obterPorId(String id) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final data = await db.query(organizationTable, where: 'id = ?', whereArgs: [id]);
      if (data.isNotEmpty) {
        return Success(OrganizationResponseModel.fromJson(Map<String, dynamic>.from(data.first)));
      }
      return Failure(NotFoundDataBaseError());
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<List<OrganizationResponseModel>> obterPorAddressId(String addressId) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final data = await db.query(
        organizationTable,
        where: 'address_id = ?',
        whereArgs: [addressId],
        orderBy: 'description',
      );
      return Success(_mapRows(data));
    } catch (_) {
      return Failure(SearchDataBaseError());
    }
  }

  @override
  AsyncResult<bool> gravar(OrganizationResponseModel organization) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      await db.insert(organizationTable, organization.toJson());
      return const Success(true);
    } catch (_) {
      return Failure(InsertDataBaseError());
    }
  }

  @override
  AsyncResult<bool> alterar(OrganizationResponseModel organization) async {
    try {
      db = await FarmTrackerDatabase.instance.dataBase;
      final result = await db.update(
        organizationTable,
        organization.toJson(),
        where: 'id = ?',
        whereArgs: [organization.id],
      );
      return Success(result == 1);
    } catch (_) {
      return Failure(InsertDataBaseError());
    }
  }

  List<OrganizationResponseModel> _mapRows(List<Map<String, Object?>> data) {
    return data.map((row) => OrganizationResponseModel.fromJson(Map<String, dynamic>.from(row))).toList();
  }
}
