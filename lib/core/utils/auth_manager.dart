import 'dart:async';

class AuthManager {
  AuthManager._();
  static final AuthManager instance = AuthManager._();

  final _logoutController = StreamController<void>.broadcast();
  Stream<void> get logoutStream => _logoutController.stream;

  void triggerLogout() {
    _logoutController.add(null);
  }

  void dispose() {
    _logoutController.close();
  }
}
