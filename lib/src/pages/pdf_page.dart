import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:simulador_parcelamento_pdf/src//models/parcela_model.dart';
import 'package:simulador_parcelamento_pdf/src//utils/format_currency.dart';

late final List<Parcela> gridData;

Future<Uint8List> gerarSimulacao(PdfPageFormat pageFormat) async {
  final invoice = Invoice(
    //invoiceNumber: '982347',
    products: gridData,
    //nomeEmpresa: 'Despachante Mandaqui',
    customerAddress:
        'Rua Ramal dos Menezes Nº 582 \n Vila Romero - São Paulo - SP - 02469-000',
    //paymentInfo:'4509 Wiseman Street\nKnoxville, Tennessee(TN), 37929\n865-372-0425',
    tax: .15,
    baseColor: PdfColors.blueGrey700,
    accentColor: PdfColors.blueGrey,
  );

  return await invoice.buildPdf(pageFormat);
}

class Invoice {
  Invoice({
    required this.products,
    //required this.nomeEmpresa,
    required this.customerAddress,
    //required this.invoiceNumber,
    required this.tax,
    //required this.paymentInfo,
    required this.baseColor,
    required this.accentColor,
  });

  final List<Parcela> products;

  //final String nomeEmpresa;
  final String customerAddress;

  //final String invoiceNumber;
  final double tax;

  //final String paymentInfo;
  final PdfColor baseColor;
  final PdfColor accentColor;

  static const _darkColor = PdfColors.blueGrey800;
  static const _lightColor = PdfColors.white;

  PdfColor get _baseTextColor => baseColor.isLight ? _lightColor : _darkColor;

  double get _total =>
      products.map<double>((p) => p.valorTotal).reduce((a, b) => a + b);

  double get _grandTotal => _total * (1 + tax);

  String? _logo;

  String? _bgShape;

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    // Create a PDF document.
    final doc = pw.Document();

    _logo = await rootBundle.loadString('assets/images/logo.svg');
    _bgShape = await rootBundle.loadString('assets/images/invoice.svg');

    // Add page to the PDF
    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          pageFormat,
          await PdfGoogleFonts.robotoRegular(),
          await PdfGoogleFonts.robotoBold(),
          await PdfGoogleFonts.robotoItalic(),
        ),
        header: _buildHeader,
        footer: _buildFooter,
        build: (context) => [
          _contentHeader(context),
          _contentTable(context),
          pw.SizedBox(height: 20),
        ],
      ),
    );

    // Return the PDF file content
    return doc.save();
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Container(
                    alignment: pw.Alignment.topLeft,
                    padding: const pw.EdgeInsets.only(bottom: 8, left: 10),
                    height: 45,
                    child:
                        _logo != null ? pw.SvgImage(svg: _logo!) : pw.PdfLogo(),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.only(left: 20, bottom: 10),
                    alignment: pw.Alignment.topRight,
                    height: 5,
                    child: pw.DefaultTextStyle(
                      style: const pw.TextStyle(
                        color: _darkColor,
                        fontSize: 12,
                      ),
                      child: pw.Text('Data: ${_formatDate(DateTime.now())}'),
                    ),
                  ),
                  pw.Container(
                    height: 35,
                    padding:
                        const pw.EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    alignment: pw.Alignment.bottomRight,
                    child: pw.Text(
                      'Parcelamento',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.white,
          ),
        ),
      ],
    );
  }

  pw.PageTheme _buildTheme(
      PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.SvgImage(svg: _bgShape!),
      ),
    );
  }

  pw.Widget _contentHeader(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Row(
            children: [
              pw.Expanded(
                child: pw.Container(
                  height: 30,
                  child: pw.RichText(
                      text: pw.TextSpan(
                          text: 'Endereço: ',
                          style: pw.TextStyle(
                            color: _darkColor,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 10,
                          ),
                          children: [
                        pw.TextSpan(
                          text: customerAddress,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            fontSize: 9,
                          ),
                        ),
                      ])),
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.Container(
            margin: const pw.EdgeInsets.symmetric(horizontal: 5),
            height: 30,
            child: pw.FittedBox(
              child: pw.Text(
                'Valor dos débitos: ${formatCurrency(_grandTotal)}',
                style: pw.TextStyle(
                    color: baseColor,
                    fontStyle: pw.FontStyle.italic,
                    fontWeight: pw.FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'Modalidade',
      'Parcelas',
      'Valor das parcelas',
      'Valor total',
    ];

    return pw.TableHelper.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: baseColor,
      ),
      headerHeight: 25,
      cellHeight: 28,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerLeft,
        3: pw.Alignment.centerLeft,
      },
      headerStyle: pw.TextStyle(
        color: _baseTextColor,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 12,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: accentColor,
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        products.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => products[row].getIndex(col),
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  final format = DateFormat('dd-MM-yyyy – kk:mm');
  return format.format(date);
}