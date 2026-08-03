// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<int?> newUsers(List<UsersRecord>? users) async {
  if (users == null || users.isEmpty) {
    return 0;
  }

  final now = DateTime.now();
  final startOfMonth = DateTime(now.year, now.month, 1);

  int count = 0;

  for (final user in users) {
    // Use the correct timestamp field from UsersRecord
    final createdTime = user.createdTime; // <-- update this name

    if (createdTime == null) continue;

    if (!createdTime.isBefore(startOfMonth)) {
      count++;
    }
  }

  return count;
}
