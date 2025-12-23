import 'dart:developer';
import 'dart:io';
import 'package:intl/intl.dart';

class Utils {
  static getGreting() {
    var time = DateFormat.jm().format(DateTime.now());
    var hour = DateFormat.H().format(DateFormat("hh").parse(time));
    if (time.contains('AM')) {
      return 'Morning';
    } else if (int.parse(hour) <= 3 && time.contains('PM')) {
      return 'Afternoon';
    } else if (int.parse(hour) >= 4 && time.endsWith('PM')) {
      return 'Evening';
    }
  }

  static formatPrice({value}) {
    final formatCurrency = NumberFormat.simpleCurrency(
        locale: Platform.localeName, name: 'NGN', decimalDigits: 0);
    log(formatCurrency.format(double.parse(value)).toString());
    return formatCurrency.format(double.parse(value));
  }

  static ({String month, String day, String date}) formatDate({value}) {
    var time = DateTime.parse(value);
    log(value.toString());
    final month = DateFormat.MMMM().format(time);
    final date = DateFormat.d().format(time); // Day of month
    final day = DateFormat.E().format(time);
    return (month: month, date: date, day: day);
  }

  static formatTime({value}) {
    DateTime time = DateFormat("HH:mm:ss").parse(value);
    return DateFormat('h:mm a').format(time);
  }
}
