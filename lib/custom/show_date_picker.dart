import 'package:flutter/material.dart';

/// Shows a dialog containing a Material Design range picker.
///
/// The returned [Future] resolves to the range selected by the user or `null`
/// when the user taps outside the dialog.
Future<DateTimeRange?> showRangePickerDialog({
  required BuildContext context,
  required DateTime maxDate,
  required DateTime minDate,
  double? width,
  double? height,
  DateTime? initialDate,
  DateTime? currentDate,
  DateTimeRange? selectedRange,
  EdgeInsets contentPadding = const EdgeInsets.all(16),
  EdgeInsets padding = const EdgeInsets.all(36),
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  TextStyle? daysOfTheWeekTextStyle,
  TextStyle? enabledCellsTextStyle,
  BoxDecoration enabledCellsDecoration = const BoxDecoration(),
  TextStyle? disabledCellsTextStyle,
  BoxDecoration disabledCellsDecoration = const BoxDecoration(),
  TextStyle? currentDateTextStyle,
  BoxDecoration? currentDateDecoration,
  TextStyle? selectedCellsTextStyle,
  BoxDecoration? selectedCellsDecoration,
  TextStyle? singleSelectedCellTextStyle,
  BoxDecoration? singleSelectedCellDecoration,
  double? slidersSize,
  Color? slidersColor,
  TextStyle? leadingDateTextStyle,
  Color? highlightColor,
  Color? splashColor,
  double? splashRadius,
  bool centerLeadingDate = false,
  String? previousPageSemanticLabel,
  String? nextPageSemanticLabel,
  // PickerType initialPickerType is ignored — not supported by built-in picker
  dynamic initialPickerType,
}) async {
  return showDateRangePicker(
    context: context,
    firstDate: minDate,
    lastDate: maxDate,
    initialDateRange: selectedRange,
    currentDate: currentDate ?? DateTime.now(),
    initialEntryMode: DatePickerEntryMode.calendar,
    barrierColor: barrierColor,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    routeSettings: routeSettings,
    useRootNavigator: useRootNavigator,
    anchorPoint: anchorPoint,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: highlightColor ?? Theme.of(context).colorScheme.primary,
            onPrimary: Colors.white,
            surface: Colors.black,
            onSurface: Colors.white,
          ),
          splashColor: splashColor,
          highlightColor: highlightColor,
        ),
        child: Padding(
          padding: padding,
          child: child!,
        ),
      );
    },
  );
}

/// Builds a widget tree that can depend on the device orientation.
/// Kept for backward compatibility in case it's used elsewhere.
class DeviceOrientationBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, Orientation orientation) builder;

  const DeviceOrientationBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);
    return builder(context, orientation);
  }
}