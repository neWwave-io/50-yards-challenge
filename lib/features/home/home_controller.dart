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

  /// Goes offline. [returnsOn] is the day they are back; null means no date.
  ///
  /// Returns a message to show if it failed. Reloads on success, because
  /// going away changes the header, the week tracker and the streak at once.
  Future<String?> goAway({DateTime? returnsOn}) =>
      _change(() => repository.setAway(returnsOn: returnsOn));

  /// Back online.
  Future<String?> comeBack() => _change(repository.setAvailable);

  Future<String?> _change(Future<void> Function() write) async {
    try {
      await write();
    } catch (e) {
      return 'Could not update your status: $e';
    }
    await load();
    return null;
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
