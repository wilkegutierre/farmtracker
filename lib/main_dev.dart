import 'package:farmtracker/modules/app.dart';
import 'package:farmtracker/enviroment.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: Enviroment.fileName);
  initApp();
}
