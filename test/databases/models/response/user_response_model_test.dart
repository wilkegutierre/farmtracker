import 'package:farmtracker/databases/models/response/user_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final userJson = {
    'id': 'user-001',
    'email': 'usuario@test.com',
    'phone': '11999990000',
    'address_id': 'address-001',
  };

  final userFixture = UserResponseModel(
    id: 'user-001',
    email: 'usuario@test.com',
    phone: '11999990000',
    addressId: 'address-001',
  );

  group('UserResponseModel', () {
    test('fromJson desserializa os campos da user_table', () {
      final user = UserResponseModel.fromJson(userJson);

      expect(user.id, 'user-001');
      expect(user.email, 'usuario@test.com');
      expect(user.phone, '11999990000');
      expect(user.addressId, 'address-001');
    });

    test('toJson serializa com snake_case das colunas', () {
      expect(userFixture.toJson(), userJson);
    });

    test('copyWith preserva valores não informados', () {
      final atualizado = userFixture.copyWith(email: 'novo@test.com');

      expect(atualizado.email, 'novo@test.com');
      expect(atualizado.id, userFixture.id);
      expect(atualizado.phone, userFixture.phone);
    });
  });
}
