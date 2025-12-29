import 'package:farmtracker/domains/enums/patterns_enum.dart';
import 'package:farmtracker/views/utils/custom_text_error.dart';
import 'package:flutter/material.dart';

import 'package:flutter_triple/flutter_triple.dart';
import 'package:form_field_validator/form_field_validator.dart';

///Retorna um MaterialApp com o widget passado como filho
MaterialApp buildTestableWidget(Key testkey, Widget widget) {
  return MaterialApp(key: testkey, home: RxRoot(child: widget));
}

MultiValidator cpfCnpjPatternValidator(int length, {String? textError}) {
  const cnpjLength = 18;
  const cpfLength = 14;

  if ((length > 0) && (length > cpfLength) && (length < cnpjLength || length > cnpjLength)) {
    return MultiValidator([
      PatternValidator(PatternsEnum.cnpj.pattern, errorText: 'CNPJ inválido!'),
      RequiredValidator(errorText: textError ?? 'Informe o CNPJ ou CPF!')
    ]);
  } else if (length > 0 && length < cpfLength) {
    return MultiValidator([
      PatternValidator(PatternsEnum.cpf.pattern, errorText: 'CPF inválido!.'),
      RequiredValidator(errorText: textError ?? 'Informe o CNPJ ou CPF!')
    ]);
  } else {
    return MultiValidator([]);
  }
}

MultiValidator telefoneValidator({String textError = 'Telefone inválido!'}) => MultiValidator([
      PatternValidator(PatternsEnum.telefone.pattern, errorText: textError),
      RequiredValidator(errorText: 'Informe o telefone!')
    ]);

MultiValidator cepValidator({String textError = 'CEP inválido!'}) => MultiValidator(
    [PatternValidator(PatternsEnum.cep.pattern, errorText: textError), RequiredValidator(errorText: 'Informe o CEP!')]);

///Exibe uma mensagen em um MaterialBanner.
///O tempo padrão de exibição da mensagem [duration] é 4 segundos.
///Se o booleano [isError] for true a cor de background será vermelha.
showBanner(
    {required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
    bool isError = false}) {
  ScaffoldMessenger.of(context).showMaterialBanner(
    MaterialBanner(
        content: isError
            ? CustomTextError(
                textError: message,
                showIcon: false,
              )
            : Text(message),
        backgroundColor: isError ? Colors.redAccent.withOpacity(.3) : Colors.grey.withOpacity(.3),
        actions: const [Text('')]),
  );
  Future.delayed(duration, () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner());
}

///Exibe uma mensagen em uma Snackbar.
///O tempo padrão de exibição da mensagem [duration] é 4 segundos.
///Se o booleano [isError] for true a cor de background será vermelha.
showSnackBar(
    {required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
    bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: duration,
      content: isError
          ? CustomTextError(
              textError: message,
              showIcon: false,
            )
          : Text(message),
      backgroundColor: isError ? Colors.red : null,
    ),
  );
}

///Exibe um DateTimePicker
Future<DateTime?> getDateTime({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  return await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );
}
