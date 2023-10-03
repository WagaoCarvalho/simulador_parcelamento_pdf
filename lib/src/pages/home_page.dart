import 'package:flutter/material.dart';
import 'package:simulador_parcelamento_pdf/src/pages/result_pdf_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  RegExp currencyRegex = RegExp(r'^(\d+(?:[.,]\d{2})?|\d+)$');

  String? valorInserido;

  String? validateCurrency(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    if (!currencyRegex.hasMatch(value)) {
      return 'Please enter a valid Brazilian currency amount (R\$ X.XX or R\$ X,XXX.XX)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Simulador de parcelamento'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Valor',
                      ),
                      validator: validateCurrency,
                      onSaved: (value) {
                        valorInserido = value;
                      },
                      onFieldSubmitted: (value) {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ResultPDFPage(
                                valorInserido: double.parse(valorInserido!),
                              ),
                            ),
                          );
                          _controller.clear();
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ResultPDFPage(
                                  valorInserido: double.parse(valorInserido!)),
                            ),
                          );
                          _controller.clear();
                        }
                      },
                      child: const Text('Simular Parcelamento'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}