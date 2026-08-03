import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/auth/firebase_auth/auth_util.dart';

List<TopUsersStruct> top10Leaderboard(List<TopUsersStruct> allUsers) {
  if (allUsers.isEmpty) return [];

  // Ensure the list is sorted by total_lawns (descending)
  final sorted = [...allUsers]
    ..sort((a, b) => (b.totalLawns ?? 0).compareTo(a.totalLawns ?? 0));

  // Return users ranked #4 to #10 → indexes 3 to 9
  final start = 3;
  final end = sorted.length < 10 ? sorted.length : 10;

  if (start >= sorted.length) return [];

  return sorted.sublist(start, end);
}

List<MowedCategoriesStruct> getDuplicate(
  List<LawnsRecord>? lawnDocuments,
  List<String>? whoFor,
) {
  final Map<String, int> counter = {};

  // Count documents if they exist
  for (final lawn in lawnDocuments ?? []) {
    final who = lawn.whoFor?.trim();
    if (who == null || who.isEmpty) continue;

    counter[who] = (counter[who] ?? 0) + 1;
  }

  // If whoFor is null or empty, return empty list intentionally
  if (whoFor == null || whoFor.isEmpty) {
    return [];
  }

  // Always return whoFor with count (default 0)
  return whoFor
      .map((item) {
        final who = item.trim();
        if (who.isEmpty) return null;

        return MowedCategoriesStruct(
          who: who,
          numMow: counter[who] ?? 0,
        );
      })
      .whereType<MowedCategoriesStruct>()
      .toList();
}

bool? searchName(
  String? searchFor,
  String? searchIn,
) {
  if (searchIn == null) {
    return false;
  }

  // If search text is empty/null, treat as "match everything"
  if (searchFor == null || searchFor.trim().isEmpty) {
    return true;
  }

  final query = searchFor.trim().toLowerCase();
  final target = searchIn.toLowerCase();

  // true if searchIn contains searchFor (case-insensitive)
  return target.contains(query);
}

String? totalPlusNumber(List<double>? number) {
  if (number == null || number.isEmpty) return "0";

  double total = 0.0;
  for (final n in number) {
    total += n;
  }

  return total.toString();
}

String? imageString(String? imagePath) {
  if (imagePath == null) return null;

  final s = imagePath.toString().trim();
  if (s.isEmpty) return null;

  return s;
}
