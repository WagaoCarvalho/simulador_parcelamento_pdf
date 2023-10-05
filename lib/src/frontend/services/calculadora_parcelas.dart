import 'package:simulador_parcelamento_pdf/src/frontend/services/formatar_moeda.dart';

class CalculadoraParcelas {
  static List<Map<String, dynamic>> calcularParcelas(
      double inputValue, double taxaRetorno) {
    List<Map<String, dynamic>> gridData = [];

    // Validar taxa de retorno
    if (taxaRetorno < 0) {
      throw ArgumentError('A taxa de retorno deve ser maior ou igual a zero.');
    }

    if (taxaRetorno == 1) {
      taxaRetorno = 0;
    }

    inputValue = inputValue * (1 + taxaRetorno / 100);

    // Calcular as taxas de juros
    List<double> taxasCredito = [
      inputValue * (1 + 3.90 / 100),
      inputValue * (1 + 5.10 / 100),
      inputValue * (1 + 5.94 / 100),
      inputValue * (1 + 6.80 / 100),
      inputValue * (1 + 7.67 / 100),
      inputValue * (1 + 8.55 / 100),
      inputValue * (1 + 9.78 / 100),
      inputValue * (1 + 10.70 / 100),
      inputValue * (1 + 11.63 / 100),
      inputValue * (1 + 12.57 / 100),
      inputValue * (1 + 13.53 / 100),
      inputValue * (1 + 14.51 / 100),
      inputValue * (1 + 15.51 / 100),
      inputValue * (1 + 16.52 / 100),
      inputValue * (1 + 17.55 / 100),
      inputValue * (1 + 18.60 / 100),
      inputValue * (1 + 19.67 / 100),
      inputValue * (1 + 20.76 / 100),
    ];

    // Calcular as parcelas e preencher os dados para a tabela
    for (int i = 0; i < taxasCredito.length; i++) {
      double parcelValue = taxasCredito[i] / (i + 1);
      double totalValue = parcelValue * (i + 1);

      gridData.add({
        'Modalidade': 'Crédito',
        'Parcelas': i + 1,
        'Valor da Parcela': FormatarMoeda.formatarMoeda(parcelValue),
        'Valor Total': FormatarMoeda.formatarMoeda(totalValue),
      });
    }

    return gridData;
  }
}
