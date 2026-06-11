import 'package:farmtracker/databases/models/response/customer_response_model.dart';
import 'package:farmtracker/views/appointment/widgets/customer_culturas_dialog.dart';
import 'package:farmtracker/views/clients/models/cultura_item.dart';
import 'package:farmtracker/views/core/style/app_spacing.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:farmtracker/views/cubits/customer/customer_cubit.dart';
import 'package:farmtracker/views/cubits/customer/customer_state.dart';
import 'package:farmtracker/views/widgets/custom_card_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CustomerAppointmentPage extends StatefulWidget {
  const CustomerAppointmentPage({super.key});

  @override
  State<CustomerAppointmentPage> createState() => _CustomerAppointmentPageState();
}

class _CustomerAppointmentPageState extends State<CustomerAppointmentPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerCubit>().carregarCustomers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await context.read<CustomerCubit>().carregarCustomers();
  }

  List<CustomerResponseModel> _filtrarPorNome(List<CustomerResponseModel> customers) {
    if (_query.trim().isEmpty) return customers;

    final String queryNormalizada = _query.trim().toLowerCase();
    return customers.where((customer) {
      final String nome = _nomeDoCustomer(customer).toLowerCase();
      return nome.contains(queryNormalizada);
    }).toList();
  }

  String _nomeDoCustomer(CustomerResponseModel customer) {
    final String? proprietario = customer.proprietario?.trim();
    if (proprietario != null && proprietario.isNotEmpty) return proprietario;
    return 'Cliente sem nome';
  }

  String _formatarProjeto(CustomerResponseModel customer) {
    final List<CulturaItem> culturas = CulturaItem.listFromProjetoCampo(customer.projeto);
    if (culturas.isEmpty) return '—';

    if (culturas.length == 1) {
      return culturas.first.projeto;
    }

    return culturas.map((cultura) => cultura.projeto).join(', ');
  }

  List<CulturaItem> _culturasDoCustomer(CustomerResponseModel customer) {
    return CulturaItem.listFromProjetoCampo(customer.projeto);
  }

  Future<void> _selecionarCustomer(CustomerResponseModel customer) async {
    final List<CulturaItem> culturas = _culturasDoCustomer(customer);
    final CulturaItem? culturaSelecionada = await showCustomerCulturasDialog(
      context,
      customerName: _nomeDoCustomer(customer),
      culturas: culturas,
    );

    if (culturaSelecionada == null || !mounted) return;

    context.push('/appointment', extra: {
      'clientName': _nomeDoCustomer(customer),
      'customerId': customer.id,
      'farmName': culturaSelecionada.projeto,
      'projectTitle': culturaSelecionada.projeto,
      'projectBatch': culturaSelecionada.lote,
      'projectArea': culturaSelecionada.tamanhoHectare,
      'project': culturaSelecionada.toSerialized(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cliente'),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s4),
          child: Column(
            children: [
              _buildSearchField(colorScheme),
              const SizedBox(height: AppSpacing.s2 + AppSpacing.s2),
              Expanded(
                child: BlocConsumer<CustomerCubit, CustomerState>(
                  listenWhen: (_, current) => current is CustomerErro,
                  listener: (context, state) {
                    if (state is CustomerErro) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.mensagem)),
                      );
                    }
                  },
                  buildWhen: (previous, current) =>
                      current is CustomerListLoaded ||
                      current is CustomerErro ||
                      (current is CustomerLoading && previous is! CustomerListLoaded),
                  builder: (context, state) {
                    if (state is CustomerLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is CustomerErro) {
                      return _buildEstadoVazio(
                        colorScheme: colorScheme,
                        mensagem: state.mensagem,
                        icone: Icons.error_outline,
                      );
                    }

                    if (state is! CustomerListLoaded) {
                      return const SizedBox.shrink();
                    }

                    final List<CustomerResponseModel> filtrados = _filtrarPorNome(state.customers);

                    return RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: filtrados.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(
                                  height: MediaQuery.sizeOf(context).height * 0.35,
                                  child: _buildEstadoVazio(
                                    colorScheme: colorScheme,
                                    mensagem: _query.trim().isEmpty
                                        ? 'Nenhum cliente cadastrado'
                                        : 'Nenhum cliente encontrado',
                                    icone: Icons.people_outline,
                                  ),
                                ),
                              ],
                            )
                          : ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: filtrados.length,
                              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.s6),
                              itemBuilder: (context, index) {
                                final CustomerResponseModel customer = filtrados[index];
                                return CustomCardClient(
                                  clientName: _nomeDoCustomer(customer),
                                  project: _formatarProjeto(customer),
                                  onTap: () => _selecionarCustomer(customer),
                                );
                              },
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(ColorScheme colorScheme) {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _query = value),
      decoration: InputDecoration(
        hintText: 'Buscar clientes por nome...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          borderSide: BorderSide.none,
        ),
      ),
      textInputAction: TextInputAction.search,
    );
  }

  Widget _buildEstadoVazio({
    required ColorScheme colorScheme,
    required String mensagem,
    required IconData icone,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icone, size: 64, color: colorScheme.onSurfaceVariant),
          const SizedBox(height: AppSpacing.s4),
          Text(
            mensagem,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
