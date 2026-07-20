import 'package:flutter/foundation.dart';
import '../../data/models/blocked_app_model.dart';
import '../../data/repositories/blocked_app_repository.dart';

class BlockedAppsNotifier extends ChangeNotifier {
  final BlockedAppRepository _repository;

  List<BlockedAppModel> _blockedApps = [];
  bool _isLoading = false;
  String? _error;

  BlockedAppsNotifier({BlockedAppRepository? repository})
      : _repository = repository ?? BlockedAppRepository();

  List<BlockedAppModel> get blockedApps => _blockedApps;
  int get blockedCount => _blockedApps.length;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.resetDailyUsageIfNeeded();
      _blockedApps = await _repository.getBlocked();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addApp(BlockedAppModel app) async {
    try {
      final id = await _repository.insert(app);
      _blockedApps = [
        app.copyWith(id: id),
        ..._blockedApps,
      ];
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> toggleBlock(int id) async {
    final index = _blockedApps.indexWhere((a) => a.id == id);
    if (index == -1) return;
    final app = _blockedApps[index];
    final updated = app.copyWith(isBlocked: !app.isBlocked);
    try {
      await _repository.update(updated);
      _blockedApps[index] = updated;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeApp(int id) async {
    try {
      await _repository.delete(id);
      _blockedApps = _blockedApps.where((a) => a.id != id).toList();
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
