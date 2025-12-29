import 'package:equatable/equatable.dart';
import 'package:farmtracker/modules/app_material_route.dart';
import 'package:farmtracker/modules/routes_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:intl/intl.dart';

void initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  configGlobals();

  runApp(
    ModularApp(
      module: RouteModule(),
      child: const RxRoot(child: AppMaterialRoute()),
    ),
  );
}

void configGlobals() {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'pt_BR';

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    // DeviceOrientation.landscapeLeft,
    // DeviceOrientation.landscapeRight,
  ]);

  EquatableConfig.stringify = true;
}
