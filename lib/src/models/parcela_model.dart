import 'package:simulador_parcelamento_pdf/src/utils/format_currency.dart';

class Parcela {
  const Parcela(
    this.modalidade,
    this.parcelas,
    this.valorParcelas,
    this.valorTotal,
  );

  final String modalidade;
  final int parcelas;
  final double valorParcelas;
  final double valorTotal;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return modalidade;
      case 1:
        return parcelas.toString();
      case 2:
        return formatCurrency(valorParcelas);
      case 3:
        return formatCurrency(valorTotal);
    }
    return '';
  }
}