import 'package:farmtracker/views/clients/models/cultura_item.dart';
import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_spacing.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:farmtracker/views/cubits/appointment/appointment_cubit.dart';
import 'package:farmtracker/views/cubits/customer/customer_cubit.dart';
import 'package:farmtracker/views/cubits/customer/customer_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const List<Color> _coresLote = [
  Color(0xFFC8E6C9),
  Color(0xFFFFE082),
  Color(0xFFE1BEE7),
  Color(0xFFBBDEFB),
  Color(0xFFFFCCBC),
];

class PestLotCropInfo {
  final String pest;
  final String projeto;
  final String lot;
  final String crop;
  final double hectares;

  PestLotCropInfo({
    required this.pest,
    required this.projeto,
    required this.lot,
    required this.crop,
    required this.hectares,
  });
}

Future<PestLotCropInfo?> showPestDialog(
  BuildContext context, {
  required String customerName,
  required List<String> pests,
}) {
  return showDialog<PestLotCropInfo>(
    context: context,
    builder: (_) => PestDialog(customerName: customerName, pests: pests),
  );
}

class PestDialog extends StatefulWidget {
  final String customerName;
  final List<String> pests;

  const PestDialog({super.key, required this.customerName, required this.pests});

  @override
  State<PestDialog> createState() => _PestDialogState();
}

class _PestDialogState extends State<PestDialog> {
  String? _selectedPest;
  CulturaItem? _selectedCultura;
  List<CulturaItem> _culturas = <CulturaItem>[];
  bool _isLoadingCulturas = true;
  final TextEditingController _hectareController = TextEditingController();

  @override
  void dispose() {
    _hectareController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _carregarCulturasDoCliente());
  }

  Future<void> _carregarCulturasDoCliente() async {
    final String? customerId = context.read<AppointmentCubit>().appointmentEmExecucao?.customer;
    if (customerId == null) {
      if (mounted) setState(() => _isLoadingCulturas = false);
      return;
    }

    final CustomerCubit customerCubit = context.read<CustomerCubit>();
    List<CulturaItem> culturas = _culturasDoEstado(customerCubit.state, customerId);

    if (culturas.isEmpty) {
      await customerCubit.obterPorId(customerId);
      if (!mounted) return;
      culturas = _culturasDoEstado(customerCubit.state, customerId);
    }

    final CulturaItem? culturaAgendada = CulturaItem.fromSerialized(
      context.read<AppointmentCubit>().appointmentEmExecucao?.project ?? '',
    );

    setState(() {
      _culturas = culturas;
      _selectedCultura = _resolverCulturaInicial(culturaAgendada, culturas);
      _isLoadingCulturas = false;
    });
  }

  List<CulturaItem> _culturasDoEstado(CustomerState state, String customerId) {
    if (state is CustomerListLoaded) {
      for (final customer in state.customers) {
        if (customer.id == customerId) {
          return CulturaItem.listFromProjetoCampo(customer.projeto);
        }
      }
    }

    if (state is CustomerLoaded && state.customer.id == customerId) {
      return CulturaItem.listFromProjetoCampo(state.customer.projeto);
    }

    return <CulturaItem>[];
  }

  CulturaItem? _resolverCulturaInicial(CulturaItem? culturaAgendada, List<CulturaItem> culturas) {
    if (culturaAgendada != null) {
      for (final CulturaItem cultura in culturas) {
        if (cultura.toSerialized() == culturaAgendada.toSerialized()) return cultura;
      }
      return culturaAgendada;
    }

    if (culturas.length == 1) return culturas.first;
    return null;
  }

  void _adicionarPraga() {
    if (_selectedPest == null || _selectedCultura == null || _hectareController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    final double hectares = double.tryParse(_hectareController.text.replaceAll(',', '.')) ?? 0;
    if (hectares <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um valor válido para hectares')),
      );
      return;
    }

    Navigator.of(context).pop(
      PestLotCropInfo(
        pest: _selectedPest!,
        projeto: _selectedCultura!.projeto,
        lot: _selectedCultura!.lote,
        crop: _selectedCultura!.cultura,
        hectares: hectares,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 640),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.s4 + AppSpacing.s2),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSpacing.radiusXl),
                  topRight: Radius.circular(AppSpacing.radiusXl),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.customerName,
                      style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold, color: scheme.onSurface),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_culturas.length} ${_culturas.length == 1 ? 'Projeto' : 'Projetos'}',
                      style: AppTextStyles.labelMedium.copyWith(color: scheme.primary, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                color: scheme.surfaceContainerLow,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.s4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFieldLabel('Praga identificada'),
                      const SizedBox(height: AppSpacing.s2),
                      _buildPestDropdown(scheme),
                      const SizedBox(height: AppSpacing.s4),
                      _buildFieldLabel('Projeto do cliente'),
                      const SizedBox(height: AppSpacing.s2),
                      _buildProjetosSection(scheme),
                      const SizedBox(height: AppSpacing.s4),
                      _buildFieldLabel('Hectares'),
                      const SizedBox(height: AppSpacing.s2),
                      TextField(
                        controller: _hectareController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        style: AppTextStyles.bodyLarge,
                        decoration: InputDecoration(
                          hintText: '0.0',
                          filled: true,
                          fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
                          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppSpacing.s4),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppSpacing.radiusXl),
                  bottomRight: Radius.circular(AppSpacing.radiusXl),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Cancelar', style: AppTextStyles.labelLarge.copyWith(color: scheme.onSurfaceVariant)),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s2),
                  Expanded(
                    child: FilledButton(
                      onPressed: _adicionarPraga,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Adicionar', style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjetosSection(ColorScheme scheme) {
    if (_isLoadingCulturas) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.s6),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_culturas.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s4),
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: scheme.onSurfaceVariant),
            const SizedBox(height: AppSpacing.s2),
            Text(
              'Nenhum projeto encontrado para o cliente',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return Column(
      children: _culturas.asMap().entries.map((entry) {
        final int index = entry.key;
        final CulturaItem cultura = entry.value;
        final bool isSelected = _selectedCultura?.toSerialized() == cultura.toSerialized();

        return Padding(
          padding: EdgeInsets.only(bottom: index < _culturas.length - 1 ? AppSpacing.s4 : 0),
          child: _ProjetoCard(
            cultura: cultura,
            corLote: _coresLote[index % _coresLote.length],
            isSelected: isSelected,
            onTap: () => setState(() => _selectedCultura = cultura),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPestDropdown(ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedPest,
          isExpanded: true,
          hint: Text('Selecione uma praga', style: AppTextStyles.bodyLarge.copyWith(color: scheme.onSurfaceVariant)),
          icon: Icon(Icons.arrow_drop_down, color: scheme.onSurfaceVariant),
          style: AppTextStyles.bodyLarge,
          dropdownColor: scheme.surface,
          onChanged: (String? value) => setState(() => _selectedPest = value),
          items: widget.pests.map<DropdownMenuItem<String>>((String pest) {
            return DropdownMenuItem<String>(value: pest, child: Text(pest));
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(label, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w600));
  }
}

class _ProjetoCard extends StatelessWidget {
  final CulturaItem cultura;
  final Color corLote;
  final bool isSelected;
  final VoidCallback onTap;

  const _ProjetoCard({
    required this.cultura,
    required this.corLote,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.transparent,
          width: isSelected ? 2 : 0,
        ),
      ),
      color: isSelected ? AppColors.primaryContainer.withValues(alpha: 0.2) : scheme.surfaceContainer,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _valorSemLegenda(cultura.projeto, 'P:'),
                style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w600, color: scheme.onSurface),
              ),
              const SizedBox(height: AppSpacing.s2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Cultura: ${_valorSemLegenda(cultura.cultura, 'C:')}',
                      style: AppTextStyles.bodySmall.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: corLote, borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      'Lote: ${_valorSemLegenda(cultura.lote, 'L:')}',
                      style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w600, color: scheme.onSurface),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _valorSemLegenda(String valor, String legenda) {
    final String texto = valor.trim();
    if (texto.startsWith(legenda)) {
      return texto.substring(legenda.length).trim();
    }
    return texto;
  }
}
