import 'package:farmtracker/domains/models/wallet_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final walletJson = {
    'id': 'wallet-001',
    'name': 'Carteira Principal',
    'description': 'Carteira de clientes da região sul',
    'owner': 'user-001',
    'created_at': '2026-01-01T00:00:00.000',
    'updated_at': '2026-01-02T00:00:00.000',
    'created_by': 'user-001',
  };

  final walletFixture = WalletModel(
    id: 'wallet-001',
    name: 'Carteira Principal',
    description: 'Carteira de clientes da região sul',
    owner: 'user-001',
    createdAt: '2026-01-01T00:00:00.000',
    updatedAt: '2026-01-02T00:00:00.000',
    createdBy: 'user-001',
  );

  group('WalletModel', () {
    test('fromJson desserializa os campos da wallet_table', () {
      final wallet = WalletModel.fromJson(walletJson);

      expect(wallet.id, 'wallet-001');
      expect(wallet.name, 'Carteira Principal');
      expect(wallet.description, 'Carteira de clientes da região sul');
      expect(wallet.owner, 'user-001');
      expect(wallet.createdAt, '2026-01-01T00:00:00.000');
      expect(wallet.updatedAt, '2026-01-02T00:00:00.000');
      expect(wallet.createdBy, 'user-001');
    });

    test('toJson serializa com snake_case das colunas', () {
      expect(walletFixture.toJson(), walletJson);
    });

    test('copyWith preserva valores não informados', () {
      final atualizado = walletFixture.copyWith(name: 'Carteira Secundária');

      expect(atualizado.name, 'Carteira Secundária');
      expect(atualizado.id, walletFixture.id);
      expect(atualizado.owner, walletFixture.owner);
    });

    test('props inclui todos os campos para Equatable', () {
      expect(walletFixture.props, [
        'wallet-001',
        'Carteira Principal',
        'Carteira de clientes da região sul',
        'user-001',
        '2026-01-01T00:00:00.000',
        '2026-01-02T00:00:00.000',
        'user-001',
      ]);
    });
  });
}
