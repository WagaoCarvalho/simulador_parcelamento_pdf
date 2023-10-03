import 'package:flutter/material.dart';
import 'package:simulador_parcelamento_pdf/src/services/calculadora_parcelas.dart';
import 'package:simulador_parcelamento_pdf/src/services/formatar_moeda.dart';

List<String> list = <String>['1', '2', '3', '4.3'];

class ResultPDFPage extends StatefulWidget {
  final double valorInserido;

  const ResultPDFPage({Key? key, required this.valorInserido})
      : super(key: key);

  @override
  State<ResultPDFPage> createState() => _ResultPDFPageState();
}

class _ResultPDFPageState extends State<ResultPDFPage> {
  List<Map<String, dynamic>> gridData = [];
  double taxaRetorno = 1.0;

  @override
  void initState() {
    gridData =
        CalculadoraParcelas.calcularParcelas(widget.valorInserido, taxaRetorno);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String dropdownValue = taxaRetorno.toString();

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
                'Valor Digitado: ${FormatarMoeda.formatarMoeda(
                    widget.valorInserido)}'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                      taxaRetorno = double.parse(value);
                      gridData = CalculadoraParcelas.calcularParcelas(
                          widget.valorInserido, taxaRetorno);
                    });
                  },
                  items: list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text('Retorno ${value}'),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  width: 40,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Gerar PDF'),
                )
              ],
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
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