import 'package:bill_mate/bloc/create_bill/create_bill_bloc.dart';
import 'package:bill_mate/components/ui/app_bar.dart';
import 'package:bill_mate/components/ui/app_colors.dart';
import 'package:bill_mate/components/ui/text_style.dart';
import 'package:bill_mate/routes/app_pages.dart';
import 'package:bill_mate/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../components/button/primary_button.dart';
import '../../components/ui/dropdown_textfield.dart';
import '../../components/ui/text_input_field.dart';
import '../../model/bill/item.dart';
import '../../model/bill/sale.dart';
import '../../services/local/db_service.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({
    super.key,
    required this.storeName,
    required this.ownerName,
    this.location,
    this.gstNumber,
    this.mobileNumber,
    required this.area,
    required this.beat,
    this.address,
    required this.storeId,
    this.existingSale,
    this.saleId,
    this.invoiceId,
  });

  final String storeName;
  final String ownerName;
  final String? location;
  final String? saleId;
  final String? invoiceId;
  final String? gstNumber;
  final String? mobileNumber;
  final String area;
  final String beat;
  final String? address;
  final String storeId;

  final List<Product>? existingSale;

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  double _inlineTotal = 0.0;
  List<Map<String, dynamic>> _itemsList = [];

  void _calcInlineTotal() {
    final r = double.tryParse(_rateController.text) ?? 0;
    final q = double.tryParse(_quantityController.text) ?? 0;
    setState(() => _inlineTotal = r * q);
  }

  @override
  void initState() {
    super.initState();
    _rateController.addListener(_calcInlineTotal);
    _quantityController.addListener(_calcInlineTotal);

    if (widget.existingSale != null) {
      final bloc = context.read<CreateBillBloc>();

      for (final p in widget.existingSale!) {
        bloc.add(ProductAdded(p));
      }
    }
  }

  @override
  void dispose() {
    // _itemNameController.dispose();
    // _rateController.dispose();
    // _quantityController.dispose();
    super.dispose();
  }

  Future<void> _addProduct(BuildContext blocContext) async {
    final productName = _itemNameController.text.trim();
    final rate = double.tryParse(_rateController.text) ?? 0;
    final quantity = double.tryParse(_quantityController.text) ?? 0;
    if (productName.isEmpty || rate <= 0 || quantity <= 0) {
     appSnackbar(message: 'Please fill all fields with valid values.');
      return;
    }

    /// Check stock
    /// Not required as of now
    // final allItems = await DatabaseHelper().getAllItems();
    // final itemMatch = allItems.firstWhere(
    //   (i) => i['itemName'] == productName,
    //   orElse: () => {'stockQuantity': 0.0},
    // );
    // final availableStock = itemMatch['stockQuantity'] ?? 0.0;
    // if (quantity > availableStock) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(
    //           'Insufficient stock! Available: ${availableStock.toStringAsFixed(0)}'),
    //       backgroundColor: AppColors.kError,
    //     ),
    //   );
    //   return;
    // }

    final total = rate * quantity;
    final product = Product(
      item: Item(productName: productName, rate: rate),
      quantity: quantity,
      total: total,
      rate: rate,
    );
    if (await DatabaseHelper().findItemIsPresent(productName)) {
      await DatabaseHelper().insertItem({
        'id': const Uuid().v4(),
        'itemName': productName,
        'rate': rate,
        'stockQuantity': 0.0,
      });
    }
    // Deduct stock
    // await DatabaseHelper().deductItemStock(itemMatch['id'], quantity);
    blocContext.read<CreateBillBloc>().add(ProductAdded(product));
    _itemNameController.clear();
    _rateController.clear();
    _quantityController.clear();
    setState(() => _inlineTotal = 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kAppBg,
      appBar: commonAppBar(
        title: 'Add Products',
        context: context,
        onBackTap: () {
          context.read<CreateBillBloc>().add(ClearProducts());
          Navigator.of(context).pop();
        },
      ),
      body: Column(
        children: [
          // ── Store Info Banner ──
          Container(
            margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
            padding: EdgeInsets.all(14.h),
            decoration: BoxDecoration(
              color: AppColors.kPrimaryLightBg,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.kPrimary.withOpacity(0.25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.store_rounded, color: AppColors.kPrimary, size: 18.sp),
                    6.horizontalSpace,
                    Expanded(
                      child: Text(widget.storeName,
                          style: AppTextStyles.kw700Black20.copyWith(color: AppColors.kSecondaryDark)),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.kPrimary.withAlpha(33),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(widget.beat,
                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.kPrimary)),
                    ),
                  ],
                ),
                6.verticalSpace,
                _infoRow(Icons.person_outline, widget.ownerName),
                4.verticalSpace,
                widget.address != null ? _infoRow(Icons.location_on_outlined, widget.address!) : SizedBox.shrink(),
                4.verticalSpace,
                _infoRow(Icons.map_outlined, '${widget.beat} · ${widget.area}'),
              ],
            ),
          ),

          // ── Inline Add Product Form ──
          Container(
            margin: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
            padding: EdgeInsets.all(14.h),
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(color: AppColors.kSecondary.withAlpha(20), blurRadius: 10, offset: const Offset(0, 3))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.h),
                      decoration: BoxDecoration(
                        color: AppColors.kPrimaryBg,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(Icons.add_shopping_cart_rounded, color: AppColors.kPrimary, size: 18.sp),
                    ),
                    10.horizontalSpace,
                    Text('Add New Product', style: AppTextStyles.kw600Black16),
                  ],
                ),
                12.verticalSpace,
                DropDownTextField(
                  controller: _itemNameController,
                  name: 'itemName',
                  label: 'Item Name',
                  hintText: 'Search or enter item name',
                  suggestionsCallback: (String query) async {
                    _itemsList = await DatabaseHelper().getDistinctFieldValuesInItem(query);
                    return _itemsList
                        .map((row) => row['itemName']?.toString() ?? '')
                        .where((v) => v.isNotEmpty)
                        .toSet()
                        .toList();
                  },
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Item name required' : null,
                  onTap: () {
                    final match = _itemsList.where((i) => i['itemName'] == _itemNameController.text);
                    if (match.isNotEmpty) {
                      _rateController.text = match.first['rate'].toString();
                      _quantityController.text = '1';
                    }
                  },
                ),
                12.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: TextInputField(
                        name: 'rate',
                        controller: _rateController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        label: 'Rate (₹)',
                        hintText: '0.00',
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: TextInputField(
                        name: 'quantity',
                        controller: _quantityController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        label: 'Quantity',
                        hintText: '0',
                        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                      ),
                    ),
                  ],
                ),
                12.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: _inlineTotal > 0 ? AppColors.kTertiaryBg : AppColors.kAppBg,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                              color: _inlineTotal > 0 ? AppColors.kTertiary : AppColors.kCardBg.withAlpha(122)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calculate_outlined,
                                size: 16.sp, color: _inlineTotal > 0 ? AppColors.kSuccess : AppColors.kOutline),
                            6.horizontalSpace,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Line Total', style: TextStyle(fontSize: 10.sp, color: AppColors.kOutline)),
                                Text(
                                  '₹${_inlineTotal.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                      color: _inlineTotal > 0 ? AppColors.kSuccess : AppColors.kOutline),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    12.horizontalSpace,
                    GestureDetector(
                      onTap: () => _addProduct(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.kPrimary, AppColors.kPrimaryDark],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.kPrimary.withAlpha(77), blurRadius: 8, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.add_rounded, color: AppColors.kWhite, size: 20.sp),
                            6.horizontalSpace,
                            Text('Add',
                                style:
                                    TextStyle(color: AppColors.kWhite, fontWeight: FontWeight.w700, fontSize: 15.sp)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Items Table ──
          Expanded(
            child: BlocBuilder<CreateBillBloc, CreateBillState>(
              builder: (context, state) {
                double total = 0;
                List<Product> products = [];
                if (state is CreateBillLoaded) {
                  total = state.total;
                  products = state.products;
                }

                return Container(
                  margin: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
                  decoration: BoxDecoration(
                    color: AppColors.kWhite,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: AppColors.kOutline.withAlpha(30)),
                    boxShadow: [
                      BoxShadow(color: AppColors.kBlack.withAlpha(20), blurRadius: 8, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Table Header Bar
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: AppColors.kSecondaryLightBg,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.inventory_2_outlined, color: AppColors.kSecondary, size: 16.sp),
                            6.horizontalSpace,
                            Text('Items Added', style: AppTextStyles.kw800Black18.copyWith(fontSize: 14.sp)),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                color: AppColors.kSecondary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                '${products.length} item${products.length == 1 ? '' : 's'}',
                                style: TextStyle(
                                    fontSize: 11.sp, fontWeight: FontWeight.w600, color: AppColors.kSecondary),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Column Labels
                      if (products.isNotEmpty) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text('Item',
                                    style: TextStyle(
                                        fontSize: 10.sp, fontWeight: FontWeight.w600, color: AppColors.kOutline)),
                              ),
                              SizedBox(
                                width: 52.w,
                                child: Text('Rate',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 10.sp, fontWeight: FontWeight.w600, color: AppColors.kOutline)),
                              ),
                              SizedBox(
                                width: 36.w,
                                child: Text('Qty',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 10.sp, fontWeight: FontWeight.w600, color: AppColors.kOutline)),
                              ),
                              SizedBox(
                                width: 62.w,
                                child: Text('Total',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 10.sp, fontWeight: FontWeight.w600, color: AppColors.kOutline)),
                              ),
                              SizedBox(width: 52.w), // actions placeholder
                            ],
                          ),
                        ),
                        Divider(height: 1, color: AppColors.kOutline.withOpacity(0.12)),
                      ],

                      // Rows
                      Expanded(
                        child: products.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.shopping_basket_outlined, size: 52.sp, color: AppColors.kCardBg),
                                    12.verticalSpace,
                                    Text('No items added yet',
                                        style: TextStyle(color: AppColors.kOutline, fontSize: 14.sp)),
                                    4.verticalSpace,
                                    Text('Fill the form above to add products',
                                        style: TextStyle(color: AppColors.kCardBg, fontSize: 12.sp)),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                padding: EdgeInsets.only(bottom: 100.h),
                                itemCount: products.length,
                                separatorBuilder: (_, __) =>
                                    Divider(height: 1, color: AppColors.kOutline.withAlpha(22)),
                                itemBuilder: (context, index) {
                                  return _ProductTile(
                                    product: products[index],
                                    index: index,
                                  );
                                },
                              ),
                      ),

                      // Total Footer
                      if (products.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: AppColors.kPrimary.withOpacity(0.05),
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(14.r)),
                            border: Border(
                              top: BorderSide(color: AppColors.kPrimary.withAlpha(30)),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.receipt_long_outlined, size: 15.sp, color: AppColors.kPrimary),
                              6.horizontalSpace,
                              Text('Grand Total',
                                  style:
                                      TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: Colors.black87)),
                              const Spacer(),
                              Text(
                                '₹${total.toStringAsFixed(2)}',
                                style:
                                    TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w800, color: AppColors.kPrimary),
                              ),
                              BlocBuilder<CreateBillBloc, CreateBillState>(
                                builder: (context, state) {
                                  final hasProducts = state is CreateBillLoaded && state.products.isNotEmpty;
                                  return AnimatedOpacity(
                                    opacity: hasProducts ? 1 : 0.4,
                                    duration: const Duration(milliseconds: 250),
                                    child: PrimaryButton(
                                      buttonName: 'Submit Bill',
                                      onClickfunction: hasProducts
                                          ? () async {
                                              final bloc = context.read<CreateBillBloc>();
                                              final s = bloc.state;
                                              String saleId = '';
                                              try {
                                                if (widget.saleId != null) {
                                                  saleId = widget.saleId!;
                                                  final Map<String, dynamic> updatedSale = {
                                                    'storeName': widget.storeName,
                                                    'storeId': widget.storeId,
                                                    'id': widget.saleId!,
                                                    'invoiceId': widget.invoiceId ??
                                                        DateTime.now().millisecondsSinceEpoch.toString(),
                                                    'createdAt': DateTime.now().toIso8601String(),
                                                    'saleTotal': s is CreateBillLoaded ? s.total : 0,
                                                  };
                                                  await DatabaseHelper().updateSale(widget.saleId!, updatedSale);
                                                } else if (s is CreateBillLoaded) {
                                                  final invoiceId = DateTime.now().millisecondsSinceEpoch.toString();
                                                  final sale = Sale(
                                                    invoiceId: invoiceId,
                                                    products: s.products,
                                                    createdAt: DateTime.now().toIso8601String(),
                                                    total: s.total,
                                                  );
                                                  saleId = sale.id;
                                                  await DatabaseHelper().insertSale({
                                                    'id': sale.id,
                                                    'invoiceId': sale.invoiceId,
                                                    'storeName': widget.storeName,
                                                    'saleTotal': sale.total,
                                                    'createdAt': sale.createdAt,
                                                    'storeId': widget.storeId,
                                                  });
                                                }

                                                if (s is CreateBillLoaded) {
                                                  for (final p in s.products) {
                                                    await DatabaseHelper().insertSaleProducts({
                                                      'saleId': saleId,
                                                      'itemId': p.item.id,
                                                      'itemName': p.item.productName,
                                                      'rate': p.rate,
                                                      'quantity': p.quantity,
                                                      'productTotal': p.total,
                                                    });
                                                  }
                                                }
                                              } finally {
                                                bloc.add(ClearProducts());
                                                navigateUntil(context, AppRoutes.home);
                                              }
                                            }
                                          : () {},
                                      kSize: Size(0.25.sw, 54.h),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return (text.isNotEmpty && text != '')
        ? Row(
            children: [
              Icon(icon, size: 13.sp, color: AppColors.kSecondaryLight),
              5.horizontalSpace,
              Expanded(
                child: Text(text,
                    style: TextStyle(fontSize: 12.sp, color: AppColors.kSecondary, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          )
        : SizedBox.shrink();
  }
}

// ── Compact table-row product tile ──
class _ProductTile extends StatefulWidget {
  final Product product;
  final int index;
  const _ProductTile({required this.product, required this.index});

  @override
  State<_ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<_ProductTile> {
  bool _isEditing = false;
  late TextEditingController _rateCtrl;
  late TextEditingController _qtyCtrl;
  double _editTotal = 0;

  @override
  void initState() {
    super.initState();
    _rateCtrl = TextEditingController(text: widget.product.rate.toString());
    _qtyCtrl = TextEditingController(text: '1');
    _editTotal = widget.product.total;
    _rateCtrl.addListener(_recalc);
    _qtyCtrl.addListener(_recalc);
  }

  void _recalc() {
    final r = double.tryParse(_rateCtrl.text) ?? 0;
    final q = double.tryParse(_qtyCtrl.text) ?? 0;
    setState(() => _editTotal = r * q);
  }

  @override
  void dispose() {
    _rateCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: _isEditing ? AppColors.kPrimary.withAlpha(10) : Colors.transparent,
      child: Column(
        children: [
          // Main row
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
            child: Row(
              children: [
                // Item name
                Expanded(
                  flex: 3,
                  child: Text(
                    widget.product.item.productName,
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),

                // Rate
                SizedBox(
                  width: 52.w,
                  child: Text(
                    '₹${widget.product.rate.toStringAsFixed(0)}',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 11.sp, color: AppColors.kOutline),
                  ),
                ),

                // Qty
                SizedBox(
                  width: 36.w,
                  child: Text(
                    '×${widget.product.quantity.toStringAsFixed(0)}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500, color: AppColors.kSecondary),
                  ),
                ),

                // Total
                SizedBox(
                  width: 62.w,
                  child: Text(
                    '₹${widget.product.total.toStringAsFixed(2)}',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: AppColors.kPrimaryDark),
                  ),
                ),

                // Action buttons
                SizedBox(
                  width: 52.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _IconBtn(
                        icon: _isEditing ? Icons.close_rounded : Icons.edit_outlined,
                        color: AppColors.kBlue,
                        onTap: () => setState(() => _isEditing = !_isEditing),
                      ),
                      4.horizontalSpace,
                      _IconBtn(
                        icon: Icons.delete_outline_rounded,
                        color: AppColors.kPrimary,
                        onTap: () => _confirmDelete(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Inline edit panel (expands below the row)
          if (_isEditing)
            Container(
              margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 10.h),
              padding: EdgeInsets.all(10.h),
              decoration: BoxDecoration(
                color: AppColors.kPrimaryBg,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.kPrimary.withOpacity(0.15)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextInputField(
                          name: 'rate_edit',
                          controller: _rateCtrl,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          label: 'Rate (₹)',
                          hintText: '0.00',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                        ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: TextInputField(
                          name: 'qty_edit',
                          controller: _qtyCtrl,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          label: '1',
                          hintText: '0',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                        ),
                      ),
                    ],
                  ),
                  8.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: ₹${_editTotal.toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.sp, color: AppColors.kSuccess),
                      ),
                      GestureDetector(
                        onTap: () {
                          final r = double.tryParse(_rateCtrl.text) ?? 0;
                          final q = double.tryParse(_qtyCtrl.text) ?? 0;
                          if (r <= 0 || q <= 0) return;
                          final updated = Product(
                            item: Item(
                              id: widget.product.item.id,
                              productName: widget.product.item.productName,
                              rate: r,
                            ),
                            quantity: q,
                            total: r * q,
                            rate: r,
                          );
                          context.read<CreateBillBloc>().add(ProductUpdated(updated));
                          setState(() => _isEditing = false);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: AppColors.kPrimary,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text('Update',
                              style: TextStyle(color: AppColors.kWhite, fontWeight: FontWeight.w600, fontSize: 12.sp)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.kAppBg,
        surfaceTintColor: AppColors.kAppBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.kError, size: 22.sp),
            8.horizontalSpace,
            const Text('Remove Item', style: AppTextStyles.kw600Black16),
          ],
        ),
        content: Text(
          'Remove "${widget.product.item.productName}" from this bill?',
          style: AppTextStyles.kw400Black14,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.kOutline)),
          ),
          TextButton(
            onPressed: () {
              context.read<CreateBillBloc>().add(ProductDeleted(widget.product.item.id));
              Navigator.pop(context);
            },
            child: Text('Remove', style: TextStyle(color: AppColors.kError, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.all(2.h),
        decoration: BoxDecoration(
          color: color.withAlpha(22),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, color: color, size: 12.sp),
      ),
    );
  }
}
