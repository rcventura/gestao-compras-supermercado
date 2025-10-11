import 'package:flutter/material.dart';

class Validator {
  bool validarForm(GlobalKey<FormState> formKey) {
    return formKey.currentState?.validate() ?? false;
  }

// VALIDAR CAMPO TIPO EMAIL
  String? validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo Obrigatório';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }
    return null;
  }
}
