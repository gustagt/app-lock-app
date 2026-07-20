import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../data/repositories/focus_repository.dart';

class FocusNotifier extends ChangeNotifier {
  final FocusRepository _repository;

  int _todaySeconds = 0;
  double _percentageChange = 0.0;
  bool _isLoading = false;
  String? _error;

  DateTime? _activeSessionStartAt;
  Timer? _activeTimer;

  FocusNotifier({FocusRepository? repository})
      : _repository = repository ?? FocusRepository();

  int get todaySeconds {
    if (_activeSessionStartAt != null) {
      final elapsed = DateTime.now().difference(_activeSessionStartAt!).inSeconds;
      return _todaySeconds + elapsed;
    }
    return _todaySeconds;
  }

  double get percentageChange => _percentageChange;
  bool get isLoading => _isLoading;
  String? get error => _error;

  String get todayDurationFormatted =>
      _formatDuration(todaySeconds);

  String get percentageChangeFormatted {
    final rounded = _percentageChange.round();
    return '$rounded%';
  }

  double progress(int? dailyGoalMinutes) {
    if (dailyGoalMinutes == null || dailyGoalMinutes <= 0) return 0.0;
    return (todaySeconds / (dailyGoalMinutes * 60)).clamp(0.0, 1.0);
  }

  String metaLabel(int? dailyGoalMinutes) {
    final pct = (progress(dailyGoalMinutes) * 100).round();
    return '$pct% da meta diária';
  }

  void startActiveTracking(DateTime sessionStartedAt) {
    _activeSessionStartAt = sessionStartedAt;
    _activeTimer?.cancel();
    _activeTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      notifyListeners();
    });
  }

  void stopActiveTracking() {
    _activeTimer?.cancel();
    _activeTimer = null;
    _activeSessionStartAt = null;
  }

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    await _refresh();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadSilently() async {
    await _refresh();
    notifyListeners();
  }

  Future<void> _refresh() async {
    try {
      _todaySeconds = await _repository.getTodayTotalSeconds();
      _percentageChange = await _repository.getPercentageChange();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
  }

  @override
  void dispose() {
    stopActiveTracking();
    super.dispose();
  }

  static String _formatDuration(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    if (hours > 0) return '${hours}h ${minutes}min';
    return '${minutes}min';
  }
}
