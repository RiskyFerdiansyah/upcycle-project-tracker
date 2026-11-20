import 'package:flutter/foundation.dart';

class DemoAccountStore {
  DemoAccountStore._();

  static const defaultEmail = 'demo@upcycle.app';
  static const defaultPassword = 'upcycle123';
  static const accountRole = 'Community Creator';

  static final instance = DemoAccountStore._();

  final ValueNotifier<int> revision = ValueNotifier(0);
  String _name = 'Demo User';
  String _email = defaultEmail;
  String _password = defaultPassword;
  bool _isDeleted = false;

  String get name => _name;
  String get email => _email;
  String get role => accountRole;
  String get password => _password;
  bool get isDeleted => _isDeleted;

  bool authenticate(String email, String password) =>
      !_isDeleted &&
      email.trim().toLowerCase() == _email.toLowerCase() &&
      password == _password;

  void updateProfile({required String name, required String email}) {
    _name = name.trim();
    _email = email.trim();
    _notifyChanged();
  }

  void register({
    required String name,
    required String email,
    required String password,
  }) {
    _name = name.trim();
    _email = email.trim();
    _password = password;
    _isDeleted = false;
    _notifyChanged();
  }

  void deleteAccount() {
    _isDeleted = true;
    _notifyChanged();
  }

  void _notifyChanged() => revision.value++;
}
