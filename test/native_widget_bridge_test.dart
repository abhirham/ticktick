import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flowtask/features/widget/data/native_widget_bridge.dart';
import 'package:flowtask/features/widget/data/widget_data_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'publishes the native widget payload over the platform channel',
    () async {
      const channel = MethodChannel('flowtask/widget_bridge.test');
      final calls = <MethodCall>[];
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

      messenger.setMockMethodCallHandler(channel, (call) async {
        calls.add(call);
        return null;
      });
      addTearDown(() => messenger.setMockMethodCallHandler(channel, null));

      final bridge = NativeWidgetBridge(channel: channel);
      final summary = WidgetDataSummary(
        dueTodayCount: 2,
        generatedAt: DateTime(2026, 5, 12, 9, 30),
        timeZone: 'America/Toronto',
        nextDueTodayTasks: const ['Pay rent', 'Call broker'],
      );

      await bridge.publishTodaySnapshot(
        summary,
        displayMode: 'countAndTitles',
        lockScreenTitlesEnabled: true,
        tapDestination: 'calendar',
      );

      expect(calls, hasLength(1));
      expect(calls.single.method, 'publishTodaySnapshot');

      final payload = Map<String, Object?>.from(calls.single.arguments as Map);
      expect(payload['id'], WidgetDataService.todaySnapshotId);
      expect(payload['dueTodayCount'], 2);
      expect(payload['generatedAt'], '2026-05-12T09:30:00.000');
      expect(payload['timeZone'], 'America/Toronto');
      expect(payload['nextDueTodayTasks'], ['Pay rent', 'Call broker']);
      expect(payload['displayMode'], 'countAndTitles');
      expect(payload['lockScreenTitlesEnabled'], isTrue);
      expect(payload['tapDestination'], 'calendar');
    },
  );

  test(
    'ignores missing native widget plugins on unsupported targets',
    () async {
      const channel = MethodChannel('flowtask/widget_bridge.missing');
      final bridge = NativeWidgetBridge(channel: channel);

      await bridge.publishTodaySnapshot(
        WidgetDataSummary(
          dueTodayCount: 0,
          generatedAt: DateTime(2026, 5, 12, 9, 30),
          timeZone: 'America/Toronto',
          nextDueTodayTasks: const [],
        ),
        displayMode: 'countOnly',
        lockScreenTitlesEnabled: false,
        tapDestination: 'today',
      );
    },
  );
}
