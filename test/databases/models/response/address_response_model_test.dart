import 'package:farmtracker/databases/models/response/address_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final addressJson = {
    'id': 'address-001',
    'orgOwner': 'org-001',
    'owner': 'customer-001',
    'street': 'Rua das Flores',
    'number': '100',
    'district': 'Centro',
    'city': 'Ribeirão Preto',
    'state': 'São Paulo',
    'uf': 'SP',
    'zipCode': '14000000',
    'country': 'Brasil',
    'reference': 'Próximo ao mercado',
    'complement': 'Sala 2',
    'lat': -21.1775,
    'longitude': -47.8103,
    'createdAt': '2026-01-01T00:00:00.000',
    'updatedAt': '2026-01-02T00:00:00.000',
    'createdBy': 'user-001',
  };

  final addressFixture = AddressResponseModel(
    id: 'address-001',
    orgOwner: 'org-001',
    owner: 'customer-001',
    street: 'Rua das Flores',
    number: '100',
    district: 'Centro',
    city: 'Ribeirão Preto',
    state: 'São Paulo',
    uf: 'SP',
    zipCode: '14000000',
    country: 'Brasil',
    reference: 'Próximo ao mercado',
    complement: 'Sala 2',
    lat: -21.1775,
    longitude: -47.8103,
    createdAt: '2026-01-01T00:00:00.000',
    updatedAt: '2026-01-02T00:00:00.000',
    createdBy: 'user-001',
  );

  group('AddressResponseModel', () {
    test('fromJson desserializa os campos da address_table', () {
      final address = AddressResponseModel.fromJson(addressJson);

      expect(address.id, 'address-001');
      expect(address.orgOwner, 'org-001');
      expect(address.owner, 'customer-001');
      expect(address.street, 'Rua das Flores');
      expect(address.number, '100');
      expect(address.district, 'Centro');
      expect(address.city, 'Ribeirão Preto');
      expect(address.state, 'São Paulo');
      expect(address.uf, 'SP');
      expect(address.zipCode, '14000000');
      expect(address.country, 'Brasil');
      expect(address.reference, 'Próximo ao mercado');
      expect(address.complement, 'Sala 2');
      expect(address.lat, -21.1775);
      expect(address.longitude, -47.8103);
      expect(address.createdAt, '2026-01-01T00:00:00.000');
      expect(address.updatedAt, '2026-01-02T00:00:00.000');
      expect(address.createdBy, 'user-001');
    });

    test('toJson serializa os campos corretamente', () {
      expect(addressFixture.toJson(), addressJson);
    });

    test('copyWith preserva valores não informados', () {
      final atualizado = addressFixture.copyWith(city: 'São Paulo');

      expect(atualizado.city, 'São Paulo');
      expect(atualizado.id, addressFixture.id);
      expect(atualizado.owner, addressFixture.owner);
    });
  });
}
