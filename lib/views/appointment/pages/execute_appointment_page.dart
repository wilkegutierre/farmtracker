import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

// Modelo para armazenar informações de praga/lote/cultura
class PestLotCropInfo {
  final String pest;
  final String lot;
  final String crop;
  final double hectares;

  PestLotCropInfo({required this.pest, required this.lot, required this.crop, required this.hectares});

  @override
  String toString() {
    return '$crop - $lot (${hectares.toStringAsFixed(2)}ha)';
  }
}

class ExecuteAppointmentPage extends StatefulWidget {
  final String? clientName;

  const ExecuteAppointmentPage({super.key, this.clientName});

  @override
  State<ExecuteAppointmentPage> createState() => _ExecuteAppointmentPageState();
}

class _ExecuteAppointmentPageState extends State<ExecuteAppointmentPage> {
  bool _appointmentCompleted = false;
  bool _hadPests = false;
  String? _selectedReason;
  String? _selectedSubItem;
  // INSERT_YOUR_CODE
  final List<String> _reasons = ['Monitoramento', 'Tratamento', 'Consulta', 'Inspeção'];
  final List<String> _subItems = ['Larva-alfinete', 'Pulgões', 'Doença Fúngica', 'Plantas Daninhas'];
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

  final List<String> _lots = ['Lote A', 'Lote B', 'Lote C', 'Lote D', 'Lote E'];
  final List<String> _crops = ['Manga', 'Goiaba', 'Laranja', 'Limão', 'Melancia', 'Mamão'];

  // Lista para armazenar as informações adicionadas
  final List<PestLotCropInfo> _pestLotCropList = [];

  @override
  void dispose() {
    _observationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _selectedReason = _reasons[0];
    _selectedSubItem = _subItems[0];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final clientName = widget.clientName ?? 'John Appleseed';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Modular.to.pop()),
        title: const Text('Completar Visita', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Client name
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(clientName, style: AppTextStyles.headlineSmall.copyWith(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              // White card container
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Appointment Completed
                    _buildLabel('A visita foi realizada?'),
                    const SizedBox(height: 4),
                    Text(
                      'Marque se a visita foi bem-sucedida',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Switch(
                          value: _appointmentCompleted,
                          onChanged: (value) {
                            setState(() {
                              _appointmentCompleted = value;
                            });
                          },
                          activeThumbColor: AppColors.success,
                        ),
                        const SizedBox(width: 12),
                        Visibility(
                          visible: !_appointmentCompleted,
                          child: ElevatedButton(
                            onPressed: () {
                              // Lógica para quando o botão for pressionado
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(const SnackBar(content: Text('Visita não realizada!')));
                              Modular.to.pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade50,
                              foregroundColor: Colors.red.shade700,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Text('Não realizada'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Reason for Appointment
                    _buildLabel('Motivo da Visita'),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      value: _selectedReason!,
                      items: _reasons,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedReason = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    // Sub-item
                    _buildLabel('Sub-item'),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      value: _selectedSubItem!,
                      items: _subItems,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSubItem = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    // Had Pests?
                    _buildLabel('Teve Pragas?'),
                    const SizedBox(height: 4),
                    Text(
                      'Indique se alguma praga foi encontrada',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),
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
                                // Exibir diálogo quando o switch for ativado
                                _showPestDialog();
                              }
                            });
                          },
                          activeThumbColor: AppColors.success,
                        ),
                        if (_hadPests) const SizedBox(width: 12),
                        if (_hadPests)
                          FilledButton.icon(
                            onPressed: _showPestDialog,
                            icon: const Icon(Icons.add),
                            label: const Text('Adicionar Praga/Lote/Cultura'),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primaryTealDark,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                      ],
                    ),
                    // Identified Pests field - only shown when _hadPests is true
                    if (_hadPests) ...[
                      const SizedBox(height: 16),
                      if (_pestLotCropList.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _buildLabel('Culturas e Lotes Adicionados'),
                        const SizedBox(height: 8),
                        _buildPestLotCropBox(),
                      ],
                      const SizedBox(height: 10),
                      _buildLabel('Observação'),
                    ],
                    const SizedBox(height: 8),
                    _buildObservationField(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aqui você pode adicionar a lógica para salvar o agendamento
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Visita completada com sucesso!')));
          Modular.to.pop();
        },
        backgroundColor: AppColors.primaryTealDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: const Icon(Icons.save, color: AppColors.white),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(label, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w600));
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
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
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
          style: const TextStyle(fontSize: 16, color: Colors.black87),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildObservationField() {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return TextField(
      controller: _observationController,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: 'Adicione alguma informação sobre a visita...',
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }

  void _showPestDialog() {
    String? selectedPest;
    String? selectedLot;
    String? selectedCrop;
    final TextEditingController hectareController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Adicionar Praga/Lote/Cultura'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Pragas Identificadas'),
                    const SizedBox(height: 8),
                    _buildDialogDropdown(
                      value: selectedPest,
                      items: _pests,
                      hint: 'Selecione uma praga',
                      onChanged: (String? newValue) {
                        setDialogState(() {
                          selectedPest = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Lotes'),
                    const SizedBox(height: 8),
                    _buildDialogDropdown(
                      value: selectedLot,
                      items: _lots,
                      hint: 'Selecione um lote',
                      onChanged: (String? newValue) {
                        setDialogState(() {
                          selectedLot = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Culturas'),
                              const SizedBox(height: 8),
                              _buildDialogDropdown(
                                value: selectedCrop,
                                items: _crops,
                                hint: 'Selecione',
                                onChanged: (String? newValue) {
                                  setDialogState(() {
                                    selectedCrop = newValue;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Hectares'),
                              const SizedBox(height: 8),
                              TextField(
                                controller: hectareController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: InputDecoration(
                                  hintText: '0.0',
                                  filled: true,
                                  fillColor: Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    hectareController.dispose();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () {
                    if (selectedPest != null &&
                        selectedLot != null &&
                        selectedCrop != null &&
                        hectareController.text.isNotEmpty) {
                      final hectares = double.tryParse(hectareController.text) ?? 0.0;
                      if (hectares > 0) {
                        setState(() {
                          _pestLotCropList.add(
                            PestLotCropInfo(
                              pest: selectedPest!,
                              lot: selectedLot!,
                              crop: selectedCrop!,
                              hectares: hectares,
                            ),
                          );
                        });
                        //hectareController.dispose();
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Por favor, insira um valor válido para hectares')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('Por favor, preencha todos os campos')));
                    }
                  },
                  style: FilledButton.styleFrom(backgroundColor: AppColors.primaryTealDark),
                  child: const Text('Adicionar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDialogDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required ValueChanged<String?> onChanged,
  }) {
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
          value: value,
          isExpanded: true,
          hint: Text(hint, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)),
          icon: Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
          style: AppTextStyles.bodyLarge,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPestLotCropBox() {
    final ThemeData theme = Theme.of(context);
    final Color border = theme.colorScheme.outlineVariant.withValues(alpha: 0.6);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        border: Border.all(color: border, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(16),
      ),
      child: _pestLotCropList.isEmpty
          ? Text(
              'Nenhuma informação adicionada',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            )
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _pestLotCropList
                  .map(
                    (item) => Chip(
                      label: Text('${item.crop} - ${item.pest} - ${item.lot} (${item.hectares.toStringAsFixed(2)}ha)'),
                      onDeleted: () {
                        setState(() => _pestLotCropList.remove(item));
                      },
                      deleteIcon: const Icon(Icons.close),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
