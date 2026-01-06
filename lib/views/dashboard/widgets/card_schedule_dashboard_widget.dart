import 'package:farmtracker/views/core/style/app_colors.dart';
import 'package:farmtracker/views/core/style/app_text_styles.dart';
import 'package:farmtracker/views/dashboard/widgets/outlined_button_dashboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CardScheduleDashboardWidget extends StatelessWidget {
  final VoidCallback? onPressedCard;
  final String time;
  final String title;
  final String location;
  final int status;

  const CardScheduleDashboardWidget({
    super.key,
    required this.onPressedCard,
    required this.time,
    required this.title,
    required this.location,
    required this.status,
  });

  String _getStatusText() {
    switch (status) {
      case 0:
        return 'Realizada';
      case 1:
        return 'Cancelado';
      case 2:
        return 'Realizada';
      case 3:
        return 'Pendente';
      default:
        return 'Realizada';
    }
  }

  Color _getStatusColor() {
    switch (status) {
      case 1: // Cancelado
        return AppColors.error;
      case 0: // Agendado
      case 2: // Concluído
        return AppColors.success;
      case 3: // Pendente
        return AppColors.textSecondary;
      default: // Agendado
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide.none),
      color: AppColors.cardBackground,
      child: InkWell(
        onTap: onPressedCard,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side: Time, Title, Location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time with icon
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text(time, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Title
                    // Location with icon
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            title,
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(location, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Right side: Status and Button
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Status
                  Text(
                    _getStatusText(),
                    style: AppTextStyles.bodyMedium.copyWith(color: _getStatusColor(), fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  // Ver button
                  OutlinedButtonDashboardWidget(
                    onPressed: () {
                      Modular.to.pushNamed('/appointment', arguments: {'clientName': 'Cliente', 'farmName': 'Fazenda'});
                    },
                    borderSideColor: AppColors.primaryTeal,
                    text: 'Ver',
                    textColor: AppColors.primaryTealDark,
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
