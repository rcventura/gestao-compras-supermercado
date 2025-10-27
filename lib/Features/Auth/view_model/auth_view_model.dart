import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  // Estado
  bool _isLoading = false;
  String? nameTextField;
  String? emailTextField;
  String? passwordTextField;
  String? _errorMessage;
  String? _successMessage;

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  // CADASTRAR NOVO USUÁRIO
  Future<bool> register() async {
    _errorMessage = null;
    _successMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.createUser(
        displayName: nameTextField ?? '',
        email: emailTextField ?? '',
        password: passwordTextField ?? '',
      );
      _successMessage = 'Conta criada com sucesso!';
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();

      return false;
    }
  }

  // REALIZAR LOGIN
  Future<bool> signIn(String email, String password) async {
    try {
      await _authService.signIn(
        email: email,
        password: password,
      );
      notifyListeners();
      return true;
    } catch (e) {
      print('Erro ao logar: $e');
      return false;
    }
  }

  // RESET PASSWORD
  Future<bool> resetPassword(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email: email);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // LIMPAR MENSAGENS
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}
