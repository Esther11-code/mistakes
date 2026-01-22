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
    final date = DateFormat.d().format(time); 
    final day = DateFormat.E().format(time);
    return (month: month, date: date, day: day);
  }

  static String formatdate(String? dateTimeString) {
    if (dateTimeString == null) return 'Unknown';

    try {
      final dateTime = DateTime.parse(dateTimeString);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      
      return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
    } catch (e) {
      return 'Unknown';
    }
  }


  static formatTime({value}) {
    DateTime time = DateFormat("HH:mm:ss").parse(value);
    return DateFormat('h:mm a').format(time);
  }

  static String getTimeAgo(String? dateTimeString) {
    if (dateTimeString == null) return 'Unknown';

    try {
      final dateTime = DateTime.parse(dateTimeString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 365) {
        final years = (difference.inDays / 365).floor();
        return '$years ${years == 1 ? 'year' : 'years'} ago';
      } else if (difference.inDays > 30) {
        final months = (difference.inDays / 30).floor();
        return '$months ${months == 1 ? 'month' : 'months'} ago';
      } else if (difference.inDays > 0) {
        return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}
