import 'package:farmtracker/core/session/auth_cubit.dart';
import 'package:farmtracker/core/session/auth_navigation.dart';
import 'package:farmtracker/core/session/session_storage.dart';
import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:farmtracker/databases/models/response/customer_response_model.dart';
import 'package:farmtracker/models/domain/appointment_model.dart';
import 'package:farmtracker/views/clients/models/cultura_item.dart';
import 'package:farmtracker/views/cubits/address/address_cubit.dart';
import 'package:farmtracker/views/cubits/address/address_state.dart';
import 'package:farmtracker/views/cubits/appointment/appointment_cubit.dart';
import 'package:farmtracker/views/cubits/appointment/appointment_state.dart';
import 'package:farmtracker/views/cubits/base_entity/base_entity_cubit.dart';
import 'package:farmtracker/views/cubits/base_entity/base_entity_state.dart';
import 'package:farmtracker/views/cubits/customer/customer_cubit.dart';
import 'package:farmtracker/views/cubits/customer/customer_state.dart';
import 'package:farmtracker/views/cubits/type_visit/type_visit_cubit.dart';
import 'package:farmtracker/views/cubits/type_visit/type_visit_state.dart';
import 'package:farmtracker/views/cubits/wallet/wallet_cubit.dart';
import 'package:farmtracker/views/cubits/wallet/wallet_state.dart';
import 'package:farmtracker/views/dashboard/widgets/card_schedule_dashboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  DateTime? _selectedDate;
  DateTime _currentMonth = DateTime.now();
  final DateTime _today = DateTime.now();

  DateTime _parseAppointmentDateTime(AppointmentModel appointment) {
    return DateTime.parse(appointment.datetime).toLocal();
  }

  bool _hasAppointmentOnDate(DateTime date, List<AppointmentModel> appointments) {
    return appointments.any((appointment) {
      final DateTime appointmentDate = _parseAppointmentDateTime(appointment);
      return appointmentDate.year == date.year &&
          appointmentDate.month == date.month &&
          appointmentDate.day == date.day;
    });
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _isDiaAtual(DateTime date) {
    final DateTime hoje = DateTime(_today.year, _today.month, _today.day);
    final DateTime dia = DateTime(date.year, date.month, date.day);
    return dia == hoje;
  }

  Color _corFundoDiaCalendario({
    required bool isSelected,
    required bool isDiaAtual,
    required bool hasEvent,
  }) {
    if (isSelected) return Theme.of(context).colorScheme.primary;
    if (isDiaAtual) return AppColors.calendarToday.withValues(alpha: 0.2);
    if (hasEvent) return AppColors.success.withValues(alpha: 0.2);
    return Colors.transparent;
  }

  void _selecionarDia(DateTime date, {bool atualizarCalendario = false}) {
    final DateTime normalizedDate = DateTime(date.year, date.month, date.day);

    setState(() {
      _selectedDate = normalizedDate;
      _currentMonth = DateTime(normalizedDate.year, normalizedDate.month, 1);
    });

    final AppointmentCubit appointmentCubit = context.read<AppointmentCubit>();
    if (atualizarCalendario) {
      appointmentCubit.carregarAppointments().then((_) {
        if (!mounted) return;
        appointmentCubit.carregarAppointmentsPorData(normalizedDate);
      });
      return;
    }

    appointmentCubit.carregarAppointmentsPorData(normalizedDate);
  }

  void _atualizarDashboardAposNovoAgendamento(DateTime appointmentDate) {
    _selecionarDia(appointmentDate, atualizarCalendario: true);
  }

  String _nomeDoCustomer(String customerId, List<CustomerResponseModel> customers) {
    for (final CustomerResponseModel customer in customers) {
      if (customer.id == customerId) {
        final String? proprietario = customer.proprietario?.trim();
        if (proprietario != null && proprietario.isNotEmpty) return proprietario;
        return 'Cliente sem nome';
      }
    }
    return 'Cliente não encontrado';
  }

  String _formatarProjeto(String project) {
    final CulturaItem? cultura = CulturaItem.fromSerialized(project);
    if (cultura != null) {
      return '${cultura.projeto} - Lote ${cultura.lote}';
    }
    return project;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final AppointmentCubit appointmentCubit = context.read<AppointmentCubit>();
      final AppointmentState currentState = appointmentCubit.state;

      if (currentState is AppointmentGravadoSucesso) {
        _atualizarDashboardAposNovoAgendamento(currentState.appointmentDate);
      } else {
        await appointmentCubit.carregarAppointments();
      }

      if (mounted) await _syncRemoteData();
    });
  }

  Future<void> _syncRemoteData() async {
    final String? userId = await SessionStorage.getUserId();
    if (userId == null || !mounted) return;

    // Sync wallets
    final WalletCubit walletCubit = context.read<WalletCubit>();
    await walletCubit.syncWallets(userId);

    if (!mounted) return;
    final WalletState walletState = walletCubit.state;
    if (walletState is! WalletListLoaded || walletState.wallets.isEmpty) return;

    // Sync customers
    final CustomerCubit customerCubit = context.read<CustomerCubit>();
    await customerCubit.syncCustomersByWallet(walletState.wallets);

    if (!mounted) return;
    final CustomerState customerState = customerCubit.state;
    if (customerState is! CustomerListLoaded || customerState.customers.isEmpty) return;

    // Sync type visits
    final TypeVisitCubit typeVisitCubit = context.read<TypeVisitCubit>();
    await typeVisitCubit.syncTypeVisitsByCustomers(customerState.customers.first.orgOwner!);

    if (!mounted) return;
    final TypeVisitState typeVisitState = typeVisitCubit.state;
    if (typeVisitState is TypeVisitErro) return;

    // Sync base entities
    final BaseEntityCubit baseEntityCubit = context.read<BaseEntityCubit>();
    await baseEntityCubit.syncBaseEntitiesByCustomers(customerState.customers);

    if (!mounted) return;
    final BaseEntityState baseEntityState = baseEntityCubit.state;
    if (baseEntityState is! BaseEntityListLoaded || baseEntityState.baseEntities.isEmpty) return;

    // Sync addresses
    final AddressCubit addressCubit = context.read<AddressCubit>();
    await addressCubit.syncAddressesByCustomers(customerState.customers);

    if (!mounted) return;
    final AddressState addressState = addressCubit.state;
    if (addressState is! AddressListLoaded || addressState.addresses.isEmpty) return;

    if (!mounted) return;
    await context.read<AppointmentCubit>().carregarAppointments();

    if (!mounted || _selectedDate == null) return;
    await context.read<AppointmentCubit>().carregarAppointmentsPorData(_selectedDate!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppointmentCubit, AppointmentState>(
      listener: (context, state) {
        if (state is AppointmentGravadoSucesso) {
          _atualizarDashboardAposNovoAgendamento(state.appointmentDate);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Dashboard', style: AppTextStyles.headlineMedium),
          centerTitle: true,
          actions: [IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {})],
        ),
        drawer: _buildDrawer(context),
        body: BlocBuilder<AppointmentCubit, AppointmentState>(
        builder: (context, appointmentState) {
          final List<AppointmentModel> calendarAppointments = context.read<AppointmentCubit>().allAppointments;

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildCalendarSection(calendarAppointments),
                _buildAppointmentsSection(appointmentState),
              ],
            ),
          );
        },
        ),
        floatingActionButton: FloatingActionButton(onPressed: _handleFloatingActionButton, child: const Icon(Icons.add)),
      ),
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
              context.push('/clienteRelacao');
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Future<void> _handleFloatingActionButton() async {
    final bool sessionValid = await context.read<AuthCubit>().isSessionValid();
    if (!sessionValid) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sessão expirada. Faça login novamente.'), duration: Duration(seconds: 3)),
      );
      await redirectToLoginOnSessionExpired(context);
      return;
    }
    if (!mounted) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primeiro informe um dia no calendário'), duration: Duration(seconds: 2)),
      );
      return;
    }
    if (mounted) {
      context.push(
        '/customerAppointment',
        extra: {'selectedDate': _selectedDate!},
      );
    }
  }

  Widget _buildCalendarSection(List<AppointmentModel> appointments) {
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
                final hasEvent = _hasAppointmentOnDate(date, appointments);
                final bool isDiaAtual = _isDiaAtual(date);

                return GestureDetector(
                  onTap: () => _selecionarDia(date),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _corFundoDiaCalendario(
                        isSelected: isSelected,
                        isDiaAtual: isDiaAtual,
                        hasEvent: hasEvent,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$dayNumber',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: isSelected || isDiaAtual ? FontWeight.bold : FontWeight.normal,
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                        if (hasEvent && !isSelected)
                          Container(
                            width: 4,
                            height: 4,
                            margin: const EdgeInsets.only(top: 2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.success,
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
    _selecionarDia(_today);
  }

  Widget _buildAppointmentsSection(AppointmentState appointmentState) {
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

    final int day = _selectedDate!.day;

    if (appointmentState is AppointmentLoading) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Agenda para o dia $day', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 24),
            const Center(child: CircularProgressIndicator()),
          ],
        ),
      );
    }

    if (appointmentState is AppointmentErro) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Agenda para o dia $day', style: AppTextStyles.headlineSmall),
            const SizedBox(height: 16),
            Text(
              appointmentState.mensagem,
              style: AppTextStyles.bodyMedium.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ),
      );
    }

    final List<AppointmentModel> dayAppointments = appointmentState is AppointmentDayLoaded &&
            _isSameDay(appointmentState.date, _selectedDate!)
        ? appointmentState.appointments
        : <AppointmentModel>[];

    return BlocBuilder<CustomerCubit, CustomerState>(
      builder: (context, customerState) {
        final List<CustomerResponseModel> customers = customerState is CustomerListLoaded
            ? customerState.customers
            : <CustomerResponseModel>[];

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Agenda para o dia $day', style: AppTextStyles.headlineSmall),
              const SizedBox(height: 16),
              if (dayAppointments.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Nenhum compromisso agendado para este dia',
                    style: AppTextStyles.bodyMedium.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                )
              else
                ...dayAppointments.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final AppointmentModel appointment = entry.value;
                  final String customerName = _nomeDoCustomer(appointment.customer, customers);
                  final String projectLabel = _formatarProjeto(appointment.project);
                  final DateTime appointmentDateTime = _parseAppointmentDateTime(appointment);

                  return Column(
                    children: [
                      if (index > 0) const SizedBox(height: 12),
                      CardScheduleDashboardWidget(
                        onPressedCard: () => context.push(
                          '/executeAppointment',
                          extra: {'clientName': customerName},
                        ),
                        time: DateFormat('HH:mm', 'pt_BR').format(appointmentDateTime),
                        title: customerName,
                        location: projectLabel,
                        status: appointment.status,
                      ),
                    ],
                  );
                }),
            ],
          ),
        );
      },
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
