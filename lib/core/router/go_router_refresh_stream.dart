// core/router/go_router_refresh_stream.dart
import 'dart:async';
import 'package:flutter/foundation.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    debugPrint('[ROUTER-REFRESH] listener attached, notifying once at startup');
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((event) {
      debugPrint(
          '[ROUTER-REFRESH] auth stream emitted: $event -> notifying GoRouter');
      notifyListeners();
    });
  }

  @override
  void dispose() {
    debugPrint('[ROUTER-REFRESH] disposed');
    _subscription.cancel();
    super.dispose();
  }
}
