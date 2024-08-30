
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DateFormatter {
  DateFormatter._();

  static final dayAndMonth = DateFormat('dd.MM', 'en_US');
  static final fullDate = DateFormat('MMMM dd yyyy', 'en_US');
  static final dayMonthTime = DateFormat('dd.MM, HH:mm', 'en_US');
  static final hourMinute = DateFormat('HH:mm', 'en_US');
  static final monthYear = DateFormat('MM.yyyy', 'en_US');
  static final dayMonthYear = DateFormat('dd.MM.yyyy', 'en_US');
  static final fullDateTime = DateFormat('dd MMM yyyy - HH.mm.ss', 'en_US');
  static final month = DateFormat('MMMM', 'en_US');
  static final monthDay = DateFormat('MMM dd', 'en_US');
  static final chartDates = DateFormat('dd-MMM-yy', 'en_US');
}

String monthFromInt(int month) =>
    DateFormatter.month.format(DateTime(0, month));

extension DateFormatting on DateTime {
  String dayAndMonthFull() => DateFormatter.monthDay.format(this);

  String dayAndMonth() => DateFormatter.dayAndMonth.format(this);

  String dayMonthTime() => DateFormatter.dayMonthTime.format(this);

  String dayMonthYear() => DateFormatter.dayMonthYear.format(this);

  String hourMinute() => DateFormatter.hourMinute.format(this);

  String fullDate() => DateFormatter.fullDate.format(this);

  String fullDateTime() => DateFormatter.fullDateTime.format(this);

  String monthYear() => DateFormatter.monthYear.format(this);

  String chartDates() => DateFormatter.chartDates.format(this);

  String fromDifferenceInDays(int differenceInDays) {
    if (differenceInDays < 2) {
      return hourMinute();
    } else if (differenceInDays < 365) {
      return dayAndMonth();
    } else {
      return monthYear();
    }
  }

  DateTime toDateOnly() => DateTime(year, month, day);

  String capitalizeMonth() {
    final fullDate = DateFormatter.dayMonthYear.format(this).split(' ');
    fullDate[1] = fullDate[1].capitalize();
    return fullDate.join(' ');
  }
}

extension RangeFormatter on DateTimeRange {
  String toRangeString() {
    final String start = DateFormatter.dayMonthYear.format(this.start);
    final String end = DateFormatter.dayMonthYear.format(this.end);
    return '$start - $end';
  }
}

class NumberFormatter {
  static final twoDigits = NumberFormat('###,##0.00', 'en_US');
}

extension NumberFormatting on num {
  String twoDigits() =>
      NumberFormatter.twoDigits.format(this).replaceAll(',', ' ');
}

extension StringFormatting on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

