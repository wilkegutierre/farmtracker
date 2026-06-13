enum AppointmentStatusEnum {
  criado(1),
  realizado(2),
  cancelado(3);

  final int value;

  const AppointmentStatusEnum(this.value);

  String get label {
    switch (this) {
      case AppointmentStatusEnum.criado:
        return 'Agendado';
      case AppointmentStatusEnum.realizado:
        return 'Realizado';
      case AppointmentStatusEnum.cancelado:
        return 'Cancelado';
    }
  }

  static AppointmentStatusEnum? fromValue(int value) {
    for (final AppointmentStatusEnum status in AppointmentStatusEnum.values) {
      if (status.value == value) return status;
    }
    return null;
  }

  bool isAtrasado(DateTime appointmentDateTime) {
    return this == AppointmentStatusEnum.criado && appointmentDateTime.isBefore(DateTime.now());
  }

  static bool appointmentIsAtrasado({required int status, required DateTime appointmentDateTime}) {
    final AppointmentStatusEnum? statusEnum = fromValue(status);
    return statusEnum?.isAtrasado(appointmentDateTime) ?? false;
  }
}
