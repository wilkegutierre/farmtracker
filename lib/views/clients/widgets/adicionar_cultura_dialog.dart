import 'package:farmtracker/views/clients/models/cultura_item.dart';
import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const List<String> opcoesCulturasPadrao = ['Manga', 'Goiaba', 'Laranja', 'Limão', 'Melancia', 'Mamão'];

Future<CulturaItem?> showAdicionarCulturaDialog(
  BuildContext context, {
  List<String> opcoesCulturas = opcoesCulturasPadrao,
  CulturaItem? culturaInicial,
}) {
  return showDialog<CulturaItem>(
    context: context,
    builder: (_) => _AdicionarCulturaDialog(
      opcoesCulturas: opcoesCulturas,
      culturaInicial: culturaInicial,
    ),
  );
}

class _AdicionarCulturaDialog extends StatefulWidget {
  final List<String> opcoesCulturas;
  final CulturaItem? culturaInicial;

  const _AdicionarCulturaDialog({
    required this.opcoesCulturas,
    this.culturaInicial,
  });

  bool get isEdicao => culturaInicial != null;

  @override
  State<_AdicionarCulturaDialog> createState() => _AdicionarCulturaDialogState();
}

class _AdicionarCulturaDialogState extends State<_AdicionarCulturaDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _projetoController = TextEditingController();
  final TextEditingController _loteController = TextEditingController();
  final TextEditingController _tamanhoController = TextEditingController();
  String? _culturaSelecionada;

  @override
  void initState() {
    super.initState();
    final CulturaItem? inicial = widget.culturaInicial;
    if (inicial != null) {
      _projetoController.text = inicial.projeto;
      _loteController.text = inicial.lote;
      _tamanhoController.text = _formatarTamanho(inicial.tamanhoHectare);
      _culturaSelecionada = inicial.cultura;
    }
  }

  String _formatarTamanho(double tamanho) {
    if (tamanho == tamanho.roundToDouble()) {
      return tamanho.toInt().toString();
    }
    return tamanho.toString();
  }

  @override
  void dispose() {
    _projetoController.dispose();
    _loteController.dispose();
    _tamanhoController.dispose();
    super.dispose();
  }

  void _onConfirmar() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final double tamanho = double.parse(_tamanhoController.text.trim());
    Navigator.of(context).pop(
      CulturaItem(
        projeto: _projetoController.text.trim(),
        lote: _loteController.text.trim(),
        tamanhoHectare: tamanho,
        cultura: _culturaSelecionada!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEdicao ? 'Editar cultura' : 'Adicionar cultura'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Projeto',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _projetoController,
                  autofocus: !widget.isEdicao,
                  decoration: const InputDecoration(
                    hintText: 'Informe o projeto',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Campo obrigatório';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Lote',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _loteController,
                  decoration: const InputDecoration(
                    hintText: 'Informe o lote',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Campo obrigatório';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Tamanho do lote (hectare)',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _tamanhoController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
                  decoration: const InputDecoration(
                    hintText: 'Ex.: 10.5',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Campo obrigatório';
                    }
                    final double? tamanho = double.tryParse(value);
                    if (tamanho == null || tamanho <= 0) {
                      return 'Valor inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Cultura',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: _culturaSelecionada,
                  decoration: const InputDecoration(
                    hintText: 'Selecione a cultura',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                  items: widget.opcoesCulturas.map((cultura) {
                    return DropdownMenuItem<String>(value: cultura, child: Text(cultura));
                  }).toList(),
                  onChanged: (value) => setState(() => _culturaSelecionada = value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Selecione uma cultura';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancelar', style: TextStyle(color: AppColors.error)),
        ),
        FilledButton(
          onPressed: _onConfirmar,
          child: Text(widget.isEdicao ? 'Salvar' : 'Adicionar'),
        ),
      ],
    );
  }
}
