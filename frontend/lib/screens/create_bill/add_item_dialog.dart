import 'package:bill_mate/bloc/create_bill/create_bill_bloc.dart';
import 'package:bill_mate/components/ui/dropdown_textfield.dart';
import 'package:bill_mate/model/bill/item.dart';
import 'package:bill_mate/components/button/primary_button.dart';
import 'package:bill_mate/components/ui/app_colors.dart';
import 'package:bill_mate/components/ui/text_input_field.dart';
import 'package:bill_mate/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../components/button/text_button.dart';
import '../../model/bill/sale.dart';
import '../../services/local/db_service.dart';

class AddItemDialog extends StatefulWidget {
  final Product? product;

  const AddItemDialog({super.key, this.product});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  TextEditingController _itemNameController = TextEditingController();
  TextEditingController _rateController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();

  double _total = 0.0;

  void _calculateTotal() {
    final rate = double.tryParse(_rateController.text) ?? 0;
    final quantity = double.tryParse(_quantityController.text) ?? 0;
    setState(() {
      _total = rate * quantity;
    });
  }

  @override
  void initState() {
    super.initState();
    _itemNameController.text = widget.product?.item.productName ?? '';
    _rateController.text = widget.product?.rate.toString() ?? '';
    _quantityController.text = widget.product?.quantity.toString() ?? '';
    _rateController.addListener(_calculateTotal);
    _quantityController.addListener(_calculateTotal);
  }

  @override
  void dispose() {
    super.dispose();
    _itemNameController.dispose();
    _rateController.dispose();
    _quantityController.dispose();
  }

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName cannot be empty';
    }
    return null;
  }

  List<Map<String, dynamic>> itemsList = [];

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;
    return Dialog(
      surfaceTintColor: AppColors.kWhite,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isEditing ? 'Edit Item' : 'Item Details',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            16.verticalSpace,
            DropDownTextField(
              controller: _itemNameController,
              name: 'itemName',
              label: 'item name',
              hintText: 'Enter Item name : ',
              suggestionsCallback: (String query) async {
                itemsList = await DatabaseHelper().getDistinctFieldValuesInItem(query);
                return itemsList
                    .map((row) => row['itemName']?.toString() ?? '')
                    .where((v) => v.isNotEmpty)
                    .toSet()
                    .toList();
              },
              validator: (value) => _validateNotEmpty(value, 'itemName'),
              onTap: () {
                final match = itemsList.where((item) {
                  return item['itemName'] == _itemNameController.text;
                }).first;
                _rateController.text = match['rate'].toString();
                appSnackbar(message: 'Stock: ${(match['stockQuantity'] ?? 0.0).toStringAsFixed(0)}');

              },
            ),
            16.verticalSpace,
            _buildInput('Rate', _rateController, keyboardType: TextInputType.number),
            16.verticalSpace,
            _buildInput('Quantity', _quantityController, keyboardType: TextInputType.number),
            16.verticalSpace,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Total: ₹${_total.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            16.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TxtBtn(
                  txt: 'Cancel',
                  onPress: () {
                    Navigator.pop(context);
                  },
                ),
                PrimaryButton(
                  buttonName: isEditing ? 'Update' : 'Save',
                  kSize: Size(0.25.sw, 56.h),
                  onClickfunction: () async {
                    try {
                      final productName = _itemNameController.text.trim();
                      final rate = double.tryParse(_rateController.text) ?? 0;
                      final quantity = double.tryParse(_quantityController.text) ?? 0;
                      final total = rate * quantity;
                      if (productName.isEmpty || rate <= 0 || quantity <= 0) {
                        appSnackbar(message: 'Please fill all fields');

                        return;
                      }

                      // Stock check
                      final allItems = await DatabaseHelper().getAllItems();
                      final itemMatch = allItems.firstWhere(
                        (i) => i['itemName'] == productName,
                        orElse: () => {'stockQuantity': 0.0, 'id': ''},
                      );
                      final availableStock = itemMatch['stockQuantity'] ?? 0.0;
                      if (quantity > availableStock) {
                        appSnackbar(message: 'Insufficient stock! Available: ${availableStock.toStringAsFixed(0)}');
                        return;
                      }

                      final product = Product(
                        item: Item(
                          id: itemMatch['id'] ?? widget.product?.item.id,
                          productName: productName,
                          rate: rate,
                        ),
                        quantity: quantity,
                        total: total,
                        rate: rate,
                      );

                      // Deduct stock
                      if (itemMatch['id'].isNotEmpty) {
                        await DatabaseHelper().deductItemStock(itemMatch['id'], quantity);
                      }

                      if (await DatabaseHelper().findItemIsPresent(productName)) {
                        Map<String, dynamic> itemMap = {
                          'id': const Uuid().v4(),
                          'itemName': productName,
                          'rate': rate,
                          'stockQuantity': 0.0,
                        };
                        DatabaseHelper().insertItem(itemMap);
                      }

                      if (isEditing) {
                        context.read<CreateBillBloc>().add(ProductUpdated(product));
                      } else {
                        context.read<CreateBillBloc>().add(ProductAdded(product));
                      }
                    } finally {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return TextInputField(
      name: 'label',
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      contentPadding: EdgeInsets.all(12.h),
      label: label,
      hintText: 'Enter $label',
    );
  }
}
