import 'package:flutter/material.dart';

class Validator extends ChangeNotifier {
  bool validarForm(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }

  // VALIDAR CAMPO NOME
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    if (value.length < 3) {
      return 'Nome deve ter pelo menos 3 caracteres';
    }
    return null;
  }

// VALIDAR CAMPO EMAIL
  String? validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
     if (value.length < 3) {
      return 'Nome deve ter pelo menos 3 caracteres';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }
    return null;
  }

// VALIDAR CAMPO SENHA
    String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

// VALIDAR CAMPO CONFIRMAR SENHA
  String? validateConfirmPassword(String? value, TextEditingController passwordWidget) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    if (value != passwordWidget.text) {
      return 'As senhas não coincidem';
    }
    return null;
  }


  // VALIDAR NOME DA LISTA  
  String? validateListName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    if (value.length < 3) {
      return 'Nome deve ter pelo menos 3 caracteres';
    }
    return null;
  }

    // VALIDATE MARKET NAME
  String? validateMarketName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }
}
