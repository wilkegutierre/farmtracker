import 'package:farmtracker/core/session/session_storage.dart';
import 'package:farmtracker/models/domain/appointment_model.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:farmtracker/views/cubits/appointment/appointment_cubit.dart';
import 'package:farmtracker/views/cubits/appointment/appointment_state.dart';
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

  const AppointmentPage({
    super.key,
    this.clientName,
    this.customerId,
    this.farmName,
    this.projectTitle,
    this.projectBatch,
    this.projectArea,
    this.project,
  });

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedVisitType;
  bool _isSaving = false;

  final List<String> _visitTypes = [
    'Monitoramento',
    'Tratamento',
    'Consulta',
    'Inspeção',
    'Análise de Solo',
    'Avaliação de Irrigação',
    'Colheita',
    'Plantio',
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = const TimeOfDay(hour: 10, minute: 30);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('pt', 'BR'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 10, minute: 30),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy', 'pt_BR').format(date);
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String? _validarFormulario() {
    if (_selectedVisitType == null || _selectedVisitType!.isEmpty) {
      return 'Selecione o tipo de visita.';
    }
    if (_selectedDate == null) {
      return 'Selecione a data da visita.';
    }
    if (_selectedTime == null) {
      return 'Selecione o horário da visita.';
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

    final String? userId = await SessionStorage.getUserId();
    if (userId == null || userId.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não autenticado. Faça login novamente.')),
      );
      return;
    }

    final DateTime dataHora = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final AppointmentModel appointment = AppointmentModel(
      id: const Uuid().v4(),
      user: userId,
      customer: widget.customerId!,
      project: widget.project!,
      datetime: dataHora.toIso8601String(),
      type: _selectedVisitType!,
      todo: _descriptionController.text.trim(),
      status: 3,
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Visita agendada!')),
          );
          context.go('/home');
        }

        if (state is AppointmentErro) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.mensagem)),
          );
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
                const SizedBox(height: 32),
                _buildLabel('Tipo de visita'),
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
                _buildLabel('Data'),
                const SizedBox(height: 8),
                _buildDateField(
                  onTap: () => _selectDate(context),
                  value: _selectedDate != null ? _formatDate(_selectedDate!) : null,
                ),
                const SizedBox(height: 20),
                _buildLabel('Hora'),
                const SizedBox(height: 8),
                _buildTimeField(
                  onTap: () => _selectTime(context),
                  value: _selectedTime != null ? _formatTime(_selectedTime!) : null,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _isSaving ? null : _salvarAgendamento,
          child: _isSaving
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(label, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w600)),
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

  Widget _buildDateField({required VoidCallback onTap, String? value}) {
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
            Icon(Icons.calendar_today, size: 20, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value ?? 'Select date',
                style: AppTextStyles.bodyLarge.copyWith(color: value != null ? null : colorScheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
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
                value ?? 'Select time',
                style: AppTextStyles.bodyLarge.copyWith(color: value != null ? null : colorScheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedVisitType,
          isExpanded: true,
          hint: Text(
            'Selecione o tipo de visita',
            style: AppTextStyles.bodyLarge.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          icon: Icon(Icons.arrow_drop_down, color: colorScheme.onSurfaceVariant),
          style: AppTextStyles.bodyLarge,
          dropdownColor: colorScheme.surface,
          onChanged: (String? newValue) {
            setState(() {
              _selectedVisitType = newValue;
            });
          },
          items: _visitTypes.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
        ),
      ),
    );
  }
}
