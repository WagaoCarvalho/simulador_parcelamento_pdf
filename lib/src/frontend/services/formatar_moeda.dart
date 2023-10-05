import 'package:intl/intl.dart';

class FormatarMoeda {
  static String formatarMoeda(double valor) {
    final moneyFormatter =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return moneyFormatter.format(valor);
  }
}