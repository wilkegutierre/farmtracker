import 'package:farmtracker/domains/enums/appointment_status_enum.dart';
import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:farmtracker/views/dashboard/widgets/outlined_button_dashboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CardScheduleDashboardWidget extends StatelessWidget {
  final VoidCallback? onPressedCard;
  final String time;
  final String title;
  final String location;
  final int statusAppointment;
  final DateTime appointmentDateTime;

  const CardScheduleDashboardWidget({
    super.key,
    required this.onPressedCard,
    required this.time,
    required this.title,
    required this.location,
    required this.statusAppointment,
    required this.appointmentDateTime,
  });

  bool get _isAtrasado => AppointmentStatusEnum.appointmentIsAtrasado(
        status: statusAppointment,
        appointmentDateTime: appointmentDateTime,
      );

  String _getStatusText() {
    if (_isAtrasado) return 'Atrasado';

    final AppointmentStatusEnum? statusEnum = AppointmentStatusEnum.fromValue(statusAppointment);
    return statusEnum?.label ?? 'Desconhecido';
  }

  Color _getStatusColor() {
    if (_isAtrasado) return AppColors.warning;

    final AppointmentStatusEnum? statusEnum = AppointmentStatusEnum.fromValue(statusAppointment);

    switch (statusEnum) {
      case AppointmentStatusEnum.criado:
        return AppColors.success;
      case AppointmentStatusEnum.cancelado:
        return AppColors.error;
      case AppointmentStatusEnum.realizado:
        return AppColors.secondary;
      case null:
        return AppColors.error;
    }
  }

  Color _getCardBackgroundColor(ColorScheme scheme) {
    if (_isAtrasado) return AppColors.warning.withValues(alpha: 0.12);
    return scheme.surfaceContainer;
  }

  BorderSide _getCardBorder() {
    if (_isAtrasado) {
      return BorderSide(color: AppColors.warning.withValues(alpha: 0.45));
    }
    return BorderSide.none;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final bool isAtrasado = _isAtrasado;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: _getCardBorder(),
      ),
      color: _getCardBackgroundColor(scheme),
      child: InkWell(
        onTap: onPressedCard,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: isAtrasado ? AppColors.warning : scheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          time,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isAtrasado ? AppColors.warning : scheme.onSurfaceVariant,
                            fontWeight: isAtrasado ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Title
                    // Location with icon
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: scheme.onSurfaceVariant),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            title,
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: scheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(location, style: AppTextStyles.bodyMedium.copyWith(color: scheme.onSurfaceVariant)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Right side: Status and Button
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isAtrasado) ...[
                        Icon(Icons.warning_amber_rounded, size: 18, color: AppColors.warning),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        _getStatusText(),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: _getStatusColor(),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Ver button
                  OutlinedButtonDashboardWidget(
                    onPressed: () =>
                        context.push('/appointment', extra: {'clientName': 'Cliente', 'farmName': 'Fazenda'}),
                    text: 'Ver',
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
