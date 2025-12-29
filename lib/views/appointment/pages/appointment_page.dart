import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class AppointmentPage extends StatefulWidget {
  final String? clientName;
  final String? farmName;
  final String? projectTitle;
  final String? projectBatch;
  final double? projectArea;

  const AppointmentPage({
    super.key,
    this.clientName,
    this.farmName,
    this.projectTitle,
    this.projectBatch,
    this.projectArea,
  });

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedVisitType;

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
    // Define a data inicial como hoje
    _selectedDate = DateTime.now();
    // Define o horário inicial como 10:30 AM
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

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    // Obtém o nome do cliente dos argumentos ou usa um valor padrão
    final clientName = widget.clientName ?? 'Eleanor Pena';
    final farmName = widget.farmName ?? 'Green Valley Farm';
    final projectTitle = widget.projectTitle ?? 'Project Title';
    final projectBatch = widget.projectBatch ?? 'Project Batch';
    final projectArea = widget.projectArea ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Modular.to.pop()),
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
              // Avatar circular
              Text(clientName, style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              // Nome da fazenda
              Text(farmName, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
              Text(projectTitle, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
              Text(
                'Lote #$projectBatch - ${projectArea.toString()} Ha',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),

              const SizedBox(height: 32),
              // Appointment Type
              _buildLabel('Tipo de visita'),
              const SizedBox(height: 8),
              _buildDropdownField(),
              const SizedBox(height: 20),
              // Description
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
              // Time
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
        onPressed: () {
          // Aqui você pode adicionar a lógica para salvar o agendamento
          //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Agendamento salvo com sucesso!')));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Visita agendada!')));
          Modular.to.popUntil((route) => route.settings.name == '/');
        },
        backgroundColor: AppColors.primaryTealDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: const Icon(Icons.save, color: AppColors.white),
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
            Icon(Icons.calendar_today, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value ?? 'Select date',
                style: AppTextStyles.bodyLarge.copyWith(color: value != null ? null : AppColors.textSecondary),
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
            Icon(Icons.access_time, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value ?? 'Select time',
                style: AppTextStyles.bodyLarge.copyWith(color: value != null ? null : AppColors.textSecondary),
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
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
          ),
          icon: Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
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
