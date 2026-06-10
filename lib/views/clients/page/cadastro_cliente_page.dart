import 'package:farmtracker/views/clients/models/cultura_item.dart';
import 'package:farmtracker/views/clients/widgets/adicionar_cultura_dialog.dart';
import 'package:farmtracker/views/clients/widgets/culturas_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  final List<CulturaItem> _culturas = <CulturaItem>[];

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
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Cliente'), centerTitle: false),
      floatingActionButton: FloatingActionButton(onPressed: _onSalvar, child: const Icon(Icons.save_outlined)),
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
                          _buildField(_ruaController, hintText: 'Rua', validate: false),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitulo('Número'),
                          _buildField(
                            _numeroController,
                            hintText: 'Nº',
                            keyboardType: TextInputType.number,
                            validate: false,
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
                          _buildTitulo('Bairro'),
                          _buildField(_bairroController, hintText: 'Bairro', validate: false),
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
                            validate: false,
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
                          _buildField(_cidadeController, hintText: 'Cidade', validate: false),
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
                            validate: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTitulo('Complemento'),
                _buildField(_complementoController, hintText: 'Complemento', validate: false),
                const SizedBox(height: 12),
                _buildTitulo('Referência'),
                _buildField(_referenciaController, hintText: 'Ponto de referência', validate: false),
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
                CulturasBox(
                  culturas: _culturas,
                  onRemover: (cultura) => setState(() => _culturas.remove(cultura)),
                  onEditar: _onEditarCultura,
                ),
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
    bool validate = true,
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
        if (validate && (value == null || value.trim().isEmpty)) {
          return 'Campo obrigatório';
        }
        return null;
      },
    );
  }

  Future<void> _onAdicionarCultura() async {
    final CulturaItem? result = await showAdicionarCulturaDialog(context);
    if (result != null) {
      setState(() => _culturas.add(result));
    }
  }

  Future<void> _onEditarCultura(CulturaItem cultura) async {
    final int index = _culturas.indexOf(cultura);
    if (index == -1) return;

    final CulturaItem? result = await showAdicionarCulturaDialog(
      context,
      culturaInicial: cultura,
    );

    if (result != null) {
      setState(() => _culturas[index] = result);
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
