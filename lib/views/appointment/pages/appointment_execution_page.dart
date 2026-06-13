import 'package:farmtracker/domains/enums/appointment_status_enum.dart';
import 'package:farmtracker/models/domain/appointment_model.dart';
import 'package:farmtracker/databases/models/response/type_visit_response_model.dart';
import 'package:farmtracker/views/appointment/widgets/appointment_not_completed_dialog.dart';
import 'package:farmtracker/views/appointment/widgets/pest_dialog.dart';
import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_spacing.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:farmtracker/views/cubits/appointment/appointment_cubit.dart';
import 'package:farmtracker/views/cubits/type_visit/type_visit_cubit.dart';
import 'package:farmtracker/views/cubits/type_visit/type_visit_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppointmentExecutionPage extends StatefulWidget {
  final String? clientName;
  final String? orgOwner;

  const AppointmentExecutionPage({super.key, this.clientName, this.orgOwner});

  @override
  State<AppointmentExecutionPage> createState() => _AppointmentExecutionPageState();
}

class _AppointmentExecutionPageState extends State<AppointmentExecutionPage> {
  bool _appointmentCompleted = true;
  bool _hadPests = false;
  int? _selectedVisitTypeId;

  final List<String> _pests = [
    'Larva-alfinete',
    'Pulgões',
    'Doença Fúngica',
    'Plantas Daninhas',
    'Ácaros',
    'Lagartas',
    'Besouros',
    'Tripes',
  ];

  final TextEditingController _observationController = TextEditingController();

  final List<PestLotCropInfo> _pestLotCropList = [];
  AppointmentCubit? _appointmentCubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appointmentCubit ??= context.read<AppointmentCubit>();
  }

  @override
  void dispose() {
    _appointmentCubit?.limparExecucao();
    _observationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _carregarTiposVisita();
      _aplicarMotivoAgendadoDoCubit();
    });
  }

  void _aplicarMotivoAgendadoDoCubit() {
    final AppointmentModel? appointment = context.read<AppointmentCubit>().appointmentEmExecucao;
    if (appointment == null || !mounted) return;

    setState(() {
      _selectedVisitTypeId ??= appointment.type;
    });
  }

  Future<void> _carregarTiposVisita() async {
    final TypeVisitCubit typeVisitCubit = context.read<TypeVisitCubit>();
    await typeVisitCubit.carregarTypeVisits();
  }

  Future<void> _salvarExecucao() async {
    if (!_appointmentCompleted) {
      final bool confirmou = await showAppointmentNotCompletedDialog(context);
      if (!confirmou || !mounted) return;

      await _gravarComoNaoRealizado();
      return;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Visita completada com sucesso!')));
    context.pop();
  }

  Future<void> _gravarComoNaoRealizado() async {
    final AppointmentModel? appointment = _appointmentCubit?.appointmentEmExecucao;
    if (appointment == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Agendamento não encontrado para gravar.')));
      return;
    }

    final AppointmentModel appointmentAtualizado = appointment.copyWith(status: AppointmentStatusEnum.cancelado.value);

    await _appointmentCubit!.alterar(appointmentAtualizado);

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Agendamento gravado como não realizado.')));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final String clientName = widget.clientName ?? 'Cliente';

    return BlocListener<TypeVisitCubit, TypeVisitState>(
      listenWhen: (_, current) => current is TypeVisitListLoaded || current is TypeVisitErro,
      listener: (context, state) {
        if (state is TypeVisitListLoaded) {
          _aplicarMotivoAgendadoDoCubit();
        }

        if (state is TypeVisitErro) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.mensagem)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
          title: Text('Completar visita', style: AppTextStyles.headlineMedium.copyWith(fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0,
          backgroundColor: theme.scaffoldBackgroundColor,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.s6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(clientName, style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSpacing.s6),
                Card(
                  elevation: 0,
                  color: colorScheme.surfaceContainer,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusXl)),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.s4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(title: 'Realizar visita', subtitle: 'Marque se a visita foi bem-sucedida'),
                        const SizedBox(height: AppSpacing.s2),
                        Row(
                          children: [
                            Switch(
                              value: _appointmentCompleted,
                              onChanged: (value) => setState(() => _appointmentCompleted = value),
                              activeThumbColor: AppColors.success,
                            ),
                            const Spacer(),
                            if (!_appointmentCompleted)
                              Text(
                                'Não realizar',
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.s6),
                        _buildLabel('Motivo efetivo', obrigatorio: true),
                        const SizedBox(height: AppSpacing.s2),
                        _buildMotivoDropdownField(),
                        const SizedBox(height: AppSpacing.s6),
                        _buildSectionHeader(title: 'Teve pragas?', subtitle: 'Indique se alguma praga foi encontrada'),
                        const SizedBox(height: AppSpacing.s2),
                        Row(
                          children: [
                            Switch(
                              value: _hadPests,
                              onChanged: (value) {
                                setState(() {
                                  _hadPests = value;
                                  if (!value) {
                                    _observationController.clear();
                                    _pestLotCropList.clear();
                                  } else {
                                    _showPestDialog();
                                  }
                                });
                              },
                              activeThumbColor: AppColors.success,
                            ),
                            if (_hadPests) ...[
                              const SizedBox(width: AppSpacing.s2),
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: _showPestDialog,
                                  icon: const Icon(Icons.add),
                                  label: const Text('Adicionar praga'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: AppColors.onPrimary,
                                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (_hadPests) ...[
                          if (_pestLotCropList.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.s4),
                            _buildLabel('Culturas e lotes adicionados'),
                            const SizedBox(height: AppSpacing.s2),
                            _buildPestLotCropBox(),
                          ],
                          const SizedBox(height: AppSpacing.s4),
                          _buildLabel('Observação'),
                          const SizedBox(height: AppSpacing.s2),
                          _buildObservationField(),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: _salvarExecucao, child: const Icon(Icons.save)),
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required String subtitle}) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: colorScheme.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildLabel(String label, {bool obrigatorio = false}) {
    return Text.rich(
      TextSpan(
        text: label,
        style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w600),
        children: obrigatorio
            ? [
                TextSpan(
                  text: ' *',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ]
            : null,
      ),
    );
  }

  Widget _buildMotivoDropdownField() {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final int? motivoAgendado = context.read<AppointmentCubit>().appointmentEmExecucao?.type;
    final int? selectedTypeId = _selectedVisitTypeId ?? motivoAgendado;

    return BlocBuilder<TypeVisitCubit, TypeVisitState>(
      builder: (context, state) {
        final List<TypeVisitResponseModel> typeVisits = state is TypeVisitListLoaded
            ? state.typeVisits
            : <TypeVisitResponseModel>[];
        final bool hasSelectedType =
            selectedTypeId != null && typeVisits.any((typeVisit) => typeVisit.id == selectedTypeId);
        final bool isLoading = state is TypeVisitLoading;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: hasSelectedType ? selectedTypeId : null,
              isExpanded: true,
              hint: Text(
                isLoading ? 'Carregando motivos da visita...' : 'Selecione o motivo efetivo',
                style: AppTextStyles.bodyLarge.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              icon: isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(Icons.arrow_drop_down, color: colorScheme.onSurfaceVariant),
              style: AppTextStyles.bodyLarge,
              dropdownColor: colorScheme.surface,
              onChanged: isLoading || typeVisits.isEmpty
                  ? null
                  : (int? newValue) => setState(() => _selectedVisitTypeId = newValue),
              items: typeVisits.map<DropdownMenuItem<int>>((TypeVisitResponseModel typeVisit) {
                return DropdownMenuItem<int>(value: typeVisit.id, child: Text(typeVisit.description));
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildObservationField() {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: _observationController,
      maxLines: 4,
      style: AppTextStyles.bodyLarge,
      decoration: InputDecoration(
        hintText: 'Adicione alguma informação sobre a visita...',
        hintStyle: AppTextStyles.bodyLarge.copyWith(color: colorScheme.onSurfaceVariant),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Future<void> _showPestDialog() async {
    final PestLotCropInfo? info = await showPestDialog(
      context,
      customerName: widget.clientName ?? 'Cliente',
      pests: _pests,
    );

    if (info != null) {
      setState(() => _pestLotCropList.add(info));
    }
  }

  Widget _buildPestLotCropBox() {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Wrap(
        spacing: AppSpacing.s2,
        runSpacing: AppSpacing.s2,
        children: _pestLotCropList
            .map(
              (item) => Chip(
                label: Text(
                  '${item.projeto} - ${item.crop} - ${item.pest} - Lote ${item.lot} (${item.hectares.toStringAsFixed(2)}ha)',
                  style: AppTextStyles.bodySmall,
                ),
                backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.35),
                deleteIcon: Icon(Icons.close, size: 18, color: colorScheme.onSurfaceVariant),
                onDeleted: () => setState(() => _pestLotCropList.remove(item)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusFull)),
              ),
            )
            .toList(),
      ),
    );
  }
}
