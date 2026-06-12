import 'package:farmtracker/databases/models/response/type_visit_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final typeVisitJson = {
    'id': 1,
    'description': 'Monitoramento',
    'orgOwner': 'org-001',
    'createdAt': '2026-01-01T00:00:00.000',
    'updatedAt': '2026-01-02T00:00:00.000',
    'createdBy': 'user-001',
  };

  final typeVisitFixture = TypeVisitResponseModel(
    id: 1,
    description: 'Monitoramento',
    orgOwner: 'org-001',
    createdAt: '2026-01-01T00:00:00.000',
    updatedAt: '2026-01-02T00:00:00.000',
    createdBy: 'user-001',
  );

  group('TypeVisitResponseModel', () {
    test('fromJson desserializa os campos da type_visit_table', () {
      final typeVisit = TypeVisitResponseModel.fromJson(typeVisitJson);

      expect(typeVisit.id, 1);
      expect(typeVisit.description, 'Monitoramento');
      expect(typeVisit.orgOwner, 'org-001');
      expect(typeVisit.createdAt, '2026-01-01T00:00:00.000');
      expect(typeVisit.updatedAt, '2026-01-02T00:00:00.000');
      expect(typeVisit.createdBy, 'user-001');
    });

    test('toJson serializa os campos corretamente', () {
      expect(typeVisitFixture.toJson(), typeVisitJson);
    });

    test('copyWith preserva valores não informados', () {
      final atualizado = typeVisitFixture.copyWith(description: 'Tratamento');

      expect(atualizado.description, 'Tratamento');
      expect(atualizado.id, typeVisitFixture.id);
      expect(atualizado.orgOwner, typeVisitFixture.orgOwner);
    });
  });
}
