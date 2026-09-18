import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  List<String> _optionMowed = [];
  List<String> get optionMowed => _optionMowed;
  set optionMowed(List<String> value) {
    _optionMowed = value;
  }

  void addToOptionMowed(String value) {
    optionMowed.add(value);
  }

  void removeFromOptionMowed(String value) {
    optionMowed.remove(value);
  }

  void removeAtIndexFromOptionMowed(int index) {
    optionMowed.removeAt(index);
  }

  void updateOptionMowedAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    optionMowed[index] = updateFn(_optionMowed[index]);
  }

  void insertAtIndexInOptionMowed(int index, String value) {
    optionMowed.insert(index, value);
  }

  List<String> _listStates = [];
  List<String> get listStates => _listStates;
  set listStates(List<String> value) {
    _listStates = value;
  }

  void addToListStates(String value) {
    listStates.add(value);
  }

  void removeFromListStates(String value) {
    listStates.remove(value);
  }

  void removeAtIndexFromListStates(int index) {
    listStates.removeAt(index);
  }

  void updateListStatesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    listStates[index] = updateFn(_listStates[index]);
  }

  void insertAtIndexInListStates(int index, String value) {
    listStates.insert(index, value);
  }

  bool _initLogin = false;
  bool get initLogin => _initLogin;
  set initLogin(bool value) {
    _initLogin = value;
  }
}
