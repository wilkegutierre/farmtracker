import 'package:farmtracker/databases/models/response/address_response_model.dart';
import 'package:farmtracker/databases/models/response/customer_response_model.dart';
import 'package:farmtracker/views/clients/models/cultura_item.dart';
import 'package:farmtracker/views/clients/widgets/adicionar_cultura_dialog.dart';
import 'package:farmtracker/views/clients/widgets/culturas_box.dart';
import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_spacing.dart';
import 'package:farmtracker/views/cubits/address/address_cubit.dart';
import 'package:farmtracker/views/cubits/address/address_state.dart';
import 'package:farmtracker/views/cubits/customer/customer_cubit.dart';
import 'package:farmtracker/views/cubits/customer/customer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerPage extends StatefulWidget {
  final String customerId;

  const CustomerPage({super.key, required this.customerId});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final TextEditingController _proprietarioController = TextEditingController();
  final TextEditingController _responsavelTecnicoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonePrincipalController = TextEditingController();
  final TextEditingController _telefoneSecundarioController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _ufController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _referenciaController = TextEditingController();

  CustomerResponseModel? _customer;
  AddressResponseModel? _address;
  final List<CulturaItem> _culturas = <CulturaItem>[];

  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  String _appBarTitle = 'Cliente';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _carregarDados());
  }

  @override
  void dispose() {
    _proprietarioController.dispose();
    _responsavelTecnicoController.dispose();
    _emailController.dispose();
    _telefonePrincipalController.dispose();
    _telefoneSecundarioController.dispose();
    _ruaController.dispose();
    _numeroController.dispose();
    _bairroController.dispose();
    _cepController.dispose();
    _cidadeController.dispose();
    _ufController.dispose();
    _complementoController.dispose();
    _referenciaController.dispose();
    super.dispose();
  }

  Future<void> _carregarDados() async {
    setState(() {
      _isLoading = true;
      _isSaving = false;
      _errorMessage = null;
      _appBarTitle = 'Cliente';
      _customer = null;
      _address = null;
      _culturas.clear();
    });
    _limparCampos();

    final CustomerCubit customerCubit = context.read<CustomerCubit>();
    await customerCubit.obterPorId(widget.customerId);

    if (!mounted) return;

    final CustomerState customerState = customerCubit.state;
    if (customerState is CustomerErro) {
      setState(() {
        _isLoading = false;
        _errorMessage = customerState.mensagem;
      });
      return;
    }

    if (customerState is! CustomerLoaded) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Cliente não encontrado.';
      });
      return;
    }

    final CustomerResponseModel customer = customerState.customer;
    AddressResponseModel? address;

    final String? addressId = customer.address?.trim();
    if (addressId != null && addressId.isNotEmpty) {
      final AddressCubit addressCubit = context.read<AddressCubit>();
      await addressCubit.obterPorId(addressId);

      if (!mounted) return;

      final AddressState addressState = addressCubit.state;
      if (addressState is AddressLoaded) {
        address = addressState.address;
      }
    }

    _preencherCampos(customer, address);

    setState(() {
      _customer = customer;
      _address = address;
      _appBarTitle = _nomeDoCustomer(customer);
      _isLoading = false;
    });
  }

  void _limparCampos() {
    _proprietarioController.clear();
    _responsavelTecnicoController.clear();
    _emailController.clear();
    _telefonePrincipalController.clear();
    _telefoneSecundarioController.clear();
    _ruaController.clear();
    _numeroController.clear();
    _bairroController.clear();
    _cepController.clear();
    _cidadeController.clear();
    _ufController.clear();
    _complementoController.clear();
    _referenciaController.clear();
  }

  void _preencherCampos(CustomerResponseModel customer, AddressResponseModel? address) {
    _proprietarioController.text = customer.proprietario?.trim() ?? '';
    _responsavelTecnicoController.text = customer.responsavelTecnico?.trim() ?? '';
    _emailController.text = customer.email?.trim() ?? '';
    _culturas.addAll(CulturaItem.listFromProjetoCampo(customer.projeto));
    _telefonePrincipalController.text = customer.primaryPhone?.trim() ?? '';
    _telefoneSecundarioController.text = customer.secondaryPhone?.trim() ?? '';

    if (address != null) {
      _ruaController.text = address.street?.trim() ?? '';
      _numeroController.text = address.number?.trim() ?? '';
      _bairroController.text = address.district?.trim() ?? '';
      _cepController.text = address.zipCode?.trim() ?? '';
      _cidadeController.text = address.city?.trim() ?? '';
      _ufController.text = (address.uf ?? address.state)?.trim() ?? '';
      _complementoController.text = address.complement?.trim() ?? '';
      _referenciaController.text = address.reference?.trim() ?? '';
      return;
    }

    final bool possuiAddressId = customer.address?.trim().isNotEmpty == true;
    if (possuiAddressId) {
      _referenciaController.text = 'Endereço não encontrado';
    }
  }

  String _nomeDoCustomer(CustomerResponseModel customer) {
    final String? proprietario = customer.proprietario?.trim();
    if (proprietario != null && proprietario.isNotEmpty) return proprietario;
    return 'Cliente sem nome';
  }

  String? _textoOuNulo(TextEditingController controller) {
    final String texto = controller.text.trim();
    return texto.isEmpty ? null : texto;
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

  Future<void> _onSalvar() async {
    if (_customer == null || _isSaving) return;

    if (_culturas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Adicione pelo menos uma cultura')));
      return;
    }

    setState(() => _isSaving = true);

    final CustomerResponseModel customerAtualizado = _customer!.copyWith(
      proprietario: _textoOuNulo(_proprietarioController),
      responsavelTecnico: _textoOuNulo(_responsavelTecnicoController),
      projeto: CulturaItem.serializarLista(_culturas),
      email: _textoOuNulo(_emailController),
      primaryPhone: _textoOuNulo(_telefonePrincipalController),
      secondaryPhone: _textoOuNulo(_telefoneSecundarioController),
    );

    final CustomerCubit customerCubit = context.read<CustomerCubit>();
    await customerCubit.alterar(customerAtualizado);

    if (!mounted) return;

    final CustomerState customerState = customerCubit.state;
    if (customerState is CustomerErro) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(customerState.mensagem)));
      return;
    }

    AddressResponseModel? addressAtualizado = _address;

    if (_address != null) {
      addressAtualizado = _address!.copyWith(
        street: _textoOuNulo(_ruaController),
        number: _textoOuNulo(_numeroController),
        district: _textoOuNulo(_bairroController),
        zipCode: _textoOuNulo(_cepController),
        city: _textoOuNulo(_cidadeController),
        uf: _textoOuNulo(_ufController),
        state: _textoOuNulo(_ufController),
        complement: _textoOuNulo(_complementoController),
        reference: _textoOuNulo(_referenciaController),
      );

      final AddressCubit addressCubit = context.read<AddressCubit>();
      await addressCubit.alterar(addressAtualizado);

      if (!mounted) return;

      final AddressState addressState = addressCubit.state;
      if (addressState is AddressErro) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(addressState.mensagem)));
        return;
      }
    }

    setState(() {
      _customer = customerAtualizado;
      _address = addressAtualizado;
      _appBarTitle = _nomeDoCustomer(customerAtualizado);
      _isSaving = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cliente salvo com sucesso!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_appBarTitle), centerTitle: false),
      floatingActionButton: _exibirFab ? _buildFab() : null,
      body: SafeArea(child: _buildBody()),
    );
  }

  bool get _exibirFab => !_isLoading && _errorMessage == null && _customer != null;

  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: _isSaving ? null : _onSalvar,
      child: _isSaving
          ? SizedBox(
              width: AppSpacing.s6,
              height: AppSpacing.s6,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
            )
          : const Icon(Icons.save_outlined),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return _buildEstadoErro();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSecaoTitulo('Dados do cliente'),
          const SizedBox(height: AppSpacing.s2),
          _buildCampo('Proprietário', _proprietarioController, hintText: 'Nome do proprietário'),
          const SizedBox(height: AppSpacing.s4),
          _buildCampo('Responsável técnico', _responsavelTecnicoController, hintText: 'Nome do responsável técnico'),
          const SizedBox(height: AppSpacing.s4),
          _buildCampoProjeto(),
          const SizedBox(height: AppSpacing.s6),
          _buildSecaoTitulo('Contato'),
          const SizedBox(height: AppSpacing.s2),
          _buildCampo(
            'E-mail',
            _emailController,
            hintText: 'E-mail de contato',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: AppSpacing.s4),
          _buildCampo(
            'Telefone principal',
            _telefonePrincipalController,
            hintText: 'Telefone principal',
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9()\-\s]+'))],
          ),
          const SizedBox(height: AppSpacing.s4),
          _buildCampo(
            'Telefone secundário',
            _telefoneSecundarioController,
            hintText: 'Telefone secundário',
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9()\-\s]+'))],
          ),
          const SizedBox(height: AppSpacing.s6),
          _buildSecaoTitulo('Endereço'),
          const SizedBox(height: AppSpacing.s2),
          Row(
            children: [
              Expanded(flex: 3, child: _buildCampo('Rua', _ruaController, hintText: 'Rua')),
              const SizedBox(width: AppSpacing.s4),
              Expanded(
                child: _buildCampo('Número', _numeroController, hintText: 'Nº', keyboardType: TextInputType.number),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s4),
          Row(
            children: [
              Expanded(child: _buildCampo('Bairro', _bairroController, hintText: 'Bairro')),
              const SizedBox(width: AppSpacing.s4),
              Expanded(
                child: _buildCampo(
                  'CEP',
                  _cepController,
                  hintText: '00000-000',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s4),
          Row(
            children: [
              Expanded(child: _buildCampo('Cidade', _cidadeController, hintText: 'Cidade')),
              const SizedBox(width: AppSpacing.s4),
              SizedBox(
                width: 100,
                child: _buildCampo(
                  'UF',
                  _ufController,
                  hintText: 'UF',
                  textCapitalization: TextCapitalization.characters,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s4),
          _buildCampo('Complemento', _complementoController, hintText: 'Complemento'),
          const SizedBox(height: AppSpacing.s4),
          _buildCampo('Referência', _referenciaController, hintText: 'Ponto de referência'),
          const SizedBox(height: 84),
        ],
      ),
    );
  }

  Widget _buildEstadoErro() {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: AppSpacing.s4),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.s6),
            FilledButton(onPressed: _carregarDados, child: const Text('Tentar novamente')),
          ],
        ),
      ),
    );
  }

  Widget _buildCampoProjeto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitulo('Projeto'),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: CulturasBox(
                culturas: _culturas,
                onRemover: (cultura) => setState(() => _culturas.remove(cultura)),
                onEditar: _onEditarCultura,
              ),
            ),
            IconButton(onPressed: _onAdicionarCultura, icon: const Icon(Icons.add), tooltip: 'Adicionar cultura'),
          ],
        ),
      ],
    );
  }

  Widget _buildCampo(
    String label,
    TextEditingController controller, {
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitulo(label),
        _buildField(
          controller,
          hintText: hintText,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
        ),
      ],
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
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final ThemeData theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(hintText: hintText),
    );
  }
}
