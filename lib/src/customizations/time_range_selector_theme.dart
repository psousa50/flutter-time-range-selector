import 'package:flutter/material.dart';

class TimeRangeSelectorThemeData {
  final Color? primaryColor;
  final Color? onPrimaryColor;
  final Color? selectedColor;
  final Color? activeHandlerColor;
  final Color? handlerColor;
  final Color? activeDigitalColor;
  final Color? dayColor;
  final Color? dayLineColor;
  final Color? nightColor;
  final Color? nightLineColor;
  final Color? horizonColor;
  final Color? ticksColor;
  final TextStyle? labelTextStyle;
  final TextStyle? smallLabelTextStyle;
  final TextStyle? timeDisplayStyle;
  final TextStyle? timeTextDisplayStyle;
  final double? handlerRadius;
  final EdgeInsets? margin;

  const TimeRangeSelectorThemeData({
    this.primaryColor,
    this.onPrimaryColor,
    this.selectedColor,
    this.activeHandlerColor,
    this.handlerColor,
    this.activeDigitalColor,
    this.dayColor,
    this.dayLineColor,
    this.nightColor,
    this.nightLineColor,
    this.horizonColor,
    this.ticksColor,
    this.labelTextStyle,
    this.smallLabelTextStyle,
    this.timeDisplayStyle,
    this.timeTextDisplayStyle,
    this.handlerRadius,
    this.margin,
  });

  TimeRangeSelectorThemeData mergeDefaults(
      TimeRangeSelectorThemeData other, ThemeData theme) {
    var primaryColor = this.primaryColor ?? theme.primaryColor;
    var onPrimaryColor = this.onPrimaryColor ??
        (ThemeData.estimateBrightnessForColor(primaryColor) == Brightness.light
            ? Colors.black
            : Colors.white);
    var selectedColor =
        this.selectedColor ?? theme.colorScheme.secondaryVariant;

    var labelTextStyle = TextStyle(
      color: ticksColor,
      fontSize: 16,
    ).merge(this.labelTextStyle);

    var smallLabelTextStyle = labelTextStyle.merge(
      TextStyle(
        fontSize: 12,
      ).merge(this.smallLabelTextStyle),
    );

    var timeDisplayStyle = TextStyle(
      color: onPrimaryColor,
      fontSize: 26,
      fontWeight: FontWeight.bold,
    ).merge(this.timeDisplayStyle);

    var timeTextDisplayStyle = timeDisplayStyle
        .merge(TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ))
        .merge(this.timeTextDisplayStyle);

    var handlerRadius = this.handlerRadius ?? 20;
    return copyWith(
        primaryColor: primaryColor,
        onPrimaryColor: onPrimaryColor,
        selectedColor: selectedColor,
        activeHandlerColor:
            this.activeHandlerColor ?? theme.colorScheme.onPrimary,
        handlerColor: this.handlerColor ?? theme.colorScheme.secondary,
        activeDigitalColor: this.activeDigitalColor ?? selectedColor,
        dayColor: this.dayColor ?? Colors.blue[100],
        dayLineColor: this.dayLineColor ?? Colors.black,
        nightColor: this.nightColor ?? Colors.black,
        nightLineColor: nightLineColor ?? Colors.white,
        horizonColor: this.horizonColor ?? Colors.grey,
        ticksColor: this.ticksColor ?? Colors.grey[300],
        labelTextStyle: labelTextStyle,
        smallLabelTextStyle: smallLabelTextStyle,
        timeTextDisplayStyle: timeTextDisplayStyle,
        timeDisplayStyle: timeDisplayStyle,
        handlerRadius: handlerRadius,
        margin: this.margin ??
            EdgeInsets.symmetric(
              horizontal: handlerRadius,
              vertical: handlerRadius,
            ));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TimeRangeSelectorThemeData &&
        other.primaryColor == primaryColor &&
        other.onPrimaryColor == onPrimaryColor &&
        other.selectedColor == selectedColor &&
        other.activeHandlerColor == activeHandlerColor &&
        other.handlerColor == handlerColor &&
        other.activeDigitalColor == activeDigitalColor &&
        other.dayColor == dayColor &&
        other.dayLineColor == dayLineColor &&
        other.nightColor == nightColor &&
        other.nightLineColor == nightLineColor &&
        other.horizonColor == horizonColor &&
        other.ticksColor == ticksColor &&
        other.labelTextStyle == labelTextStyle &&
        other.smallLabelTextStyle == smallLabelTextStyle &&
        other.timeDisplayStyle == timeDisplayStyle &&
        other.timeTextDisplayStyle == timeTextDisplayStyle &&
        other.handlerRadius == handlerRadius &&
        other.margin == margin;
  }

  @override
  int get hashCode {
    return primaryColor.hashCode ^
        onPrimaryColor.hashCode ^
        selectedColor.hashCode ^
        activeHandlerColor.hashCode ^
        handlerColor.hashCode ^
        activeDigitalColor.hashCode ^
        dayColor.hashCode ^
        dayLineColor.hashCode ^
        nightColor.hashCode ^
        nightLineColor.hashCode ^
        horizonColor.hashCode ^
        ticksColor.hashCode ^
        labelTextStyle.hashCode ^
        smallLabelTextStyle.hashCode ^
        timeDisplayStyle.hashCode ^
        timeTextDisplayStyle.hashCode ^
        handlerRadius.hashCode ^
        margin.hashCode;
  }

  TimeRangeSelectorThemeData copyWith({
    Color? primaryColor,
    Color? onPrimaryColor,
    Color? selectedColor,
    Color? activeHandlerColor,
    Color? handlerColor,
    Color? activeDigitalColor,
    Color? dayColor,
    Color? dayLineColor,
    Color? nightColor,
    Color? nightLineColor,
    Color? horizonColor,
    Color? ticksColor,
    TextStyle? labelTextStyle,
    TextStyle? smallLabelTextStyle,
    TextStyle? timeDisplayStyle,
    TextStyle? timeTextDisplayStyle,
    double? handlerRadius,
    EdgeInsets? margin,
  }) {
    return TimeRangeSelectorThemeData(
      primaryColor: primaryColor ?? this.primaryColor,
      onPrimaryColor: onPrimaryColor ?? this.onPrimaryColor,
      selectedColor: selectedColor ?? this.selectedColor,
      activeHandlerColor: activeHandlerColor ?? this.activeHandlerColor,
      handlerColor: handlerColor ?? this.handlerColor,
      activeDigitalColor: activeDigitalColor ?? this.activeDigitalColor,
      dayColor: dayColor ?? this.dayColor,
      dayLineColor: dayLineColor ?? this.dayLineColor,
      nightColor: nightColor ?? this.nightColor,
      nightLineColor: nightLineColor ?? this.nightLineColor,
      horizonColor: horizonColor ?? this.horizonColor,
      ticksColor: ticksColor ?? this.ticksColor,
      labelTextStyle: labelTextStyle ?? this.labelTextStyle,
      smallLabelTextStyle: smallLabelTextStyle ?? this.smallLabelTextStyle,
      timeDisplayStyle: timeDisplayStyle ?? this.timeDisplayStyle,
      timeTextDisplayStyle: timeTextDisplayStyle ?? this.timeTextDisplayStyle,
      handlerRadius: handlerRadius ?? this.handlerRadius,
      margin: margin ?? this.margin,
    );
  }
}

class TimeRangeSelectorTheme extends InheritedTheme {
  final TimeRangeSelectorThemeData data;

  const TimeRangeSelectorTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  static TimeRangeSelectorThemeData of(BuildContext context) {
    final TimeRangeSelectorTheme? timeRangeSelectorTheme =
        context.dependOnInheritedWidgetOfExactType<TimeRangeSelectorTheme>();
    return timeRangeSelectorTheme?.data ?? TimeRangeSelectorThemeData();
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return TimeRangeSelectorTheme(data: data, child: child);
  }

  @override
  bool updateShouldNotify(TimeRangeSelectorTheme oldWidget) =>
      data != oldWidget.data;
}
