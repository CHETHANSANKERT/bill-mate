import 'package:bill_mate/bloc/create_bill/create_bill_bloc.dart';
import 'package:bill_mate/model/bill/item.dart';
import 'package:bill_mate/components/button/primary_button.dart';
import 'package:bill_mate/components/button/secondary_button.dart';
import 'package:bill_mate/components/ui/app_colors.dart';
import 'package:bill_mate/components/ui/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/bill/sale.dart';

class AddItemDialog extends StatefulWidget {
  final Product? product;

  const AddItemDialog({super.key, this.product});

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  late TextEditingController _productNameController;
  late TextEditingController _rateController;
  late TextEditingController _quantityController;

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
    _productNameController =
        TextEditingController(text: widget.product?.item.productName ?? '');
    _rateController =
        TextEditingController(text: widget.product?.rate.toString() ?? '');
    _quantityController =
        TextEditingController(text: widget.product?.quantity.toString() ?? '');
    _rateController.addListener(_calculateTotal);
    _quantityController.addListener(_calculateTotal);
    _calculateTotal();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _rateController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

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
            _buildInput('Name', _productNameController),
            16.verticalSpace,
            _buildInput('Rate', _rateController,
                keyboardType: TextInputType.number),
            16.verticalSpace,
            _buildInput('Quantity', _quantityController,
                keyboardType: TextInputType.number),
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
                SecondaryButton(
                    buttonName: 'Cancel',
                    onClickfunction: () {
                      Navigator.pop(context);
                    }),
                PrimaryButton(
                  buttonName: isEditing ? 'Update' : 'Save',
                  kSize: Size(0.25.sw, 56.h),
                  onClickfunction: () {
                    final productName = _productNameController.text.trim();
                    final rate = double.tryParse(_rateController.text) ?? 0;
                    final quantity =
                        double.tryParse(_quantityController.text) ?? 0;
                    final total = rate * quantity;

                    if (productName.isEmpty || rate <= 0 || quantity <= 0) {
                      return;
                    }
                    final product = Product(
                      item: Item(
                        id: widget.product?.item.id,
                        productName: productName,
                        rate: rate,
                      ),
                      quantity: quantity,
                      total: total,
                      rate: rate,
                    );

                    if (isEditing) {
                      context
                          .read<CreateBillBloc>()
                          .add(ProductUpdated(product));
                    } else {
                      context.read<CreateBillBloc>().add(ProductAdded(product));
                    }

                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller,
      {TextInputType? keyboardType}) {
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
