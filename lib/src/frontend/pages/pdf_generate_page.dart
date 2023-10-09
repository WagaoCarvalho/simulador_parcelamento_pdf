import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:simulador_parcelamento_pdf/src/frontend/utils/format_date.dart';

import '../utils/util.dart';

class PdfGeneratePage extends StatefulWidget {
  const PdfGeneratePage(
      {super.key, required this.gridData, required this.totalValue});

  final List<Map<String, dynamic>> gridData;
  final String totalValue;

  @override
  State<PdfGeneratePage> createState() => _PdfGeneratePageState();
}

class _PdfGeneratePageState extends State<PdfGeneratePage> {
  PrintingInfo? printingInfo;
  Uint8List? _logoBytes;
  Uint8List? _bgShapeBytes;
  static const _darkColor = PdfColors.blueGrey800;
  final PdfColor baseColor = PdfColors.blueGrey800;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final info = await Printing.info();

    setState(() {
      printingInfo = info;
    });

    final logoByteData = await rootBundle.load('assets/images/logo.png');
    _logoBytes = logoByteData.buffer.asUint8List();
    final bgShape = await rootBundle.load('assets/images/invoice.png');
    _bgShapeBytes = bgShape.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDF')),
      body: PdfPreview(
        maxPageWidth: MediaQuery.of(context).size.width * 0.70,
        build: (PdfPageFormat format) async {
          return await _generatePdf(format);
        },
        actions: const [
          if (!kIsWeb)
            PdfPreviewAction(
              icon: Icon(Icons.save),
              onPressed: saveAsFile,
            )
        ],
        onPrinted: showPrintedToast,
        onShared: showSharedToast,
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          format,
          await PdfGoogleFonts.robotoRegular(),
          await PdfGoogleFonts.robotoBold(),
          await PdfGoogleFonts.robotoItalic(),
        ),
        header: _buildHeader,
        footer: _buildFooter,
        build: (context) => [
          _contentTable(context),
          pw.SizedBox(height: 20),
        ],
      ),
    );

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
                    child: _logoBytes != null
                        ? pw.Image(
                            pw.MemoryImage(_logoBytes!),
                          )
                        : pw.PdfLogo(),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.only(left: 20, bottom: 20),
                    alignment: pw.Alignment.topRight,
                    height: 5,
                    child: pw.DefaultTextStyle(
                      style: const pw.TextStyle(
                        color: _darkColor,
                        fontSize: 12,
                      ),
                      child: pw.Text('Data: ${formatDate(DateTime.now())}'),
                    ),
                  ),
                  pw.Container(
                    height: 35,
                    padding:
                        const pw.EdgeInsets.only(left: 20, top: 5, bottom: 5),
                    alignment: pw.Alignment.topRight,
                    child: pw.Text(
                      'Parcelamento',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                  ),
                  pw.Container(
                    alignment: pw.Alignment.topRight,
                    child: pw.Text(
                      widget.totalValue,
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Container(
                    height: 35,
                    padding: const pw.EdgeInsets.only(
                      left: 20,
                      top: 5,
                      bottom: 5,
                    ),
                    alignment: pw.Alignment.bottomCenter,
                    child: pw.Row(children: [
                      pw.Text(
                        'Endereço: ',
                        style: pw.TextStyle(
                          color: baseColor,
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      pw.Text(
                        'Rua Ramal dos Menezes Nº 582 - Vila Romero - São Paulo - SP - CEP 02469-070',
                        style: pw.TextStyle(
                          color: baseColor,
                          fontSize: 10,
                        ),
                      )
                    ]),
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
    return pw.Container();
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
        child: _logoBytes != null
            ? pw.Image(
                pw.MemoryImage(_bgShapeBytes!),
              )
            : pw.PdfLogo(),
      ),
    );
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'Modalidade',
      'Parcelas',
      'Valor da Parcela',
      'Valor Total',
    ];

    return pw.TableHelper.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: const pw.BoxDecoration(
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
        color: PdfColors.blueGrey700,
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
        color: PdfColors.white,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: PdfColors.blueGrey800,
        fontSize: 12,
      ),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.blueGrey,
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        widget.gridData.length,
        (row) => [
          widget.gridData[row]['Modalidade'] ?? '',
          widget.gridData[row]['Parcelas'].toString(),
          widget.gridData[row]['Valor da Parcela'],
          widget.gridData[row]['Valor Total'],
        ],
      ),
    );
  }
}
