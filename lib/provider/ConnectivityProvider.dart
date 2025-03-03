import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _isInternetConnected = false;
  late final StreamSubscription<InternetStatus> _subscription;

  ConnectivityProvider() {
    _initialize(); //Checks the initial connection status
   _subscription = InternetConnection().onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          _isInternetConnected = true;
          break;
        case InternetStatus.disconnected:
          _isInternetConnected = false;
          break;
      }
      notifyListeners();
    });
  }

  Future<void> _initialize() async {
    _isInternetConnected = await InternetConnection().hasInternetAccess;
    notifyListeners();
  }

  bool get isInternetConnected => _isInternetConnected;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _subscription.cancel();
  }
}
