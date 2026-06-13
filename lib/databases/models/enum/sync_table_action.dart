enum SyncTable {
  customer,
  appointment,
  wallet;

  // Converte a String do banco Sqflite para o Enum correspondente
  static SyncTable fromString(String value) {
    return SyncTable.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw Exception('Tabela $value não mapeada no motor de sincronização.'),
    );
  }
}

enum SyncAction { CREATE, UPDATE }
