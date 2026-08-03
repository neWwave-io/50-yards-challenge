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

import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> deleteAllNotifications(List<DocumentReference>? refs) async {
  try {
    if (refs == null || refs.isEmpty) return true;

    // Remove nulls + duplicates
    final uniqueRefs = <DocumentReference>{};
    for (final r in refs) {
      if (r != null) uniqueRefs.add(r);
    }
    if (uniqueRefs.isEmpty) return true;

    const int batchLimit = 500;
    final fs = FirebaseFirestore.instance;

    WriteBatch batch = fs.batch();
    int opCount = 0;

    for (final ref in uniqueRefs) {
      batch.delete(ref);
      opCount++;

      // Commit every 500 ops (Firestore limit)
      if (opCount >= batchLimit) {
        await batch.commit();
        batch = fs.batch();
        opCount = 0;
      }
    }

    // Commit remaining
    if (opCount > 0) {
      await batch.commit();
    }

    return true;
  } catch (e) {
    // Optional: log for debugging in FlutterFlow
    debugPrint('deleteAllNotifications error: $e');
    return false;
  }
}
