import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RelacaoClientePage extends StatefulWidget {
  const RelacaoClientePage({super.key});

  @override
  State<RelacaoClientePage> createState() => _RelacaoClientePageState();
}

class _RelacaoClientePageState extends State<RelacaoClientePage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final List<_Client> _clients = const [
    _Client(name: 'Maria Garcia', address: '456 Harvest Rd, Meadowbrook'),
    _Client(name: 'John Appleseed', address: "123 Farmer's Lane, Greenfield"),
    _Client(name: 'Samuel Jones', address: '789 Orchard Ave, Sunnyside'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final List<_Client> filteredClients = _clients
        .where(
          (c) =>
              c.name.toLowerCase().contains(_query.toLowerCase()) ||
              c.address.toLowerCase().contains(_query.toLowerCase()),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        // Título solicitado: "Cliente"
        title: const Text('Cliente'),
        centerTitle: false,
        elevation: 0,
        // Sem actions -> remove o menu de três pontos
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSearchField(colorScheme),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: filteredClients.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final client = filteredClients[index];
                    return _ClientCard(client: client);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Modular.to.pushNamed('/clienteCadastro');
        },
        backgroundColor: AppColors.primaryTealDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  Widget _buildSearchField(ColorScheme colorScheme) {
    return TextField(
      controller: _searchController,
      onChanged: (value) => setState(() {
        _query = value;
      }),
      decoration: InputDecoration(
        hintText: 'Buscar clientes...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.4),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
      textInputAction: TextInputAction.search,
    );
  }
}

class _Client {
  final String name;
  final String address;
  const _Client({required this.name, required this.address});
}

class _ClientCard extends StatelessWidget {
  final _Client client;
  const _ClientCard({required this.client});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          child: Text(client.name.characters.first),
        ),
        title: Text(client.name, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(client.address, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
        trailing: InkWell(
          child: InkWell(
            onTap: () {
              // Navega para a tela de cadastro/edição do cliente
              Modular.to.pushNamed('/clienteCadastro');
            },
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.chevron_right),
            ),
          ),
          //child: const Icon(Icons.chevron_right),
        ),
        onTap: () {
          // Navega para a tela de agendamento
          Modular.to.pushNamed('/clienteCadastro');
        },
      ),
    );
  }
}
