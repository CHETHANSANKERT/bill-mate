import 'package:bill_mate/constants/asset_constants.dart';
import 'package:bill_mate/utils/custon_date_extension.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../../services/local/db_service.dart';

Future<Uint8List> generateSalesPdf(List<Map<String, dynamic>> selectedSales, {bool includeSummary = true}) async {
  final pdf = pw.Document();

  final sriRenukambaLogoByteData = await rootBundle.load(StoreImages.sriRenukambaLogo);

  textKeyValue(String fieldName, String value, {double? valueSize, double? fieldSize}) {
    return pw.Row(children: [
      pw.Text(
        '$fieldName : ',
        style: pw.TextStyle(fontSize: fieldSize ?? 12, color: PdfColors.brown700),
      ),
      pw.Text(value, style: pw.TextStyle(fontSize: valueSize ?? 14)),
    ]);
  }

  rowTextKeyValue(String fieldName1, String value1, String fieldName2, String value2) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        textKeyValue(
          fieldName1,
          value1,
        ),
        textKeyValue(
          fieldName2,
          value2,
        ),
      ],
    );
  }

  /// for the store details page
  double allSaleTotal = 0;
  List<Map<String, dynamic>> storeTotals = [];

  /// for the item details page created
  final Map<String, double> allItems = {};

  for (var sale in selectedSales) {
    final saleId = sale['id'];
    final billingId = sale['billingId'];
    final totalAmount = sale['saleTotal'];
    final storeId = sale['storeId'];
    final storeName = sale['storeName'];
    allSaleTotal += totalAmount;
    storeTotals.add({
      'storeName': storeName,
      'saleTotal': totalAmount,
      'billNumber': billingId,
    });

    final List<Map<String, dynamic>> itemDetails = await DatabaseHelper().getSaleProductsBySaleId(saleId);

    for (var item in itemDetails) {
      final itemName = item['itemName']?.toString();
      final quantity = double.tryParse(item['quantity'].toString()) ?? 0.0;

      if (itemName != null && itemName.isNotEmpty) {
        allItems[itemName] = (allItems[itemName] ?? 0.0) + quantity;
      }
    }

    final Map<String, dynamic>? store = await DatabaseHelper().getStoresById(storeId);
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5.copyWith(
          marginLeft: 16.h,
          marginRight: 24.h,
          marginTop: 16.h,
          marginBottom: 16.h,
        ),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              /// Company & Invoice Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                children: [
                  pw.Image(
                    pw.MemoryImage(sriRenukambaLogoByteData.buffer.asUint8List()),
                    height: 40.h,
                    width: 100.h,
                  ),
                  pw.Text(
                    'SRI RENUKAMBA ENTERPRISES',
                    style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.orange300),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.SizedBox.shrink()
                ],
              ),
              pw.SizedBox(height: 20.h),
              textKeyValue('Store name', storeName, fieldSize: 14, valueSize: 16),
              rowTextKeyValue('Date', DateTime.now().cddmmyyyy, 'Bill No:', billingId.toString()),
              rowTextKeyValue('Area', sale['area'] ?? store?['area'] ?? '', 'Beat', sale['beat'] ?? store?['beat'] ?? ''),

              store?['address'] != null ? textKeyValue('Address', sale['address'] ?? store?['address']) : pw.SizedBox.shrink(),
              store?['mobileNum'] != null
                  ? textKeyValue('Mobile Number', sale['mobileNum'] ?? store?['mobileNum'] ?? '')
                  : pw.SizedBox.shrink(),

              pw.SizedBox(height: 12),

              /// Sale Items Table
              pw.Text('Item Details:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 12),

              pw.TableHelper.fromTextArray(
                border: pw.TableBorder.all(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headers: ['#', 'Product Name', 'Rate', 'Qty', 'Total'],
                cellAlignments: {
                  0: pw.Alignment.center,
                  1: pw.Alignment.centerLeft,
                  2: pw.Alignment.center,
                  3: pw.Alignment.center,
                  4: pw.Alignment.center,
                },
                data: List.generate(itemDetails.length, (index) {
                  final item = itemDetails[index];
                  return [
                    (index + 1).toString(),
                    item['itemName'],
                    '${item['rate'].toStringAsFixed(2)}',
                    item['quantity'],
                    '${item['productTotal']}',
                  ];
                }),
              ),

              pw.SizedBox(height: 20),

              /// Total Summary
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'Total : ',
                    style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(width: 12.w),
                  pw.Text(
                    '$totalAmount',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  if (includeSummary) {
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a5.copyWith(
          marginLeft: 16.h,
          marginRight: 16.h,
          marginTop: 16.h,
          marginBottom: 16.h,
        ),
        build: (context) => [
          pw.Header(
            level: 1,
            child: pw.Text('Store-wise Sales Summary on: ${DateTime.now().cddmmyyyy}',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          ),
          // pw.TableHelper.fromTextArray(
          //   headers: ['Store Name', 'Total Sales', 'Bill No.', 'Summary'],
          //   data: storeTotals
          //       .map((entry) => [
          //             entry['storeName'],
          //             (entry['saleTotal']).toStringAsFixed(2),
          //             entry['billNumber'],
          //           ])
          //       .toList(),
          //   border: pw.TableBorder.all(),
          //   headerStyle: pw.TextStyle(
          //     fontWeight: pw.FontWeight.bold,
          //     color: PdfColors.white,
          //   ),
          //   headerDecoration: const pw.BoxDecoration(color: PdfColors.blue),
          //   cellAlignment: pw.Alignment.center,
          // ),
          pw.TableHelper.fromTextArray(
            headers: ['Store Name', 'Total Sales', 'Bill No.', 'Summary'],
            data: storeTotals
                .map((entry) => [
                      entry['storeName'] = truncateText(entry['storeName']),
                      (entry['saleTotal']).toStringAsFixed(2),
                      entry['billNumber'],
                      '' // you can add summary content later
                    ])
                .toList(),
            border: pw.TableBorder.all(),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.blue),
            cellAlignment: pw.Alignment.center,
            // ✅ Fix column widths
            columnWidths: {
              0: const pw.FlexColumnWidth(2), // Store Name → half sheet
              1: const pw.FlexColumnWidth(1), // Total Sales → 1/3rd of remaining
              2: const pw.FlexColumnWidth(1), // Bill No. → 1/3rd of remaining
              3: const pw.FlexColumnWidth(1), // Summary → 1/3rd of remaining
            },
          ),

          pw.SizedBox(height: 20),
          pw.Text(
            'Grand Total: ${allSaleTotal.toStringAsFixed(2)}',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.black),
          ),
        ],
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a5.copyWith(
          marginLeft: 24.h,
          marginRight: 24.h,
          marginTop: 16.h,
          marginBottom: 16.h,
        ),
        build: (context) => [
          pw.Header(
            level: 1,
            child: pw.Text('ITEM-wise Sales Summary on: ${DateTime.now().cddmmyyyy}',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          ),
          pw.TableHelper.fromTextArray(
            headers: ['ITEM Name', 'Quantity'],
            data: allItems.entries.map((e) => [e.key, e.value.toStringAsFixed(2)]).toList(),
            border: pw.TableBorder.all(),
            cellAlignment: pw.Alignment.center,
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.blue),
          ),
        ],
      ),
    );
  }

  return pdf.save();
}

String truncateText(String text, {int maxLength = 20}) {
  return text.length > maxLength ? '${text.substring(0, maxLength)}...' : text;
}
