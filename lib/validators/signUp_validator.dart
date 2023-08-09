// ignore_for_file: file_names

import 'dart:async' show StreamTransformer;

class SignUpValidators {
  final validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (name.length >= 6) {
      sink.add(name);
    } else {
      sink.addError('Por favor, digite seu nome completo!');
    }
  });

  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains("@")) {
      sink.add(email);
    } else {
      sink.addError('Insira um email válido');
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 6) {
      sink.add(password);
    } else {
      sink.addError('Senha inválida, deve conter pelo menos 6 caracteres');
    }
  });

  final validatePhone =
      StreamTransformer<String, String>.fromHandlers(handleData: (phone, sink) {
    if (phone.length == 11) {
      sink.add(phone);
    } else {
      sink.addError('Digite um número de telefone válido!');
    }
  });

  final validateNumber =
      StreamTransformer<String, String>.fromHandlers(handleData: (phone, sink) {
    // ignore: prefer_is_empty
    if (phone.length >= 1) {
      sink.add(phone);
    } else {
      sink.addError('Número Residencial Inválido!');
    }
  });

  final validateAddress = StreamTransformer<String, String>.fromHandlers(
      handleData: (address, sink) {
    if (address.isNotEmpty) {
      sink.add(address);
    } else {
      sink.addError('Endereço Inválido!');
    }
  });
}
