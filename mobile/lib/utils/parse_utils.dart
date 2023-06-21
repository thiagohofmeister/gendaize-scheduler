import 'package:intl/intl.dart';

class ParseUtils {
  static String toStringDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  static String toMoney(double value) {
    return NumberFormat.simpleCurrency(locale: "pt-BR").format(value);
  }

  static String minutesToTime(int minutes) {
    return secondsToTime(minutes * 60);
  }

  static String secondsToTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;

    if (hours == 0) {
      return '$minutes minuto${minutes == 1 ? '' : 's'}';
    } else if (minutes == 0) {
      return '$hours hora${hours == 1 ? '' : 's'}';
    }

    return '$hours hora${hours == 1 ? '' : 's'} e $minutes minuto${minutes == 1 ? '' : 's'}';
  }

  static String toStringDistance(int meters) {
    int km = meters ~/ 1000;
    int metersNew = meters % 1000;

    if (km > 0) {
      return '$km,$metersNew km';
    }
    return '$metersNew m';
  }

  static fromMoneyToDouble(String text) {
    return double.parse(text.replaceAll('R\$ ', '').replaceAll(',', '.'));
  }

  static String toPhoneString(String? phone) {
    if (phone == null) {
      return '';
    }

    if (phone.startsWith('+55')) {
      phone = phone.substring(3);
    }

    phone = phone.replaceAll(RegExp(r'\D'), '');

    if (phone.substring(3).length != 9) {
      phone = '${phone.substring(0, 2)}9${phone.substring(2)}';
    }

    return phone;
  }

  static String toPhone(String? phone) {
    if (phone == null) {
      return '';
    }

    return '(${phone.substring(0, 2)}) '
        '${phone.substring(2, 7)}-${phone.substring(7, 11)}';
  }
}
