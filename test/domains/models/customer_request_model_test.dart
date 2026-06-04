import 'package:farmtracker/databases/models/response/customer_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final customerJson = {
    'id': 'customer-001',
    'proprietario': 'João Silva',
    'responsavel_technico': 'Dr. Pedro',
    'projeto': 'projeto-001',
    'email': 'fazenda@test.com',
    'primary_phone': '11999990000',
    'secondary_phone': '11888880000',
    'customer_situation': 1,
    'entity': 'entity-001',
    'address': 'address-001',
    'org_owner': 'org-001',
    'wallet_id': 'wallet-001',
    'created_by': 'user-001',
    'created_at': '2026-01-01T00:00:00.000',
    'updated_at': '2026-01-02T00:00:00.000',
  };

  final customerFixture = CustomerResponseModel(
    id: 'customer-001',
    proprietario: 'João Silva',
    responsavelTechnico: 'Dr. Pedro',
    projeto: 'projeto-001',
    email: 'fazenda@test.com',
    primaryPhone: '11999990000',
    secondaryPhone: '11888880000',
    customerSituation: 1,
    entity: 'entity-001',
    address: 'address-001',
    orgOwner: 'org-001',
    walletId: 'wallet-001',
    createdBy: 'user-001',
    createdAt: '2026-01-01T00:00:00.000',
    updatedAt: '2026-01-02T00:00:00.000',
  );

  group('CustomerRequestModel', () {
    test('fromJson desserializa os campos da cliente_table', () {
      final customer = CustomerResponseModel.fromJson(customerJson);

      expect(customer.id, 'customer-001');
      expect(customer.proprietario, 'João Silva');
      expect(customer.responsavelTechnico, 'Dr. Pedro');
      expect(customer.projeto, 'projeto-001');
      expect(customer.email, 'fazenda@test.com');
      expect(customer.primaryPhone, '11999990000');
      expect(customer.secondaryPhone, '11888880000');
      expect(customer.customerSituation, 1);
      expect(customer.entity, 'entity-001');
      expect(customer.address, 'address-001');
      expect(customer.orgOwner, 'org-001');
      expect(customer.walletId, 'wallet-001');
      expect(customer.createdBy, 'user-001');
      expect(customer.createdAt, '2026-01-01T00:00:00.000');
      expect(customer.updatedAt, '2026-01-02T00:00:00.000');
    });

    test('toJson serializa com snake_case das colunas', () {
      expect(customerFixture.toJson(), customerJson);
    });

    test('copyWith preserva valores não informados', () {
      final atualizado = customerFixture.copyWith(email: 'novo@test.com');

      expect(atualizado.email, 'novo@test.com');
      expect(atualizado.id, customerFixture.id);
      expect(atualizado.orgOwner, customerFixture.orgOwner);
    });

    test('props inclui todos os campos para Equatable', () {
      expect(customerFixture.props, [
        'customer-001',
        'João Silva',
        'Dr. Pedro',
        'projeto-001',
        'fazenda@test.com',
        '11999990000',
        '11888880000',
        1,
        'entity-001',
        'address-001',
        'org-001',
        'wallet-001',
        'user-001',
        '2026-01-01T00:00:00.000',
        '2026-01-02T00:00:00.000',
      ]);
    });
  });
}
