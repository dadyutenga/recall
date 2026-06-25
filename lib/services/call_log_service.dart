import 'package:call_log/call_log.dart';
import 'package:permission_handler/permission_handler.dart';
import '../core/constants/app_constants.dart';

class CallLogService {
  static Future<bool> requestPermission() async {
    final status = await Permission.phone.request();
    return status.isGranted;
  }

  static Future<List<CallLogEntry>> getMissedCalls({
    int daysBack = AppConstants.callLogDaysBack,
  }) async {
    final hasPermission = await requestPermission();
    if (!hasPermission) return [];

    final start = DateTime.now().subtract(Duration(days: daysBack));

    final Iterable<CallLogEntry> calls = await CallLog.query(
      dateFrom: start.millisecondsSinceEpoch,
    );

    return calls
        .where((call) => call.callType == CallType.missed)
        .where((call) => call.timestamp != null && call.timestamp! >= start.millisecondsSinceEpoch)
        .toList();
  }
}
