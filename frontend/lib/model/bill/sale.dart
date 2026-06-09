// ignore_for_file: depend_on_referenced_packages

import 'package:bill_mate/model/bill/item.dart';
import 'package:uuid/uuid.dart';

class Sale {
  final String id;
  final String invoiceId;
  final String createdAt;
  final List<Product> products;
  final double total;
  final bool? isPrinted;

  Sale({
    String? id,
    required this.invoiceId,
    required this.products,
    required this.createdAt,
    required this.total,
    this.isPrinted,
  }) : id = id ?? const Uuid().v4();
}

class Product {
  final Item item;
  final double quantity;
  final double total;
  final double rate;
  const Product({
    required this.item,
    required this.quantity,
    required this.total,
    required this.rate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': item.id,
      'itemName': item.productName,
      'rate': rate,
      'quantity': quantity,
      'total': total,
    };
  }
}
