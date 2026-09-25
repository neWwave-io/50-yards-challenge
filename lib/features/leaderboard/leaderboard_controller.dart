import 'dart:async';

import 'package:flutter/foundation.dart';

import 'data/leaderboard_data.dart';
import 'data/leaderboard_repository.dart';

/// Loads the leaderboard and holds the search and state filter.
class LeaderboardController extends ChangeNotifier {
  LeaderboardController({this.repository = const LeaderboardRepository()});

  final LeaderboardRepository repository;

  static const _pageSize = 30;
  static const _searchDelay = Duration(milliseconds: 300);

  List<LeaderboardEntry> _podium = const [];
  List<LeaderboardEntry> _participants = const [];
  MyStanding? _me;
  Object? _error;
  var _loaded = false;
  var _loadingPage = false;
  var _hasMore = true;

  String? _state;
  String _search = '';
  Timer? _debounce;

  /// Bumped on every new query, so a slow page that lands after the filter
  /// changed is dropped instead of mixed into the new list.
  var _generation = 0;

  List<LeaderboardEntry> get podium => _podium;
  List<LeaderboardEntry> get participants => _participants;
  MyStanding? get me => _me;
  Object? get error => _error;

  /// The chosen state, or null for the whole country.
  String? get state => _state;
  String get search => _search;

  bool get isFirstLoad => !_loaded && _error == null;
  bool get loadingPage => _loadingPage;
  bool get hasMore => _hasMore;

  /// Whether a search or state narrows the list.
  bool get isFiltered => _state != null || _search.trim().isNotEmpty;

  Future<void> load() async {
    // A full reload supersedes any page still on its way — and is itself
    // superseded if the filter changes before it lands.
    final generation = ++_generation;
    _loadingPage = false;
    _error = null;
    notifyListeners();
    try {
      final results = await Future.wait([
        repository.topFive(),
        repository.mine(),
        _fetchPage(offset: 0),
      ]);
      _podium = results[0] as List<LeaderboardEntry>;
      _me = results[1] as MyStanding?;
      if (generation == _generation) {
        _setFirstPage(results[2] as List<LeaderboardEntry>);
      }
      _loaded = true;
    } catch (e) {
      // Keep whatever is on screen; a failed refresh should not blank it.
      _error = e;
    } finally {
      notifyListeners();
    }
  }

  void chooseState(String? state) {
    if (state == _state) return;
    _state = state;
    _reloadParticipants();
  }

  void setSearch(String text) {
    if (text.trim() == _search.trim()) {
      _search = text;
      return;
    }
    _search = text;
    _debounce?.cancel();
    _debounce = Timer(_searchDelay, _reloadParticipants);
  }

  /// Fetches the next page, if there is one and none is on its way.
  Future<void> loadMore() async {
    if (_loadingPage || !_hasMore || !_loaded) return;
    final generation = _generation;
    _loadingPage = true;
    notifyListeners();
    try {
      final page = await _fetchPage(offset: _participants.length);
      if (generation != _generation) return;
      _participants = [..._participants, ...page];
      _hasMore = page.length == _pageSize;
    } catch (e) {
      debugPrint('Leaderboard: could not load more — $e');
    } finally {
      if (generation == _generation) {
        _loadingPage = false;
        notifyListeners();
      }
    }
  }

  Future<void> _reloadParticipants() async {
    final generation = ++_generation;
    _loadingPage = true;
    notifyListeners();
    try {
      final page = await _fetchPage(offset: 0);
      if (generation != _generation) return;
      _setFirstPage(page);
      _error = null;
    } catch (e) {
      if (generation != _generation) return;
      // The old filter's rows must not linger under the new filter's
      // heading, or be paged onto.
      _setFirstPage(const []);
      _hasMore = false;
      _error = e;
    } finally {
      if (generation == _generation) {
        _loadingPage = false;
        notifyListeners();
      }
    }
  }

  Future<List<LeaderboardEntry>> _fetchPage({required int offset}) =>
      repository.participants(
        state: _state,
        search: _search,
        offset: offset,
        limit: _pageSize,
      );

  void _setFirstPage(List<LeaderboardEntry> page) {
    _participants = page;
    _hasMore = page.length == _pageSize;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
