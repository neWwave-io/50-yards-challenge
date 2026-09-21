import 'package:flutter/foundation.dart';

import 'data/home_data.dart';
import 'data/home_repository.dart';

/// Loads the home page and holds what it is showing.
class HomeController extends ChangeNotifier {
  HomeController({this.repository = const HomeRepository()});

  final HomeRepository repository;

  HomeData? _data;
  Object? _error;
  var _loading = false;

  HomeData? get data => _data;
  Object? get error => _error;

  /// True only on the very first load, when there is nothing to show yet.
  bool get isFirstLoad => _loading && _data == null;

  /// Whether the requested-lawn card is accepting map requests. Local for
  /// now — nothing stores this preference yet.
  var acceptingRequests = false;

  void toggleAcceptingRequests() {
    acceptingRequests = !acceptingRequests;
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
