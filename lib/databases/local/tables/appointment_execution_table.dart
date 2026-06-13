const appointmentExecutionTable = 'appointment_execution_table';

class AppointmentExecutionTable {
  String get create =>
      '''
    CREATE TABLE $appointmentExecutionTable (
      id TEXT NOT NULL,
      completed INTEGER NOT NULL,
      reason INTEGER NOT NULL,
      hasPest INTEGER NOT NULL,
      pest TEXT NOT NULL,
      cropPest TEXT NOT NULL,
      datetime TEXT NOT NULL,
      todo TEXT NOT NULL,
      appointmentId TEXT NOT NULL,
      PRIMARY KEY (id)
    );
  ''';
}
