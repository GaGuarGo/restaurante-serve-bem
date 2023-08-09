// ignore_for_file: avoid_function_literals_in_foreach_calls, constant_identifier_names

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/subjects.dart';

enum SettingsState { IDLE, SUCCESS, FAIL, LOADING }

class SettingBloc extends BlocBase {
  final _firestore = FirebaseFirestore.instance;

  final _settingsController = BehaviorSubject<Map<String, dynamic>>();
  Stream<Map<String, dynamic>> get outSettings => _settingsController.stream;

  final _stateController = BehaviorSubject<SettingsState>();
  Stream<SettingsState> get outState => _stateController.stream;

  Map<String, dynamic> _settings = {};
  String? _sid;

  _getSettings() {
    _firestore.collection('settings').snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((setting) {
        String sid = setting.doc.id;
        _sid = sid;

        switch (setting.type) {
          case DocumentChangeType.added:
            _settings = setting.doc.data()!;
            break;
          case DocumentChangeType.modified:
            _settings.addAll(setting.doc.data()!);
            _settingsController.add(_settings);
            break;
          case DocumentChangeType.removed:
            _settings.remove(setting.doc.data()!);
            _settingsController.add(_settings);
            break;
        }
      });
      _settingsController.add(_settings);
      //print(_settings);
    });
  }

  changeSettings({required String key, required dynamic newValue}) async {
    _stateController.add(SettingsState.LOADING);

    try {

      await _firestore.collection('settings').doc(_sid!).update({key : newValue});
      _stateController.add(SettingsState.SUCCESS);
    } catch (e) {
      _stateController.add(SettingsState.FAIL);
    }
  }

  SettingBloc() {
    _getSettings();
  }

  @override
  void dispose() {
    super.dispose();
    _settingsController.close();
    _stateController.close();
  }
}
