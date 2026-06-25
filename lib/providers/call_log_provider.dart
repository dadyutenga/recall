import 'package:flutter/material.dart';
import 'package:call_log/call_log.dart';
import '../services/call_log_service.dart';

class CallLogProvider extends ChangeNotifier {
  List<CallLogEntry> _missedCalls = [];
  bool _loading = false;

  List<CallLogEntry> get missedCalls => List.unmodifiable(_missedCalls);
  bool get loading => _loading;

  Future<void> fetchMissedCalls() async {
    _loading = true;
    notifyListeners();

    try {
      _missedCalls = await CallLogService.getMissedCalls();
    } catch (e) {
      _missedCalls = [];
    }

    _loading = false;
    notifyListeners();
  }

  void clear() {
    _missedCalls = [];
    notifyListeners();
  }
}
