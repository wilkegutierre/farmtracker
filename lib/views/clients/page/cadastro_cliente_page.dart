import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CulturaItem {
  final String projeto;
  final String lote;
  final double tamanhoHectare;
  final String cultura;

  CulturaItem({required this.projeto, required this.lote, required this.tamanhoHectare, required this.cultura});

  @override
  String toString() {
    return '$cultura - $projeto (Lote: $lote, ${tamanhoHectare}ha)';
  }
}

class CadastroClientePage extends StatefulWidget {
  const CadastroClientePage({super.key});

  @override
  State<CadastroClientePage> createState() => _CadastroClientePageState();
}

class _CadastroClientePageState extends State<CadastroClientePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Dados básicos
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _proprietarioController = TextEditingController();
  final TextEditingController _responsavelTecnicoController = TextEditingController();

  // Contato
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  // Endereço
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _referenciaController = TextEditingController();

  // Culturas
  final List<CulturaItem> _culturas = <CulturaItem>[];

  // Opções de culturas disponíveis
  final List<String> _opcoesCulturas = ['Manga', 'Goiaba', 'Laranja', 'Limão', 'Melancia', 'Mamão'];

  @override
  void dispose() {
    _nomeController.dispose();
    _proprietarioController.dispose();
    _responsavelTecnicoController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _ruaController.dispose();
    _numeroController.dispose();
    _bairroController.dispose();
    _cepController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _complementoController.dispose();
    _referenciaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Cliente'), centerTitle: false),
      floatingActionButton: FloatingActionButton(
        onPressed: _onSalvar,
        backgroundColor: AppColors.primaryTealDark,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.save_outlined),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitulo('Nome'),
                _buildField(_nomeController, hintText: 'Informe o nome do estabelecimento'),
                const SizedBox(height: 12),
                _buildTitulo('Proprietário'),
                _buildField(_proprietarioController, hintText: 'Informe o nome do proprietário'),
                const SizedBox(height: 12),
                _buildTitulo('Responsável Técnico'),
                _buildField(_responsavelTecnicoController, hintText: 'Informe o nome do responsável técnico'),
                const SizedBox(height: 20),
                _buildSecaoTitulo('Contato'),
                const SizedBox(height: 8),
                _buildTitulo('E-mail'),
                _buildField(
                  _emailController,
                  hintText: 'Informe o e-mail de contato',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                _buildTitulo('Telefone'),
                _buildField(
                  _telefoneController,
                  hintText: '(00) 00000-0000',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9()\-\s]+'))],
                ),
                const SizedBox(height: 20),
                _buildSecaoTitulo('Endereço'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitulo('Rua'),
                          _buildField(_ruaController, hintText: 'Rua'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitulo('Número'),
                          _buildField(_numeroController, hintText: 'Nº', keyboardType: TextInputType.number),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitulo('Bairro'),
                          _buildField(_bairroController, hintText: 'Bairro'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitulo('CEP'),
                          _buildField(
                            _cepController,
                            hintText: '00000-000',
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitulo('Cidade'),
                          _buildField(_cidadeController, hintText: 'Cidade'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitulo('UF'),
                          _buildField(
                            _estadoController,
                            hintText: 'UF',
                            textCapitalization: TextCapitalization.characters,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTitulo('Complemento'),
                _buildField(_complementoController, hintText: 'Complemento'),
                const SizedBox(height: 12),
                _buildTitulo('Referência'),
                _buildField(_referenciaController, hintText: 'Ponto de referência'),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSecaoTitulo('Projetos'),
                    IconButton(
                      onPressed: _onAdicionarCultura,
                      icon: const Icon(Icons.add),
                      tooltip: 'Adicionar cultura',
                    ),
                  ],
                ),
                _buildCulturasBox(theme),
                const SizedBox(height: 84), // espaço para o FAB
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitulo(String text) {
    return Text(text, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600));
  }

  Widget _buildSecaoTitulo(String text) {
    return Text(text, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700));
  }

  Widget _buildField(
    TextEditingController controller, {
    String? hintText,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      textCapitalization: textCapitalization,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Campo obrigatório';
        }
        return null;
      },
    );
  }

  Widget _buildCulturasBox(ThemeData theme) {
    final Color border = theme.colorScheme.outlineVariant.withValues(alpha: 0.6);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        border: Border.all(color: border, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(16),
      ),
      child: _culturas.isEmpty
          ? Text(
              'Nenhuma cultura adicionada',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            )
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _culturas
                  .map(
                    (c) => Chip(
                      label: Text(c.cultura),
                      onDeleted: () {
                        setState(() => _culturas.remove(c));
                      },
                      deleteIcon: const Icon(Icons.close),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                  )
                  .toList(),
            ),
    );
  }

  Future<void> _onAdicionarCultura() async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController projetoController = TextEditingController();
    final TextEditingController loteController = TextEditingController();
    final TextEditingController tamanhoController = TextEditingController();
    String? culturaSelecionada;

    final CulturaItem? result = await showDialog<CulturaItem>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Adicionar cultura'),
              content: SizedBox(
                width: double.maxFinite,
                child: Form(
                  key: formKey,
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
                          controller: projetoController,
                          autofocus: true,
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
                          controller: loteController,
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
                          controller: tamanhoController,
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
                          initialValue: culturaSelecionada,
                          decoration: const InputDecoration(
                            hintText: 'Selecione a cultura',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                          items: _opcoesCulturas.map((cultura) {
                            return DropdownMenuItem<String>(value: cultura, child: Text(cultura));
                          }).toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              culturaSelecionada = value;
                            });
                          },
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
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      final double tamanho = double.parse(tamanhoController.text.trim());
                      Navigator.of(context).pop(
                        CulturaItem(
                          projeto: projetoController.text.trim(),
                          lote: loteController.text.trim(),
                          tamanhoHectare: tamanho,
                          cultura: 'Nilo Coelho da Silva Oliveria - Lote 35 - Feijão de Corda',
                        ),
                      );
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryTealDark,
                    foregroundColor: AppColors.white,
                  ),
                  child: const Text('Adicionar'),
                ),
              ],
            );
          },
        );
      },
    );
    if (result != null) {
      setState(() => _culturas.add(result));
    }
  }

  void _onSalvar() {
    // Valida todos os campos do formulário e se existe ao menos uma cultura
    final bool allValid = _formKey.currentState?.validate() ?? false;
    if (!allValid || _culturas.isEmpty) {
      final String message = !allValid ? 'Preencha todos os campos obrigatórios' : 'Adicione pelo menos uma cultura';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      return;
    }

    // Aqui entraria a persistência dos dados (serviço/repositorio)
    // Por ora, apenas confirma visualmente
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cliente salvo com sucesso!')));
    Navigator.of(context).maybePop();
  }
}
