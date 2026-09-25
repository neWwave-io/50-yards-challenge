import 'package:flutter/foundation.dart';

import 'data/profile_data.dart';
import 'data/profile_repository.dart';

/// Loads the profile page and holds what it is showing.
class ProfileController extends ChangeNotifier {
  ProfileController({this.repository = const ProfileRepository()});

  final ProfileRepository repository;

  ProfileData? _data;
  Object? _error;
  var _loading = false;

  ProfileData? get data => _data;
  Object? get error => _error;

  /// True only on the very first load, when there is nothing to show yet.
  bool get isFirstLoad => _loading && _data == null;

  /// Whether the family has opted in to sharing contact details with nearby
  /// families. Local for now and off by default: there is no column behind
  /// it, and nothing may be shared until that is built with RLS in place.
  var sharesContact = false;

  void toggleSharesContact() {
    sharesContact = !sharesContact;
    notifyListeners();
  }

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _data = await repository.load();
    } catch (e) {
      // Keep whatever is already on screen; a refresh that fails should not
      // blank the page.
      _error = e;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
