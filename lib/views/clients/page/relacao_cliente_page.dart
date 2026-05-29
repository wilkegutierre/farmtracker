import 'package:farmtracker/domains/models/cliente_model.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:farmtracker/views/viewmodels/cliente/cliente_cubit.dart';
import 'package:farmtracker/views/viewmodels/cliente/cliente_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RelacaoClientePage extends StatefulWidget {
  const RelacaoClientePage({super.key});

  @override
  State<RelacaoClientePage> createState() => _RelacaoClientePageState();
}

class _RelacaoClientePageState extends State<RelacaoClientePage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    context.read<ClienteCubit>().obterRelacaoClientes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cliente'),
        centerTitle: false,
        elevation: 0,
        backgroundColor:
            Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSearchField(colorScheme),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<ClienteCubit, ClienteState>(
                  builder: (context, state) {
                    if (state is ClienteLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is ClienteErro) {
                      return Center(
                        child: Text(
                          state.mensagem,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      );
                    }

                    final clientes = state is ClienteRelacaoCarregada ? state.clientes : <ClienteModel>[];
                    final filtrados = clientes
                        .where(
                          (c) =>
                              c.nome.toLowerCase().contains(_query.toLowerCase()) ||
                              (c.enderecos?.any(
                                    (e) =>
                                        e.logradouro.toLowerCase().contains(_query.toLowerCase()) ||
                                        e.cidade.toLowerCase().contains(_query.toLowerCase()),
                                  ) ??
                                  false),
                        )
                        .toList();

                    if (filtrados.isEmpty) {
                      return Center(
                        child: Text(
                          'Nenhum cliente encontrado',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: filtrados.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _ClientCard(cliente: filtrados[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/clienteCadastro'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchField(ColorScheme colorScheme) {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() => _query = value),
      decoration: InputDecoration(
        hintText: 'Buscar clientes...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
      textInputAction: TextInputAction.search,
    );
  }
}

class _ClientCard extends StatelessWidget {
  final ClienteModel cliente;

  const _ClientCard({required this.cliente});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String endereco = cliente.enderecos?.isNotEmpty == true
        ? '${cliente.enderecos!.first.logradouro}, ${cliente.enderecos!.first.cidade}'
        : 'Sem endereço cadastrado';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          child: Text(cliente.nome.characters.first),
        ),
        title: Text(cliente.nome, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(
          endereco,
          style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        trailing: InkWell(
          onTap: () => context.push('/clienteCadastro'),
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.chevron_right),
          ),
        ),
        onTap: () => context.push('/clienteCadastro'),
      ),
    );
  }
}
