enum AppointmentSituationEnum {
  scheduled(0),
  canceled(1),
  completed(2),
  pending(3);

  final int status;

  const AppointmentSituationEnum(this.status);
}

int getAppointmentSituationEnum(AppointmentSituationEnum status) {
  switch (status) {
    case AppointmentSituationEnum.scheduled:
      return 0;
    case AppointmentSituationEnum.canceled:
      return 1;
    case AppointmentSituationEnum.completed:
      return 2;
    case AppointmentSituationEnum.pending:
      return 3;
  }
}

// extension AppointmentSituationEnumExtension on AppointmentSituationEnum {
//   int get status {
//     switch (this) {
//       case AppointmentSituationEnum.scheduled:
//         return 0;
//       case AppointmentSituationEnum.completed:
//         return 1;
//       case AppointmentSituationEnum.canceled:
//         return 2;
//       case AppointmentSituationEnum.pending:
//         return 3;
//     }
//   }
// }
