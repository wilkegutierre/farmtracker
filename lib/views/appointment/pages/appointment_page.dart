import 'package:farmtracker/domains/enums/appointment_status_enum.dart';
import 'package:farmtracker/core/session/session_storage.dart';
import 'package:farmtracker/databases/models/response/type_visit_response_model.dart';
import 'package:farmtracker/models/domain/appointment_model.dart';
import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:farmtracker/views/appointment/widgets/retroactive_time_dialog.dart';
import 'package:farmtracker/views/cubits/appointment/appointment_cubit.dart';
import 'package:farmtracker/views/cubits/appointment/appointment_state.dart';
import 'package:farmtracker/views/cubits/type_visit/type_visit_cubit.dart';
import 'package:farmtracker/views/cubits/type_visit/type_visit_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AppointmentPage extends StatefulWidget {
  final String? clientName;
  final String? customerId;
  final String? farmName;
  final String? projectTitle;
  final String? projectBatch;
  final double? projectArea;
  final String? project;
  final String? orgOwner;
  final DateTime? selectedDate;

  const AppointmentPage({
    super.key,
    this.clientName,
    this.customerId,
    this.farmName,
    this.projectTitle,
    this.projectBatch,
    this.projectArea,
    this.project,
    this.orgOwner,
    this.selectedDate,
  });

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final TextEditingController _descriptionController = TextEditingController();
  TimeOfDay? _selectedTime;
  int? _selectedVisitTypeId;
  bool _isSaving = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _carregarTiposVisita());
  }

  Future<void> _carregarTiposVisita() async {
    final TypeVisitCubit typeVisitCubit = context.read<TypeVisitCubit>();
    await typeVisitCubit.carregarTypeVisits();
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: _selectedTime ?? TimeOfDay.now());
    if (picked == null || !mounted) return;

    if (_isHorarioRetroativo(picked)) {
      await showRetroactiveTimeDialog(context);
      return;
    }

    if (picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  bool _isAgendamentoParaHoje() {
    final DateTime dataSelecionada = widget.selectedDate!;
    final DateTime agora = DateTime.now();
    return dataSelecionada.year == agora.year &&
        dataSelecionada.month == agora.month &&
        dataSelecionada.day == agora.day;
  }

  bool _isHorarioRetroativo(TimeOfDay time) {
    if (widget.selectedDate == null || !_isAgendamentoParaHoje()) return false;

    final DateTime agora = DateTime.now();
    final int minutosSelecionados = time.hour * 60 + time.minute;
    final int minutosAtuais = agora.hour * 60 + agora.minute;
    return minutosSelecionados < minutosAtuais;
  }

  String _formatDateLegenda(DateTime date) {
    return DateFormat("EEEE, d 'de' MMMM 'de' y", 'pt_BR').format(date);
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String? _validarFormulario() {
    if (_selectedVisitTypeId == null) {
      return 'Selecione o motivo da visita.';
    }
    if (_selectedTime == null) {
      return 'Selecione o horário da visita.';
    }
    if (widget.selectedDate == null) {
      return 'Data do agendamento não informada. Selecione um dia no calendário.';
    }
    if (widget.customerId == null || widget.customerId!.isEmpty) {
      return 'Cliente não identificado. Selecione um cliente antes de agendar.';
    }
    if (widget.project == null || widget.project!.isEmpty) {
      return 'Projeto não identificado. Selecione um projeto antes de agendar.';
    }
    return null;
  }

  Future<void> _salvarAgendamento() async {
    if (_isSaving) return;

    final String? erroValidacao = _validarFormulario();
    if (erroValidacao != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(erroValidacao)));
      return;
    }

    if (_isHorarioRetroativo(_selectedTime!)) {
      if (!mounted) return;
      await showRetroactiveTimeDialog(context);
      return;
    }

    final String? userId = await SessionStorage.getUserId();
    if (userId == null || userId.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Usuário não autenticado. Faça login novamente.')));
      return;
    }

    final DateTime dataSelecionada = widget.selectedDate!;
    final DateTime dataHora = DateTime(
      dataSelecionada.year,
      dataSelecionada.month,
      dataSelecionada.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final AppointmentModel appointment = AppointmentModel(
      id: const Uuid().v4(),
      user: userId,
      customer: widget.customerId!,
      project: widget.project!,
      datetime: dataHora.toIso8601String(),
      type: _selectedVisitTypeId!,
      todo: _descriptionController.text.trim(),
      status: AppointmentStatusEnum.criado.value,
    );

    if (!mounted) return;

    final AppointmentCubit appointmentCubit = context.read<AppointmentCubit>();

    setState(() => _isSaving = true);
    await appointmentCubit.gravar(appointment);
    if (mounted) {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final clientName = widget.clientName ?? 'Eleanor Pena';
    final farmName = widget.farmName ?? 'Green Valley Farm';
    final projectBatch = widget.projectBatch ?? 'Project Batch';

    return BlocListener<AppointmentCubit, AppointmentState>(
      listener: (context, state) {
        if (state is AppointmentGravadoSucesso) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Visita agendada!')));
          context.go('/home');
        }

        if (state is AppointmentErro) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.mensagem)));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
          title: const Text('Agendar visita', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          elevation: 0,
          backgroundColor: theme.scaffoldBackgroundColor,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(clientName, style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(farmName, style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                Text(
                  'Lote #$projectBatch ',
                  style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 24),
                if (widget.selectedDate != null) ...[_buildDateLegend(theme), const SizedBox(height: 24)],
                _buildLabel('Motivo', obrigatorio: true),
                const SizedBox(height: 8),
                _buildDropdownField(),
                const SizedBox(height: 20),
                _buildLabel('Descrição'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _descriptionController,
                  hintText: 'Informe uma breve descrição...',
                  icon: null,
                  maxLines: 4,
                ),
                const SizedBox(height: 20),
                _buildLabel('Hora', obrigatorio: true),
                const SizedBox(height: 8),
                _buildTimeField(onTap: _selectTime, value: _selectedTime != null ? _formatTime(_selectedTime!) : null),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _isSaving ? null : _salvarAgendamento,
          child: _isSaving
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.save),
        ),
      ),
    );
  }

  Widget _buildLabel(String label, {bool obrigatorio = false}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text.rich(
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
      ),
    );
  }

  Widget _buildDateLegend(ThemeData theme) {
    final ColorScheme colorScheme = theme.colorScheme;
    final String dataFormatada = _formatDateLegenda(widget.selectedDate!);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, size: 22, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Data do agendamento',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  dataFormatada,
                  style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    IconData? icon,
    int maxLines = 1,
  }) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: icon != null ? Icon(icon) : null,
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildTimeField({required VoidCallback onTap, String? value}) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time, size: 20, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value ?? 'Selecione o horário',
                style: AppTextStyles.bodyLarge.copyWith(color: value != null ? null : colorScheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<TypeVisitCubit, TypeVisitState>(
      builder: (context, state) {
        final List<TypeVisitResponseModel> typeVisits = state is TypeVisitListLoaded
            ? state.typeVisits
            : <TypeVisitResponseModel>[];
        final bool hasSelectedType = typeVisits.any((typeVisit) => typeVisit.id == _selectedVisitTypeId);
        final bool isLoading = state is TypeVisitLoading;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(16),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: hasSelectedType ? _selectedVisitTypeId : null,
              isExpanded: true,
              hint: Text(
                isLoading ? 'Carregando tipos de visita...' : 'Selecione o motivo da visita',
                style: AppTextStyles.bodyLarge.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              icon: isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(Icons.arrow_drop_down, color: colorScheme.onSurfaceVariant),
              style: AppTextStyles.bodyLarge,
              dropdownColor: colorScheme.surface,
              onChanged: isLoading || typeVisits.isEmpty
                  ? null
                  : (int? newValue) {
                      setState(() {
                        _selectedVisitTypeId = newValue;
                      });
                    },
              items: typeVisits.map<DropdownMenuItem<int>>((TypeVisitResponseModel typeVisit) {
                return DropdownMenuItem<int>(value: typeVisit.id, child: Text(typeVisit.description));
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
