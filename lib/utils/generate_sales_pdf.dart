// import 'dart:typed_data';

import 'package:bill_mate/constants/asset_constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../services/local/db_service.dart';

Future<Uint8List> generateSalesPdf(
    List<Map<String, dynamic>> selectedSales) async {
  final pdf = pw.Document();

  final sriRenukambaLogoByteData =
      await rootBundle.load(StoreImages.sriRenukambaLogo);

  final icCallByteData = await rootBundle.load(GeneralImageAssets.icCall);
  // final icMailByteData = await rootBundle.load(GeneralImageAssets.icMail);
  final icLocationByteData =
      await rootBundle.load(GeneralImageAssets.icLocation);
  for (var sale in selectedSales) {
    final saleId = sale['id'];
    final createdAt = sale['createdAt'];
    final totalAmount = sale['saleTotal'];
    final storeId = sale['storeId'];

    // final List<Map<String, dynamic>> saleProducts = await DatabaseHelper().getSalesById(saleId);
    final List<Map<String, dynamic>> saleProducts =
        await DatabaseHelper().getSaleProductsBySaleId(saleId);

    final Map<String, dynamic> store =
        await DatabaseHelper().getStoresById(storeId);
    imageText(ByteData byteData, String txt, {Size? ksize}) {
      return pw.Row(children: [
        pw.Image(
          pw.MemoryImage(byteData.buffer.asUint8List()),
          height: ksize?.height ?? 16.h,
          width: ksize?.width ?? 16.h,
        ),
        pw.Text(' - $txt',
            style:
                const pw.TextStyle(fontSize: 16, color: PdfColors.blueGrey700)),
      ]);
    }

    textKeyValue(String fieldName, String value,
        {double? valueSize, double? fieldSize}) {
      return pw.Row(children: [
        pw.Text(
          '$fieldName : ',
          style: pw.TextStyle(
              fontSize: fieldSize ?? 16, color: PdfColors.brown700),
        ),
        pw.Text(value, style: pw.TextStyle(fontSize: valueSize ?? 16)),
      ]);
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              /// Company & Invoice Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(
                    pw.MemoryImage(
                        sriRenukambaLogoByteData.buffer.asUint8List()),
                    height: 60.h,
                    width: 100.h,
                  ),
                  pw.Text(
                    'SRI RENUKAMBA ENTERPRISES',
                    style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.orange300),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.SizedBox.shrink()
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  ///store details
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      textKeyValue('Store name', store['storeName']),
                      textKeyValue('Owner name', store['ownerName']),
                      textKeyValue('Area', store['area']),
                      textKeyValue('Beat', store['beat']),
                      textKeyValue('address', store['address']),
                      textKeyValue('Mobile Number', store['mobileNum']),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('INVOICE',
                          style: const pw.TextStyle(
                              fontSize: 20, color: PdfColors.blue)),
                      pw.SizedBox(height: 4),
                      imageText(icCallByteData, '8884125652'),
                      pw.SizedBox(height: 4),
                      imageText(icLocationByteData, 'TG Halli',
                          ksize: Size(24, 24)),
                      pw.SizedBox(height: 4),
                      pw.Text('Date: $createdAt'),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 12),

              /// Sale Items Table
              pw.Text('Item Details:',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 12),

              pw.TableHelper.fromTextArray(
                border: pw.TableBorder.all(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headers: ['#', 'Product Name', 'Rate', 'Qty', 'Total'],
                data: List.generate(saleProducts.length, (index) {
                  final item = saleProducts[index];
                  return [
                    (index + 1).toString(),
                    item['itemName'],
                    '${item['rate'].toStringAsFixed(2)}',
                    item['quantity'].toString(),
                    '${item['productTotal']}',
                  ];
                }),
              ),

              pw.SizedBox(height: 20),

              /// Total Summary
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Container(
                    width: 200,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Divider(),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Total:',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold)),
                            pw.Text(
                              '$totalAmount',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  return pdf.save();
}
