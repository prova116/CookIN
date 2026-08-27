import 'package:flutter/foundation.dart';

class Account {
  final String name;
  final String phone;
  final String address;
  final String email;
  String password;

  Account({
    required this.name,
    required this.phone,
    required this.address,
    required this.email,
    required this.password,
  });
}

/// In-memory auth - no backend, so registered accounts and the signed-in
/// user reset whenever the app reloads (same lifetime as CartService).
class AuthService extends ValueNotifier<Account?> {
  AuthService._() : super(null);
  static final AuthService instance = AuthService._();

  final List<Account> _accounts = [];

  Account? get currentUser => value;

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  Account? _findByEmail(String email) {
    final normalized = email.trim().toLowerCase();
    for (final account in _accounts) {
      if (account.email.toLowerCase() == normalized) return account;
    }
    return null;
  }

  bool accountExists(String email) => _findByEmail(email) != null;

  /// Returns null on success, or an error message to show the user.
  String? register({
    required String name,
    required String phone,
    required String address,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    if (name.trim().isEmpty) return "Please enter your name";
    if (phone.trim().isEmpty) return "Please enter your phone number";
    if (!_emailPattern.hasMatch(email.trim())) {
      return "Please enter a valid email";
    }
    if (password.length < 6) {
      return "Password must be at least 6 characters";
    }
    if (password != confirmPassword) {
      return "Passwords don't match";
    }
    if (accountExists(email)) {
      return "An account with this email already exists";
    }
    _accounts.add(Account(
      name: name.trim(),
      phone: phone.trim(),
      address: address.trim(),
      email: email.trim(),
      password: password,
    ));
    return null;
  }

  /// Returns null on success, or an error message to show the user.
  String? logIn({required String email, required String password}) {
    if (email.trim().isEmpty || password.isEmpty) {
      return "Please enter your email and password";
    }
    final account = _findByEmail(email);
    if (account == null) {
      return "No account found for this email. Please sign up.";
    }
    if (account.password != password) {
      return "Incorrect password";
    }
    value = account;
    return null;
  }

  void logOut() {
    value = null;
  }

  /// Returns null on success, or an error message to show the user.
  String? resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) {
    final account = _findByEmail(email);
    if (account == null) {
      return "No account found for this email";
    }
    if (newPassword.length < 6) {
      return "Password must be at least 6 characters";
    }
    if (newPassword != confirmPassword) {
      return "Passwords don't match";
    }
    account.password = newPassword;
    return null;
  }

  /// Test-only: clears all accounts and signs out.
  @visibleForTesting
  void reset() {
    _accounts.clear();
    value = null;
  }
}
