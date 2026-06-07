import 'package:farmtracker/databases/models/response/base_entity_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final baseEntityJson = {
    'id': 'entity-001',
    'orgOwner': 'org-001',
    'name': 'Fazenda Boa Vista',
    'type': 'PJ',
    'docNumber': '12345678000199',
    'createdAt': '2026-01-01T00:00:00.000',
    'updatedAt': '2026-01-02T00:00:00.000',
    'createdBy': 'user-001',
  };

  final baseEntityFixture = BaseEntityResponseModel(
    id: 'entity-001',
    orgOwner: 'org-001',
    name: 'Fazenda Boa Vista',
    type: 'PJ',
    docNumber: '12345678000199',
    createdAt: '2026-01-01T00:00:00.000',
    updatedAt: '2026-01-02T00:00:00.000',
    createdBy: 'user-001',
  );

  group('BaseEntityResponseModel', () {
    test('fromJson desserializa os campos da base_entity_table', () {
      final baseEntity = BaseEntityResponseModel.fromJson(baseEntityJson);

      expect(baseEntity.id, 'entity-001');
      expect(baseEntity.orgOwner, 'org-001');
      expect(baseEntity.name, 'Fazenda Boa Vista');
      expect(baseEntity.type, 'PJ');
      expect(baseEntity.docNumber, '12345678000199');
      expect(baseEntity.createdAt, '2026-01-01T00:00:00.000');
      expect(baseEntity.updatedAt, '2026-01-02T00:00:00.000');
      expect(baseEntity.createdBy, 'user-001');
    });

    test('toJson serializa os campos corretamente', () {
      expect(baseEntityFixture.toJson(), baseEntityJson);
    });

    test('copyWith preserva valores não informados', () {
      final atualizado = baseEntityFixture.copyWith(name: 'Fazenda Nova');

      expect(atualizado.name, 'Fazenda Nova');
      expect(atualizado.id, baseEntityFixture.id);
      expect(atualizado.type, baseEntityFixture.type);
    });
  });
}
