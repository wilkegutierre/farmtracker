import 'dart:async';

import 'package:flutter/foundation.dart';

/// Adapta um [Stream] para [ChangeNotifier], permitindo que o GoRouter
/// se reconecte ao stream de estado e recalcule os redirects automaticamente.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
