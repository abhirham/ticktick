import 'package:flutter/services.dart';

import 'widget_data_service.dart';

class NativeWidgetBridge {
  const NativeWidgetBridge({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('flowtask/widget_bridge');

  static const todaySnapshotKey = 'today_snapshot';

  final MethodChannel _channel;

  Future<void> publishTodaySnapshot(
    WidgetDataSummary summary, {
    required String displayMode,
    required bool lockScreenTitlesEnabled,
    required String tapDestination,
  }) async {
    final payload = {
      'id': WidgetDataService.todaySnapshotId,
      'dueTodayCount': summary.dueTodayCount,
      'generatedAt': summary.generatedAt.toIso8601String(),
      'timeZone': summary.timeZone,
      'nextDueTodayTasks': summary.nextDueTodayTasks,
      'displayMode': displayMode,
      'lockScreenTitlesEnabled': lockScreenTitlesEnabled,
      'tapDestination': tapDestination,
    };

    try {
      await _channel.invokeMethod<void>('publishTodaySnapshot', payload);
    } on MissingPluginException {
      // Widget bridge is absent in unit tests and unsupported platforms.
    }
  }
}
