import 'package:flutter/material.dart';
import 'package:simulador_parcelamento_pdf/src/frontend/pages/result_page.dart';

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
      return 'Entre com um valor';
    }
    if (!currencyRegex.hasMatch(value)) {
      return 'Entre com um valor numérico';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    String logo = 'logo';
    final TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Simulador de parcelamento'),
        leading: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Hero(
            tag: logo,
            child: Image.asset('assets/images/logo-escritorio-min.png'),
          ),
        ),
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
                      controller: controller,
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
                              builder: (context) => ResultPage(
                                valorInserido: double.parse(
                                  valorInserido!.replaceAll(',', '.'),
                                ),
                              ),
                            ),
                          );
                          controller.clear();
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ResultPage(
                                  valorInserido: double.parse(valorInserido!)),
                            ),
                          );
                          controller.clear();
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
