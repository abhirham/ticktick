import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';
import 'theme.dart';

class FlowTaskApp extends ConsumerWidget {
  const FlowTaskApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'FlowTask',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: buildFlowTaskTheme(Brightness.light),
      darkTheme: buildFlowTaskTheme(Brightness.dark),
      routerConfig: router,
    );
  }
}
