import 'package:flutter/material.dart';
import 'package:simulador_parcelamento_pdf/src/frontend/pages/pdf_generate_page.dart';
import 'package:simulador_parcelamento_pdf/src/frontend/services/calculadora_parcelas.dart';
import 'package:simulador_parcelamento_pdf/src/frontend/services/formatar_moeda.dart';

List<double> list = <double>[1.0, 2.1, 3.1, 4.3];

class ResultPage extends StatefulWidget {
  final double valorInserido;

  const ResultPage({Key? key, required this.valorInserido}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  List<Map<String, dynamic>> gridData = [];
  double taxaRetorno = 2.1;

  @override
  void initState() {
    gridData =
        CalculadoraParcelas.calcularParcelas(widget.valorInserido, taxaRetorno);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
                'Valor Digitado: ${FormatarMoeda.formatarMoeda(widget.valorInserido)}'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<double>(
                  value: taxaRetorno,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (double? value) {
                    setState(() {
                      taxaRetorno = value!;
                      gridData = CalculadoraParcelas.calcularParcelas(
                          widget.valorInserido, taxaRetorno);
                    });
                  },
                  items: list.map<DropdownMenuItem<double>>((double value) {
                    return DropdownMenuItem<double>(
                      value: value,
                      child: value == 1
                          ? Text('Retorno %')
                          : Text('Retorno ${value.toInt()}%'),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  width: 40,
                ),
                ElevatedButton(
                  autofocus: true,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PdfGeneratePage(
                          gridData: gridData,
                          totalValue:
                              'Valor dos débitos: ${FormatarMoeda.formatarMoeda(widget.valorInserido)}',
                        ),
                      ),
                    );
                  },
                  child: const Text('Gerar PDF'),
                )
              ],
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Modalidade')),
                  DataColumn(label: Text('Parcelas')),
                  DataColumn(label: Text('Valor da Parcela')),
                  DataColumn(label: Text('Valor Total')),
                ],
                rows: gridData.map((data) {
                  return DataRow(cells: [
                    DataCell(Text(data['Modalidade'])),
                    DataCell(Text(data['Parcelas'].toString())),
                    DataCell(Text(data['Valor da Parcela'])),
                    DataCell(Text(data['Valor Total'])),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
