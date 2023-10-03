import 'package:simulador_parcelamento_pdf/src/services/formatar_moeda.dart';

class CalculadoraParcelas {
  static List<Map<String, dynamic>> calcularParcelas(
      double inputValue, double taxaRetorno) {
    List<Map<String, dynamic>> gridData = [];

    double taxaCredito01 = inputValue * (1 + 3.90 / 100);
    double taxaCredito02 = inputValue * (1 + 5.10 / 100);
    double taxaCredito03 = inputValue * (1 + 5.94 / 100);
    double taxaCredito04 = inputValue * (1 + 6.80 / 100);
    double taxaCredito05 = inputValue * (1 + 7.67 / 100);
    double taxaCredito06 = inputValue * (1 + 8.55 / 100);
    double taxaCredito07 = inputValue * (1 + 9.78 / 100);
    double taxaCredito08 = inputValue * (1 + 10.70 / 100);
    double taxaCredito09 = inputValue * (1 + 11.63 / 100);
    double taxaCredito10 = inputValue * (1 + 12.57 / 100);
    double taxaCredito11 = inputValue * (1 + 13.53 / 100);
    double taxaCredito12 = inputValue * (1 + 14.51 / 100);
    double taxaCredito13 = inputValue * (1 + 15.51 / 100);
    double taxaCredito14 = inputValue * (1 + 16.52 / 100);
    double taxaCredito15 = inputValue * (1 + 17.55 / 100);
    double taxaCredito16 = inputValue * (1 + 18.60 / 100);
    double taxaCredito17 = inputValue * (1 + 19.67 / 100);
    double taxaCredito18 = inputValue * (1 + 20.76 / 100);

    // Calcular as parcelas e preencher os dados para a tabela
    double parcelValue = 0.0;
    for (int i = 1; i <= 18; i++) {
      if (i == 1) {
        parcelValue = taxaCredito01 / i;
      } else if (i == 2) {
        parcelValue = taxaCredito02 / i;
      } else if (i == 3) {
        parcelValue = taxaCredito03 / i;
      } else if (i == 4) {
        parcelValue = taxaCredito04 / i;
      } else if (i == 5) {
        parcelValue = taxaCredito05 / i;
      } else if (i == 6) {
        parcelValue = taxaCredito06 / i;
      } else if (i == 7) {
        parcelValue = taxaCredito07 / i;
      } else if (i == 8) {
        parcelValue = taxaCredito08 / i;
      } else if (i == 9) {
        parcelValue = taxaCredito09 / i;
      } else if (i == 10) {
        parcelValue = taxaCredito10 / i;
      } else if (i == 11) {
        parcelValue = taxaCredito11 / i;
      } else if (i == 12) {
        parcelValue = taxaCredito12 / i;
      } else if (i == 13) {
        parcelValue = taxaCredito13 / i;
      } else if (i == 14) {
        parcelValue = taxaCredito14 / i;
      } else if (i == 15) {
        parcelValue = taxaCredito15 / i;
      } else if (i == 16) {
        parcelValue = taxaCredito16 / i;
      } else if (i == 17) {
        parcelValue = taxaCredito17 / i;
      } else if (i == 18) {
        parcelValue = taxaCredito18 / i;
      }

      double totalValue = parcelValue * i;
      gridData.add({
        'Modalidade': 'Crédito',
        'Parcelas': i,
        'Valor da Parcela':
            FormatarMoeda.formatarMoeda(parcelValue * (1 + taxaRetorno / 100)),
        'Valor Total':
            FormatarMoeda.formatarMoeda(totalValue * (1 + taxaRetorno / 100)),
      });
    }

    return gridData;
  }
}