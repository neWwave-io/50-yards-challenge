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

  /// Fallback so the "who did you mow for" dropdown is never empty when the
  /// backend has no settings row yet. Overwritten once settings load.
  List<String> _optionMowed = [
    'Elderly',
    'Disabled',
    'Single Parent',
    'Veteran',
    'Deployed Military',
  ];
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

  /// Fallback state list, used until settings load.
  List<String> _listStates = [
    'Alabama', 'Alaska', 'Arizona', 'Arkansas', 'California', 'Colorado',
    'Connecticut', 'Delaware', 'District of Columbia', 'Florida', 'Georgia',
    'Hawaii', 'Idaho', 'Illinois', 'Indiana', 'Iowa', 'Kansas', 'Kentucky',
    'Louisiana', 'Maine', 'Maryland', 'Massachusetts', 'Michigan',
    'Minnesota', 'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada',
    'New Hampshire', 'New Jersey', 'New Mexico', 'New York',
    'North Carolina', 'North Dakota', 'Ohio', 'Oklahoma', 'Oregon',
    'Pennsylvania', 'Rhode Island', 'South Carolina', 'South Dakota',
    'Tennessee', 'Texas', 'Utah', 'Vermont', 'Virginia', 'Washington',
    'West Virginia', 'Wisconsin', 'Wyoming',
  ];
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
