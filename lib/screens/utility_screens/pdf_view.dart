import 'dart:typed_data';

import 'package:bill_mate/components/ui/app_colors.dart';
import 'package:bill_mate/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../components/ui/app_bar.dart';
import '../../services/local/db_service.dart';
import 'generate_sales_pdf.dart';

class SalesPdfPreviewPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedSales;
  final bool includeSummarySheet;

  const SalesPdfPreviewPage(
      {super.key,
      required this.selectedSales,
      required this.includeSummarySheet});

  @override
  State<SalesPdfPreviewPage> createState() => _SalesPdfPreviewPageState();
}

class _SalesPdfPreviewPageState extends State<SalesPdfPreviewPage> {
  Future<Uint8List> _buildPdf(PdfPageFormat format) {
    return generateSalesPdf(widget.selectedSales,
        includeSummary: widget.includeSummarySheet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        title: 'PDF Preview',
        context: context,
        isBackReq: true,
        actionsDefined: [],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.kPrimaryLightBg,
              ),
              child: PdfPreview(
                build: _buildPdf,
                useActions: true,
                canChangePageFormat: true,
                canChangeOrientation: true,
                pdfFileName: 'sales_invoice.pdf',
                allowPrinting: true,
                allowSharing: true,
                padding: const EdgeInsets.all(16),
                previewPageMargin: const EdgeInsets.all(8),
                dynamicLayout: true,
                scrollViewDecoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                onPrinted: (context) {
                  _markSalesAsPrinted();
                  navigateUntil(context,AppRoutes.home);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _markSalesAsPrinted() async {
    for (var sale in widget.selectedSales) {
      final saleId = sale['id'];
      await DatabaseHelper().markSaleAsPrinted(saleId);
    }
  }
}
