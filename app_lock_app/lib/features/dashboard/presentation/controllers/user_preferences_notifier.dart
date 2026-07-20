import 'package:flutter/foundation.dart';
import '../../data/models/focus_session_model.dart';
import '../../data/models/user_preferences_model.dart';
import '../../data/repositories/focus_repository.dart';
import '../../data/repositories/user_preferences_repository.dart';

class UserPreferencesNotifier extends ChangeNotifier {
  final UserPreferencesRepository _repository;
  final FocusRepository _focusRepository;

  UserPreferencesModel? _prefs;
  bool _isLoading = false;
  String? _error;

  UserPreferencesNotifier({
    UserPreferencesRepository? repository,
    FocusRepository? focusRepository,
  })  : _repository = repository ?? UserPreferencesRepository(),
        _focusRepository = focusRepository ?? FocusRepository();

  UserPreferencesModel? get prefs => _prefs;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get userName => _prefs?.userName;
  bool? get focusModeActive => _prefs?.focusModeActive;
  int? get dailyGoalMinutes => _prefs?.dailyGoalMinutes;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    try {
      _prefs = await _repository.getOrCreate();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFocusMode() async {
    if (_prefs == null) return;
    final previous = _prefs!;
    final becomingActive = !_prefs!.focusModeActive;

    try {
      if (becomingActive) {
        _prefs = _prefs!.copyWith(
          focusModeActive: true,
          focusSessionStartedAt: DateTime.now(),
        );
      } else {
        final startedAt = _prefs!.focusSessionStartedAt;
        if (startedAt != null) {
          final now = DateTime.now();
          final elapsedSeconds = now.difference(startedAt).inSeconds;
          if (elapsedSeconds > 0) {
            await _focusRepository.insert(FocusSessionModel(
              date: now,
              durationSeconds: elapsedSeconds,
            ));
          }
        }
        _prefs = _prefs!.copyWith(
          focusModeActive: false,
          focusSessionStartedAt: null,
        );
      }
      notifyListeners();
      await _repository.save(_prefs!);
    } catch (e) {
      _prefs = previous;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateName(String name) async {
    if (_prefs == null) return;
    final previous = _prefs!;
    _prefs = _prefs!.copyWith(userName: name);
    notifyListeners();
    try {
      await _repository.save(_prefs!);
    } catch (e) {
      _prefs = previous;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateDailyGoal(int minutes) async {
    if (_prefs == null) return;
    final previous = _prefs!;
    _prefs = _prefs!.copyWith(dailyGoalMinutes: minutes);
    notifyListeners();
    try {
      await _repository.save(_prefs!);
    } catch (e) {
      _prefs = previous;
      _error = e.toString();
      notifyListeners();
    }
  }
}
