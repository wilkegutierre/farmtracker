import 'package:farmtracker/domains/models/crop_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const cropJson = {
    'id': 'crop-001',
    'name': 'Soja',
    'org_owner': 'org-001',
    'created_at': '2026-01-01T00:00:00.000',
    'updated_at': '2026-01-02T00:00:00.000',
    'created_by': 'user-001',
  };

  final cropFixture = CropModel(
    id: 'crop-001',
    name: 'Soja',
    orgOwner: 'org-001',
    createdAt: '2026-01-01T00:00:00.000',
    updatedAt: '2026-01-02T00:00:00.000',
    createdBy: 'user-001',
  );

  group('CropModel', () {
    test('fromJson desserializa os campos da crop_table', () {
      final crop = CropModel.fromJson(cropJson);

      expect(crop.id, 'crop-001');
      expect(crop.name, 'Soja');
      expect(crop.orgOwner, 'org-001');
      expect(crop.createdAt, '2026-01-01T00:00:00.000');
      expect(crop.updatedAt, '2026-01-02T00:00:00.000');
      expect(crop.createdBy, 'user-001');
    });

    test('toJson serializa com snake_case das colunas', () {
      expect(cropFixture.toJson(), cropJson);
    });

    test('copyWith preserva valores não informados', () {
      final atualizado = cropFixture.copyWith(name: 'Milho');

      expect(atualizado.name, 'Milho');
      expect(atualizado.id, cropFixture.id);
      expect(atualizado.orgOwner, cropFixture.orgOwner);
    });

    test('props inclui todos os campos para Equatable', () {
      expect(cropFixture.props, [
        'crop-001',
        'Soja',
        'org-001',
        '2026-01-01T00:00:00.000',
        '2026-01-02T00:00:00.000',
        'user-001',
      ]);
    });
  });
}
