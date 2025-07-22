import 'dart:io';
import 'dart:typed_data';
import 'package:bill_mate/components/button/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import '../../components/ui/app_bar.dart';
import '../../routes/app_pages.dart';
import '../../services/local/db_service.dart';
import 'generate_sales_pdf.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_plus/share_plus.dart';

class SalesPdfPreviewPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedSales;
  final bool includeSummarySheet;

  const SalesPdfPreviewPage({
    super.key,
    required this.selectedSales,
    required this.includeSummarySheet,
  });

  @override
  State<SalesPdfPreviewPage> createState() => _SalesPdfPreviewPageState();
}

class _SalesPdfPreviewPageState extends State<SalesPdfPreviewPage> {
  File? _pdfFile;

  @override
  void initState() {
    super.initState();
    _generateAndLoadPdf();
  }

  Future<void> _generateAndLoadPdf() async {
    final Uint8List pdfBytes = await generateSalesPdf(
      widget.selectedSales,
      includeSummary: widget.includeSummarySheet,
    );
    final tempDir = await getTemporaryDirectory();
    if (!await tempDir.exists()) {
      await tempDir.create(recursive: true);
    }
    final file = File('${tempDir.path}/sales_preview.pdf');
    await file.writeAsBytes(pdfBytes);

    setState(() {
      _pdfFile = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        title: 'PDF Preview',
        context: context,
        isBackReq: true,
      ),
      body: _pdfFile == null
          ? const Center(child: CircularProgressIndicator())
          : PDFView(
        filePath: _pdfFile!.path,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: true,
        pageSnap: true,
        defaultPage: 0,
        fitPolicy: FitPolicy.BOTH,
        preventLinkNavigation: false,
        onRender: (_pages) {},
        onError: (error) {},
        onPageError: (page, error) {},
        onViewCreated: (controller) {},
        onPageChanged: (page, total) {},
      ),
      // : const SizedBox.shrink(),
      floatingActionButton: PrimaryButton(
          buttonName: 'Save',
          kSize: Size(0.4.sw, 50.h),
          onClickfunction: () async {
            if (_pdfFile != null) {
              /// mark the selected sales as printed
              await _markSalesAsPrinted();
              /// send the pdf to whatsapp
              await sharePdf(_pdfFile!.readAsBytesSync(), 'sale_invoice.pdf');
            }
            navigateUntil(context, AppRoutes.home);
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  /// making it as already printed
  Future<void> _markSalesAsPrinted() async {
    for (var sale in widget.selectedSales) {
      final saleId = sale['id'];
      await DatabaseHelper().markSaleAsPrinted(saleId);
    }
  }

  /// share the pdf in whats app using the share plus module
  Future<void> sharePdf(Uint8List pdfBytes, String filename) async {
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$filename');
    await file.writeAsBytes(pdfBytes, flush: true);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        text: 'Here is your PDF file',
      ),
    );
  }
}

