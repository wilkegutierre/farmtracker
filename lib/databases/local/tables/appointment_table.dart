const appointmentTable = 'appointment_table';

class AppointmentTable {
  String get create =>
      '''
    CREATE TABLE $appointmentTable (
      id TEXT NOT NULL,
      user TEXT NOT NULL,
      customer TEXT NOT NULL,
      project TEXT NOT NULL,
      datetime TEXT NOT NULL,
      type TEXT NOT NULL,
      todo TEXT,
      status INTEGER NOT NULL,
      PRIMARY KEY (id)
    );
  ''';
}
