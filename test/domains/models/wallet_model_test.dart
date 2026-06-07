import 'package:farmtracker/domains/models/wallet_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final walletJson = {
    'id': 'wallet-001',
    'name': 'Carteira Principal',
  };

  final walletFixture = WalletModel(id: 'wallet-001', name: 'Carteira Principal');

  group('WalletModel', () {
    test('fromJson desserializa os campos da wallet_table', () {
      final wallet = WalletModel.fromJson(walletJson);

      expect(wallet.id, 'wallet-001');
      expect(wallet.name, 'Carteira Principal');
    });

    test('toJson serializa os campos corretamente', () {
      expect(walletFixture.toJson(), walletJson);
    });

    test('copyWith preserva valores não informados', () {
      final atualizado = walletFixture.copyWith(name: 'Carteira Secundária');

      expect(atualizado.name, 'Carteira Secundária');
      expect(atualizado.id, walletFixture.id);
    });

    test('props inclui todos os campos para Equatable', () {
      expect(walletFixture.props, ['wallet-001', 'Carteira Principal']);
    });
  });
}
