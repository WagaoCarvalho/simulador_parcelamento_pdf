import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  final format = DateFormat('dd-MM-yyyy – kk:mm');
  return format.format(date);
}
