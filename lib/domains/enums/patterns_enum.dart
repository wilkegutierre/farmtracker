enum PatternsEnum {
  //Regex utilizadas no aplicativo

  cpf(pattern: r'^\d{3}.?\d{3}.?\d{3}\-?\d{2}$'),
  cnpj(pattern: r'^(\d{2}.?\d{3}.?\d{3}\/?\d{4}\-?\d{2})$'),
  telefone(
      pattern:
          r'(?:(?:\+|00)?(55)\s?)?(?:\(?([1-9][0-9])\)?\s?)(?:((?:9\d|[2-9])\d{3})\-?(\d{4}))'),
  cep(pattern: r'(^\d{2}.\d{3})\-?(\d{3}$)');

  final String pattern;

  const PatternsEnum({required this.pattern});
}
