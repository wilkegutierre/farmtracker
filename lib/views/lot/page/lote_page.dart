import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LotePage extends StatefulWidget {
  const LotePage({super.key});

  @override
  State<LotePage> createState() => _LotePageState();
}

class _LotePageState extends State<LotePage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  final List<_LoteItem> _lotes = [
    const _LoteItem(title: 'Seção A do Campo Norte', detail: 'Solo rico em argila, adequado para milho.'),
    const _LoteItem(title: 'Talhão Oeste — Melancias', detail: 'Solo arenoso, requer irrigação frequente.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text('Lote', style: AppTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.w800)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome do Lote', style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _buildField(controller: _nomeController, hintText: 'ex.: Seção A do Campo Norte'),
            const SizedBox(height: 16),
            Text('Descrição', style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _buildField(
              controller: _descricaoController,
              hintText: 'Adicione uma breve descrição para o seu lote',
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
                onPressed: () {
                  // Ação estática (sem repositório): adiciona um item na lista local
                  final String nome = _nomeController.text.trim();
                  final String desc = _descricaoController.text.trim();
                  if (nome.isEmpty || desc.isEmpty) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Informe nome e descrição do lote')));
                    return;
                  }
                  setState(() {
                    _lotes.add(_LoteItem(title: nome, detail: desc));
                    _nomeController.clear();
                    _descricaoController.clear();
                  });
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Lote adicionado (exemplo estático)')));
                },
                child: Text('Adicionar Lote', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 28),
            Text('Lotes Registrados', style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: _lotes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = _lotes[index];
                  return _LoteCard(
                    title: item.title,
                    detail: item.detail,
                    onTap: () {
                      Modular.to.pushNamed('/cultura');
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
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

class _LoteCard extends StatelessWidget {
  final String title;
  final String detail;
  final VoidCallback? onTap;

  const _LoteCard({required this.title, required this.detail, this.onTap});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      elevation: 0,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
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
              Text(title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(detail, style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 12),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.primaryTealDark),
                    tooltip: 'Editar',
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: AppColors.error),
                    tooltip: 'Excluir',
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoteItem {
  final String title;
  final String detail;
  const _LoteItem({required this.title, required this.detail});
}
