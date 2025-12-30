import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:farmtracker/views/viewmodels/cliente/cliente_viewmodel.dart';
import 'package:farmtracker/views/viewmodels/projeto/projeto_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProjetoPage extends StatefulWidget {
  const ProjetoPage({super.key});

  @override
  State<ProjetoPage> createState() => _ProjetoPageState();
}

class _ProjetoPageState extends State<ProjetoPage> {
  final ProjetoViewmodel projetoViewmodel = Modular.get<ProjetoViewmodel>();
  final ClienteViewmodel clienteViewmodel = Modular.get<ClienteViewmodel>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();

  String? _uuidSelecionado;

  @override
  void initState() {
    super.initState();
    //_carregarProjetos();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Projetos'), centerTitle: false),
      body: ListenableBuilder(
        listenable: projetoViewmodel,
        builder: (context, _) {
          final projetos = projetoViewmodel.data.projetos ?? [];
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nome do Projeto', style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                _buildField(controller: _nomeController, hintText: 'ex.: Plantio de Milho Q3'),
                const SizedBox(height: 16),
                Text('Descrição', style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                _buildField(
                  controller: _descricaoController,
                  hintText: 'Adicione uma breve descrição para o seu projeto',
                  maxLines: 4,
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
                      // Navegação solicitada: abrir a tela de Lote de forma estática
                      Modular.to.pushNamed('/lote');
                    },
                    child: Text(
                      _uuidSelecionado != null ? 'Salvar Alterações' : 'Adicionar Projeto',
                      style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Text('Meus Projetos', style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                if (projetos.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Center(
                      child: Text(
                        'Adicione o primeiro projeto',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    itemCount: projetos.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final projeto = projetos[index];
                      return Material(
                        color: theme.colorScheme.surface,
                        elevation: 0,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            projetoViewmodel.data.projeto = projeto;
                            clienteViewmodel.data.projeto = projeto.nome;
                            clienteViewmodel.changeState(ProjectoStateFlow.lote);
                          },
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
                                Text(
                                  projeto.nome,
                                  style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  projeto.descricao,
                                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: AppColors.primaryTealDark),
                                      tooltip: 'Editar',
                                      onPressed: () {
                                        if (projeto.uuid.isEmpty) return;
                                        _uuidSelecionado = projeto.uuid;
                                        _nomeController.text = projeto.nome;
                                        _descricaoController.text = projeto.descricao;
                                        setState(() {});
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: AppColors.error),
                                      tooltip: 'Excluir',
                                      onPressed: () {
                                        _uuidSelecionado = null;
                                        projetoViewmodel.removerItem(index);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildField({required TextEditingController controller, String? hintText, int maxLines = 1}) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
