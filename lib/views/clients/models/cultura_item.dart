class CulturaItem {
  static const String _separadorCulturas = ';;;';
  static const String _separadorCampos = '|';

  final String projeto;
  final String lote;
  final double tamanhoHectare;
  final String cultura;

  CulturaItem({
    required this.projeto,
    required this.lote,
    required this.tamanhoHectare,
    required this.cultura,
  });

  String get rotuloExibicao => 'P: $projeto - L: $lote - C: $cultura';

  String toSerialized() => '$projeto$_separadorCampos$lote$_separadorCampos$tamanhoHectare$_separadorCampos$cultura';

  static CulturaItem? fromSerialized(String value) {
    final List<String> partes = value.split(_separadorCampos);
    if (partes.length != 4) return null;

    final double? tamanho = double.tryParse(partes[2].trim());
    if (tamanho == null || tamanho <= 0) return null;

    return CulturaItem(
      projeto: partes[0].trim(),
      lote: partes[1].trim(),
      tamanhoHectare: tamanho,
      cultura: partes[3].trim(),
    );
  }

  static CulturaItem? fromRotuloExibicao(String value) {
    final RegExpMatch? match = RegExp(r'^P:\s*(.*?)\s*-\s*L:\s*(.*?)\s*-\s*C:\s*(.*?)$').firstMatch(value.trim());
    if (match == null) return null;

    return CulturaItem(
      projeto: match.group(1)!.trim(),
      lote: match.group(2)!.trim(),
      cultura: match.group(3)!.trim(),
      tamanhoHectare: 1,
    );
  }

  static List<CulturaItem> listFromProjetoCampo(String? projeto) {
    final String? texto = projeto?.trim();
    if (texto == null || texto.isEmpty) return [];

    if (texto.contains(_separadorCulturas)) {
      return texto
          .split(_separadorCulturas)
          .map(fromSerialized)
          .whereType<CulturaItem>()
          .toList();
    }

    final CulturaItem? serializado = fromSerialized(texto);
    if (serializado != null) return [serializado];

    final CulturaItem? rotulo = fromRotuloExibicao(texto);
    if (rotulo != null) return [rotulo];

    return [
      CulturaItem(
        projeto: texto,
        lote: '-',
        cultura: '-',
        tamanhoHectare: 1,
      ),
    ];
  }

  static String? serializarLista(List<CulturaItem> culturas) {
    if (culturas.isEmpty) return null;
    return culturas.map((cultura) => cultura.toSerialized()).join(_separadorCulturas);
  }

  @override
  String toString() => rotuloExibicao;
}
