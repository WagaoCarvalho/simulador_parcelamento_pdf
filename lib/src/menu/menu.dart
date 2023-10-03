import 'dart:async';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';

import '../data.dart';
import '../pages//pdf_page.dart';

const menu = <Menu>[
  //Example('RESUMO', 'resume.dart', generateResume),
  //Example('DOCUMENTO', 'document.dart', generateDocument),
  Menu('SIMULAÇÃO', 'pdf_page.dart', gerarSimulacao),
  //Example('REPORT', 'report.dart', generateReport),
  //Example('CALENDAR', 'calendar.dart', generateCalendar),
  //Example('CERTIFICATE', 'certificate.dart', generateCertificate, true),
];

typedef LayoutCallbackWithData = Future<Uint8List> Function(
    PdfPageFormat pageFormat, CustomData data);

class Menu {
  const Menu(this.name, this.file, this.builder, [this.needsData = false]);

  final String name;

  final String file;

  final LayoutCallbackWithData builder;

  final bool needsData;
}