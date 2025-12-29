import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ClientAppointmentPage extends StatefulWidget {
  const ClientAppointmentPage({super.key});

  @override
  State<ClientAppointmentPage> createState() => _ClientAppointmentPageState();
}

class _ClientAppointmentPageState extends State<ClientAppointmentPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final List<_Client> _clients = const [
    _Client(
      name: 'Maria Garcia',
      address: '456 Harvest Rd, Meadowbrook',
      projects: [
        _Project(
          title: 'Manga rosa',
          batch: '2910',
          area: 45.0,
          batchColor: Color(0xFFC8E6C9), // Light green
        ),
        _Project(
          title: 'Laranja lima',
          batch: '8102',
          area: 120.0,
          batchColor: Color(0xFFC8E6C9), // Light green
        ),
      ],
    ),
    _Client(
      name: 'John Appleseed',
      address: "123 Farmer's Lane, Greenfield",
      projects: [
        _Project(
          title: 'Maracujá',
          batch: '3391',
          area: 80.0,
          batchColor: Color(0xFFFFE082), // Light orange/yellow
        ),
      ],
    ),
    _Client(
      name: 'Samuel Jones',
      address: '789 Orchard Ave, Sunnyside',
      projects: [
        _Project(
          title: 'Malancia',
          batch: '1105',
          area: 12.0,
          batchColor: Color(0xFFE1BEE7), // Light purple
        ),
      ],
    ),
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
                    return _ClientCard(client: client, onTap: () => _showProjectsDialog(context, client));
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
      onChanged: (value) => setState(() {
        _query = value;
      }),
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

  Future<void> _showProjectsDialog(BuildContext context, _Client client) async {
    final project = await showDialog<_Project>(
      context: context,
      builder: (context) => _ProjectsDialog(client: client),
    );

    if (project != null && mounted) {
      // Navega para a tela de agendamento com os dados do cliente e projeto
      Modular.to.pushNamed(
        '/appointment',
        arguments: {
          'clientName': client.name,
          'farmName': client.address,
          'projectTitle': project.title,
          'projectBatch': project.batch,
          'projectArea': project.area,
        },
      );
    }
  }
}

class _Client {
  final String name;
  final String address;
  final List<_Project> projects;
  const _Client({required this.name, required this.address, this.projects = const []});
}

class _Project {
  final String title;
  final String batch;
  final double area;
  final Color batchColor;

  const _Project({required this.title, required this.batch, required this.area, required this.batchColor});
}

class _ClientCard extends StatelessWidget {
  final _Client client;
  final VoidCallback onTap;
  const _ClientCard({required this.client, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        title: Text(client.name, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(client.address, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
        trailing: InkWell(
          onTap: onTap,
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
        onTap: onTap,
      ),
    );
  }
}

class _ProjectsDialog extends StatelessWidget {
  final _Client client;

  const _ProjectsDialog({required this.client});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        decoration: BoxDecoration(color: AppColors.backgroundLight, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          client.name,
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(client.address, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${client.projects.length} Projetos',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primaryTeal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Projects List
            Flexible(
              child: Container(
                color: AppColors.backgroundLight,
                child: client.projects.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.inbox_outlined, size: 64, color: AppColors.textSecondary),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhum projeto encontrado',
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        shrinkWrap: true,
                        itemCount: client.projects.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final project = client.projects[index];
                          return _ProjectCard(project: project);
                        },
                      ),
              ),
            ),
            // Close Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Cancelar', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final _Project project;

  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide.none),
      color: AppColors.cardBackground,
      child: InkWell(
        onTap: () => Navigator.of(context).pop(project),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                project.title,
                style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              // Crop Type
              // Details Row
              Row(
                children: [
                  // Batch Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: project.batchColor, borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      'Lote #${project.batch}',
                      style: AppTextStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Spacer(),
                  // Area
                  Row(
                    children: [
                      Icon(Icons.grid_4x4, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '${project.area.toStringAsFixed(0)} Ha',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right, size: 20, color: AppColors.textSecondary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
