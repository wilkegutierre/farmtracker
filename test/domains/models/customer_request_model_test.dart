import 'package:farmtracker/databases/models/response/customer_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final customerJson = {
    'id': 'customer-001',
    'proprietario': 'João Silva',
    'responsavelTecnico': 'Dr. Pedro',
    'projeto': 'projeto-001',
    'email': 'fazenda@test.com',
    'primaryPhone': '11999990000',
    'secondaryPhone': '11888880000',
    'customerSituation': 1,
    'entity': 'entity-001',
    'address': 'address-001',
    'orgOwner': 'org-001',
    'walletId': 'wallet-001',
  };

  final customerFixture = CustomerResponseModel(
    id: 'customer-001',
    proprietario: 'João Silva',
    responsavelTecnico: 'Dr. Pedro',
    projeto: 'projeto-001',
    email: 'fazenda@test.com',
    primaryPhone: '11999990000',
    secondaryPhone: '11888880000',
    customerSituation: 1,
    entity: 'entity-001',
    address: 'address-001',
    orgOwner: 'org-001',
    walletId: 'wallet-001',
  );

  group('CustomerRequestModel', () {
    test('fromJson desserializa os campos da cliente_table', () {
      final customer = CustomerResponseModel.fromJson(customerJson);

      expect(customer.id, 'customer-001');
      expect(customer.proprietario, 'João Silva');
      expect(customer.responsavelTecnico, 'Dr. Pedro');
      expect(customer.projeto, 'projeto-001');
      expect(customer.email, 'fazenda@test.com');
      expect(customer.primaryPhone, '11999990000');
      expect(customer.secondaryPhone, '11888880000');
      expect(customer.customerSituation, 1);
      expect(customer.entity, 'entity-001');
      expect(customer.address, 'address-001');
      expect(customer.orgOwner, 'org-001');
      expect(customer.walletId, 'wallet-001');
    });

    test('toJson serializa os campos corretamente', () {
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
      ]);
    });
  });
}
