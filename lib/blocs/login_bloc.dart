// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, constant_identifier_names

import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:serve_bem_app/validators/login_validator.dart';

enum LoginState { IDLE, LOADING, SUCCESS, FAIL, SUCCESSADM }

class LoginBloc extends BlocBase with LoginValidator {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<LoginState>();

  Stream<String> get outEmail =>
      _emailController.stream.transform(validateEmail);

  Stream<String> get outPassword =>
      _passwordController.stream.transform(validatePassword);

  Stream<LoginState> get outState => _stateController.stream;

  Stream<bool> get outSubmitValid =>
      Rx.combineLatest2(outEmail, outPassword, (a, b) => true);

  Function(String) get changeEmail => _emailController.sink.add;

  Function(String) get changePassword => _passwordController.sink.add;

  late StreamSubscription _streamSubscription;

  LoginBloc() {
    _stateController.add(LoginState.LOADING);

    _streamSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        if (await verifyPrivileges(user)) {
          _stateController.add(LoginState.SUCCESSADM);
        } else {
          _stateController.add(LoginState.SUCCESS);
        }
      } else {
        _stateController.add(LoginState.IDLE);
        user = null;
      }
    });
  }

  void logoff() {
    _stateController.add(LoginState.IDLE);
  }

  void submit({required VoidCallback onFail}) {
    final email = _emailController.value.toString();
    final password = _passwordController.value.toString();

    _stateController.add(LoginState.LOADING);

    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .catchError((e) {
      _stateController.add(LoginState.FAIL);
      onFail();
    });
  }

  Future<bool> verifyPrivileges(User user) async {
    return await FirebaseFirestore.instance
        .collection('admins')
        .doc(user.uid)
        .get()
        .then((doc) {
      if (doc.data() != null) {
        return true;
      } else {
        return false;
      }
    }).catchError((e) {
      return false;
    });
  }

  @override
  // ignore: must_call_super
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _stateController.close();

    _streamSubscription.cancel();
  }
}
