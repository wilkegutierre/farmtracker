import 'package:farmtracker/databases/models/response/organization_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final organizationJson = {
    'id': 'org-001',
    'description': 'Organização Agrícola Sul',
    'address_id': 'address-001',
  };

  final organizationFixture = OrganizationResponseModel(
    id: 'org-001',
    description: 'Organização Agrícola Sul',
    addressId: 'address-001',
  );

  group('OrganizationResponseModel', () {
    test('fromJson desserializa os campos da organization_table', () {
      final organization = OrganizationResponseModel.fromJson(organizationJson);

      expect(organization.id, 'org-001');
      expect(organization.description, 'Organização Agrícola Sul');
      expect(organization.addressId, 'address-001');
    });

    test('toJson serializa com snake_case das colunas', () {
      expect(organizationFixture.toJson(), organizationJson);
    });

    test('copyWith preserva valores não informados', () {
      final atualizado = organizationFixture.copyWith(description: 'Nova Organização');

      expect(atualizado.description, 'Nova Organização');
      expect(atualizado.id, organizationFixture.id);
      expect(atualizado.addressId, organizationFixture.addressId);
    });
  });
}
