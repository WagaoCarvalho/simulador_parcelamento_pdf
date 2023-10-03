import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../data.dart';
import '../menu/menu.dart';
import '../services/services.dart';

class PdfApp extends StatefulWidget {
  const PdfApp({Key? key}) : super(key: key);

  @override
  PdfAppState createState() {
    return PdfAppState();
  }
}

class PdfAppState extends State<PdfApp> with SingleTickerProviderStateMixin {
  int _tab = 0;
  TabController? _tabController;

  PrintingInfo? printingInfo;

  final _data = const CustomData();

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _init() async {
    final info = await Printing.info();

    _tabController = TabController(
      vsync: this,
      length: menu.length,
      initialIndex: _tab,
    );
    _tabController!.addListener(() {
      if (_tab != _tabController!.index) {
        setState(() {
          _tab = _tabController!.index;
        });
      }
    });

    setState(() {
      printingInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    pw.RichText.debug = true;

    if (_tabController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final actions = <PdfPreviewAction>[
      if (!kIsWeb)
        const PdfPreviewAction(
          icon: Icon(Icons.save),
          onPressed: saveAsFile,
        )
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulação de parcelamento'),
        bottom: TabBar(
          controller: _tabController,
          tabs: menu.map<Tab>((e) => Tab(text: e.name)).toList(),
          isScrollable: true,
        ),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        build: (format) => menu[_tab].builder(format, _data),
        actions: actions,
        onPrinted: showPrintedToast,
        onShared: showSharedToast,
      ),
    );
  }
}