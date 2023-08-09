// ignore_for_file: constant_identifier_names, file_names, avoid_print, must_call_super

import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:serve_bem_app/models/user_model.dart';
import 'package:serve_bem_app/validators/signUp_validator.dart';

enum SignUpState { IDLE, LOADING, SUCCESS, FAIL }

class SignUpBloc extends BlocBase with SignUpValidators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _nameController = BehaviorSubject<String>();
  final _phoneController = BehaviorSubject<String>();
  final _addressController = BehaviorSubject<String>();
  final _numberController = BehaviorSubject<String>();

  final _stateController = BehaviorSubject<SignUpState>();

  final _userModel = UserModel();

  Stream<String> get outEmail =>
      _emailController.stream.transform(validateEmail);
  Stream<String> get outPassword =>
      _passwordController.stream.transform(validatePassword);
  Stream<String> get outName =>
      _passwordController.stream.transform(validateName);
  Stream<String> get outPhone =>
      _passwordController.stream.transform(validatePhone);
  Stream<String> get outAddress =>
      _passwordController.stream.transform(validateAddress);
  Stream<String> get outNumber =>
      _passwordController.stream.transform(validateNumber);

  Stream<SignUpState> get outState => _stateController.stream;

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changePhone => _phoneController.sink.add;
  Function(String) get changeAddress => _addressController.sink.add;
  Function(String) get changeNumber => _numberController.sink.add;

  Stream<bool> get outSubmitValid => Rx.combineLatest6(outEmail, outPassword,
      outName, outPhone, outAddress, outNumber, (a, b, c, d, e, f) => true);

  late StreamSubscription _streamSubscription;

  SignUpBloc() {
    _streamSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        _stateController.add(SignUpState.SUCCESS);
      } else {
        _stateController.add(SignUpState.IDLE);
      }
    });
  }

  void submit({required Map<String, dynamic> userData}) {
    //final email = _emailController.value.toString();
    final password = _passwordController.value.toString();

    _stateController.add(SignUpState.LOADING);
    try {
      _userModel.signUp(userData: userData, pass: password);
      // _stateController.add(SignUpState.SUCCESS);
    } catch (e) {
      _stateController.add(SignUpState.FAIL);
      print(e.toString());
    }
  }

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _stateController.close();

    _streamSubscription.cancel();
  }
}
