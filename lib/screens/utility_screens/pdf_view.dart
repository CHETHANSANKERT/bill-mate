
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../utils/generate_sales_pdf.dart';

class PdfPreviewScreen extends StatelessWidget {
  final List<Map<String, dynamic>> selectedSales;

  const PdfPreviewScreen({super.key, required this.selectedSales});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Preview')),
      body: PdfPreview(
        build: (format) => generateSalesPdf(selectedSales),
        useActions: true,
        canChangePageFormat: true,
        canDebug: false,
        pdfFileName: 'sales_invoice.pdf',
      ),
    );
  }
}