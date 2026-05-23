import 'package:farmtracker/core/session/auth_navigation.dart';
import 'package:farmtracker/databases/mocks/models/agenda_response_model_mock.dart';
import 'package:farmtracker/databases/models/response/agenda_response_model.dart';
import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:farmtracker/views/dashboard/widgets/card_schedule_dashboard_widget.dart';
import 'package:farmtracker/views/viewmodels/cliente/cliente_viewmodel.dart';
import 'package:farmtracker/views/viewmodels/usuario/usuario_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class Appointment {
  final String time;
  final String title;
  final String location;
  //final String imageUrl;

  Appointment({required this.time, required this.title, required this.location});
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime? _selectedDate;
  DateTime _currentMonth = DateTime.now();
  final DateTime _today = DateTime.now();
  final UsuarioViewmodel usuarioViewmodel = Modular.get<UsuarioViewmodel>();
  final ClienteViewmodel _clienteViewmodel = Modular.get<ClienteViewmodel>();
  // Datas com eventos (verde)
  final Set<int> _eventDates = {5, 15, 24, 26};
  // Datas com compromissos atrasados (vermelho)
  final Set<int> _overdueDates = {9};

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  List<AgendaResponseModel> _getAgendaMOck(DateTime? date) {
    if (date == null) return [];
    _getDateKey(date);
    // Converta a data para o começo do dia em milissegundos para comparar
    final dayStart = DateTime(date.year, date.month, date.day).millisecondsSinceEpoch;
    return mockAgendaList.where((agenda) {
      final agendaDate = DateTime.fromMillisecondsSinceEpoch(agenda.dataAgenda);
      final agendaDayStart = DateTime(agendaDate.year, agendaDate.month, agendaDate.day).millisecondsSinceEpoch;
      return agendaDayStart == dayStart;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clienteViewmodel.sincronizarClientesSeNecessario(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard', style: AppTextStyles.headlineMedium),
        centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {})],
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(child: Column(children: [_buildCalendarSection(), _buildAppointmentsSection()])),
      floatingActionButton: FloatingActionButton(onPressed: _handleFloatingActionButton, child: const Icon(Icons.add)),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(gradient: AppColors.primaryCtaGradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'FarmTracker',
                  style: AppTextStyles.headlineMedium.copyWith(color: AppColors.onPrimary, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('Menu', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onPrimary)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: Text('Clientes', style: AppTextStyles.titleMedium),
            onTap: () {
              Navigator.of(context).pop();
              Modular.to.pushNamed('/clienteRelacao');
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Future<void> _handleFloatingActionButton() async {
    final bool sessionValid = await usuarioViewmodel.isSessionValid();
    if (!sessionValid) {
      await redirectToLoginOnSessionExpired();
      return;
    }
    if (!mounted) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primeiro informe um dia no calendário'), duration: Duration(seconds: 2)),
      );
      return;
    }
    Modular.to.pushNamed('/clientAppointment');
  }

  Widget _buildCalendarSection() {
    final monthName = DateFormat('MMMM yyyy', 'pt_BR').format(_currentMonth);
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    // Convert weekday to Sunday=0, Monday=1, ..., Saturday=6
    final firstDayWeekday = firstDayOfMonth.weekday % 7;
    final daysInMonth = lastDayOfMonth.day;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Month navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
                  });
                },
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(monthName, style: AppTextStyles.headlineSmall),
                  if (_isDifferentMonth())
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextButton(
                        onPressed: _navigateToToday,
                        child: Text('Hoje', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.success)),
                      ),
                    ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Days of week header
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _DayLabel('D'),
              _DayLabel('S'),
              _DayLabel('T'),
              _DayLabel('Q'),
              _DayLabel('Q'),
              _DayLabel('S'),
              _DayLabel('S'),
            ],
          ),
          const SizedBox(height: 8),
          // Calendar grid
          ...List.generate((daysInMonth + firstDayWeekday + 6) ~/ 7, (weekIndex) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (dayIndex) {
                final dayNumber = weekIndex * 7 + dayIndex - firstDayWeekday + 1;
                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return const SizedBox(width: 40, height: 40);
                }
                final date = DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
                final isSelected =
                    _selectedDate != null &&
                    date.year == _selectedDate!.year &&
                    date.month == _selectedDate!.month &&
                    date.day == _selectedDate!.day;
                final hasEvent = _eventDates.contains(dayNumber);
                final isOverdue = _overdueDates.contains(dayNumber);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : isOverdue
                          ? AppColors.warning.withValues(alpha: 0.2)
                          : hasEvent
                          ? AppColors.success.withValues(alpha: 0.2)
                          : Colors.transparent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$dayNumber',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                        if ((hasEvent || isOverdue) && !isSelected)
                          Container(
                            width: 4,
                            height: 4,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isOverdue ? AppColors.error : AppColors.success,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  bool _isDifferentMonth() {
    return _currentMonth.year != _today.year || _currentMonth.month != _today.month;
  }

  void _navigateToToday() {
    setState(() {
      _currentMonth = DateTime(_today.year, _today.month, 1);
      _selectedDate = _today;
    });
  }

  Widget _buildAppointmentsSection() {
    if (_selectedDate == null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Agenda(s)', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Selecione um dia no calendário para ver a agenda',
                style: AppTextStyles.bodyMedium.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
      );
    }

    //final monthName = DateFormat('MMM', 'pt_BR').format(_selectedDate!);
    final day = _selectedDate!.day;
    final appointments = _getAgendaMOck(_selectedDate);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Agenda para o dia $day', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 16),
          if (appointments.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Nenhum compromisso agendado para este dia',
                style: AppTextStyles.bodyMedium.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            )
          else
            ...appointments.asMap().entries.map((entry) {
              final index = entry.key;
              final appointment = entry.value;
              return Column(
                children: [
                  if (index > 0) const SizedBox(height: 12),
                  CardScheduleDashboardWidget(
                    onPressedCard: () => Modular.to.pushNamed(
                      '/executeAppointment',
                      arguments: {'clientName': appointment.cliente.nome},
                    ),

                    time: DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(appointment.dataAgenda)),
                    title: appointment.cliente.nome,
                    location: 'Projeto-lote do cliente',
                    status: appointment.situacao,
                  ),
                ],
              );
            }),
        ],
      ),
    );
  }
}

class _DayLabel extends StatelessWidget {
  final String label;

  const _DayLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyMedium.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }
}
