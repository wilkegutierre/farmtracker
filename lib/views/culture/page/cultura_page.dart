import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CulturaPage extends StatefulWidget {
  const CulturaPage({super.key});

  @override
  State<CulturaPage> createState() => _CulturaPageState();
}

class _CulturaPageState extends State<CulturaPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  final List<_CulturaItem> _culturas = [
    const _CulturaItem(nome: 'Milho', descricao: 'Variedade de alto rendimento, resistente a pragas comuns.'),
    const _CulturaItem(nome: 'Melancia', descricao: 'Variedade sem sementes, requer bastante luz solar e água.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text('Cultura', style: AppTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.w800)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome da Cultura', style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _buildField(controller: _nomeController, hintText: 'ex.: Milho'),
            const SizedBox(height: 16),
            Text('Descrição', style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _buildField(
              controller: _descricaoController,
              hintText: 'Adicione uma breve descrição para a cultura',
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryTealLight,
                  foregroundColor: AppColors.primaryTealDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _adicionarCultura,
                child: Text(
                  'Adicionar Cultura',
                  style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text('Culturas Registradas', style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: _culturas.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = _culturas[index];
                  return _CulturaCard(
                    nome: item.nome,
                    descricao: item.descricao,
                    onEdit: () {
                      _nomeController.text = item.nome;
                      _descricaoController.text = item.descricao;
                      setState(() {});
                    },
                    onDelete: () {
                      setState(() {
                        _culturas.removeAt(index);
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'fab-salvar-cultura',
        backgroundColor: AppColors.primaryTealLight,
        foregroundColor: AppColors.primaryTealDark,
        tooltip: 'Salvar e fechar',
        child: const Icon(Icons.save),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Culturas salvas')));
          Modular.to.popUntil((route) => route.settings.name == '/clienteCadastro');
        },
      ),
    );
  }

  void _adicionarCultura() {
    final String nome = _nomeController.text.trim();
    final String desc = _descricaoController.text.trim();
    if (nome.isEmpty || desc.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Informe o nome e a descrição da cultura')));
      return;
    }
    setState(() {
      _culturas.add(_CulturaItem(nome: nome, descricao: desc));
      _nomeController.clear();
      _descricaoController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cultura adicionada (exemplo estático)')));
  }

  Widget _buildField({required TextEditingController controller, String? hintText, int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

class _CulturaCard extends StatelessWidget {
  final String nome;
  final String descricao;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _CulturaCard({required this.nome, required this.descricao, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      elevation: 0,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(nome, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(descricao, style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.primaryTealDark),
                  tooltip: 'Editar',
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: AppColors.error),
                  tooltip: 'Excluir',
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CulturaItem {
  final String nome;
  final String descricao;
  const _CulturaItem({required this.nome, required this.descricao});
}
