// ignore_for_file: depend_on_referenced_packages

import 'package:uuid/uuid.dart';

class Item {
  final String id;
  final String productName;
  final double rate;
  final double stockQuantity;

  Item({
    String? id,
    required this.productName,
    required this.rate,
    this.stockQuantity = 0.0,
  }) : id = id ?? const Uuid().v4();

  Item copyWith({
    String? id,
    String? productName,
    double? rate,
    double? stockQuantity,
  }) {
    return Item(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      rate: rate ?? this.rate,
      stockQuantity: stockQuantity ?? this.stockQuantity,
    );
  }
}
