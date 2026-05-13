import 'package:flutter/material.dart';

import '../../app/theme.dart';

Future<T?> showFlowBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: false,
    useRootNavigator: true,
    barrierColor: Colors.black.withValues(alpha: 0.82),
    backgroundColor: Colors.transparent,
    builder: builder,
  );
}

class FlowBottomSheetSurface extends StatelessWidget {
  const FlowBottomSheetSurface({
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(16, 24, 16, 20),
    this.height,
    this.useKeyboardInset = true,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? height;
  final bool useKeyboardInset;

  @override
  Widget build(BuildContext context) {
    final content = height == null
        ? child
        : SizedBox(width: double.infinity, height: height, child: child);
    return Padding(
      padding: EdgeInsets.only(
        bottom: useKeyboardInset ? MediaQuery.viewInsetsOf(context).bottom : 0,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: padding,
        child: SafeArea(top: false, child: content),
      ),
    );
  }
}
