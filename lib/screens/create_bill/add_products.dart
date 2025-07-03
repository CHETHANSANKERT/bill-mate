import 'package:bill_mate/bloc/create_bill/create_bill_bloc.dart';
import 'package:bill_mate/components/ui/app_bar.dart';
import 'package:bill_mate/components/ui/app_card.dart';
import 'package:bill_mate/components/ui/app_colors.dart';
import 'package:bill_mate/components/ui/text_style.dart';
import 'package:bill_mate/constants/asset_constants.dart';
import 'package:bill_mate/routes/app_pages.dart';
import 'package:bill_mate/screens/create_bill/add_item_dialog.dart';
import 'package:bill_mate/utils/custon_date_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../components/button/primary_button.dart';
import '../../model/bill/sale.dart';
import '../../services/local/db_service.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({
    super.key,
    required this.storeName,
    required this.ownerName,
    this.location,
    this.gstNumber,
    required this.area,
    required this.beat,
    required this.address,
    required this.storeId,
  });

  final String storeName;
  final String ownerName;
  final String? location;
  final String? gstNumber;
  final String area;
  final String beat;
  final String address;
  final String storeId;

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        title: 'Add Products',
        context: context,
        onBackTap: () {
          context.read<CreateBillBloc>().add(ClearProducts());
          Navigator.of(context).pop();
        },
        actionsDefined: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierColor: AppColors.kBlack.withOpacity(0.3),
                  builder: (context) => const AddItemDialog(),
                );
              },
              icon: const Icon(
                Icons.add,
                size: 28,
                color: AppColors.kPrimary,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildCard(
              cardColor: AppColors.kCardBg,
              childWidget: Padding(
                padding: EdgeInsets.all(12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _labelValueText(
                      label: 'Store Name : ',
                      value: widget.storeName,
                    ),
                    8.verticalSpace,
                    _labelValueText(
                      label: 'Owner Name : ',
                      value: widget.ownerName,
                    ),
                    8.verticalSpace,
                    _labelValueText(
                      label: 'Address : ',
                      value: widget.address,
                    ),
                    8.verticalSpace,
                    _rowLabel(
                      label1: 'Beat Name : ',
                      value1: widget.beat,
                      label2: 'Area Name : ',
                      value2: widget.area,
                    ),
                  ],
                ),
              ),
            ),
            24.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Stock Added : ',
                  style: AppTextStyles.kw800Black18,
                ),
                BlocBuilder<CreateBillBloc, CreateBillState>(
                  builder: (context, state) {
                    double total = 0;
                    if (state is CreateBillLoaded) {
                      total = state.total;
                    }
                    return Text(
                      'Total Amount: ₹${total.toStringAsFixed(2)}',
                      style: AppTextStyles.kw600Black16,
                    );
                  },
                ),
              ],
            ),
            8.verticalSpace,
            Expanded(
              child: BlocBuilder<CreateBillBloc, CreateBillState>(
                builder: (context, state) {
                  if (state is CreateBillLoaded) {
                    final products = state.products;
                    if (products.isEmpty) {
                      return const Center(
                          child: Text('No products added yet.'));
                    }
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: BuildCard(
                            cardColor: AppColors.kWhite,
                            childWidget: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.kCardBg.withOpacity(0.3),
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16.r))),
                                  padding: EdgeInsets.all(12.h),
                                  child: Row(
                                    children: [
                                      Text(
                                        product.item.productName,
                                        style: AppTextStyles.kw700Black20,
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            barrierColor: AppColors.kBlack
                                                .withOpacity(0.3),
                                            builder: (context) =>
                                                AddItemDialog(product: product),
                                          );
                                        },
                                        child: SvgPicture.asset(
                                          GeneralImageAssets.icEdit,
                                          colorFilter: const ColorFilter.mode(
                                              AppColors.kBlue, BlendMode.srcIn),
                                          height: 20.h,
                                        ),
                                      ),
                                      16.horizontalSpace,
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) => AlertDialog(
                                              backgroundColor: AppColors.kAppBg,
                                              surfaceTintColor:
                                                  AppColors.kAppBg,
                                              title: const Text(
                                                'Confirm Delete',
                                                style:
                                                    AppTextStyles.kw600Black16,
                                              ),
                                              content: const Text(
                                                'Are you sure you want to delete this product?',
                                                style:
                                                    AppTextStyles.kw400Black14,
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    'Cancel',
                                                    style: AppTextStyles
                                                        .kw600Black16,
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    context
                                                        .read<CreateBillBloc>()
                                                        .add(ProductDeleted(
                                                            product.item.id));
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text(
                                                    'Delete',
                                                    style: AppTextStyles
                                                        .kErrorText16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        child: SvgPicture.asset(
                                          GeneralImageAssets.icDelete,
                                          colorFilter: const ColorFilter.mode(
                                              AppColors.kPrimary,
                                              BlendMode.srcIn),
                                          height: 20.h,
                                        ),
                                      ),
                                      16.horizontalSpace,
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16.h),
                                  child: _rowLabel(
                                    label1: 'Rate : ',
                                    value1: product.rate.toStringAsFixed(2),
                                    label2: 'Quantity : ',
                                    value2: product.quantity.toStringAsFixed(2),
                                  ),
                                ),
                                Container(
                                  width: 1.sw,
                                  color: AppColors.kCardBg.withOpacity(0.3),
                                  padding: EdgeInsets.all(16.h),
                                  child: _labelValueText(
                                    label: 'Total : ',
                                    value: product.total.toStringAsFixed(2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is CreateBillInitial) {
                    return const Center(child: Text('No products added yet.'));
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: PrimaryButton(
        buttonName: 'Submit',
        onClickfunction: () async {
          final state = context.read<CreateBillBloc>().state;
          if (state is CreateBillLoaded) {
            double saleTotal = state.total;
            final String invoiceId =
                DateTime.now().millisecondsSinceEpoch.toString();

            final sale = Sale(
              invoiceId: invoiceId,
              products: state.products,
              createdAt: DateTime.now().cddmmyyyy,
              total: saleTotal,
            );

            final saleMap = {
              'id': sale.id,
              'invoiceId': sale.invoiceId,
              'storeName': widget.storeName,
              'saleTotal': sale.total,
              'createdAt': sale.createdAt,
              'storeId': widget.storeId,
            };
            await DatabaseHelper().insertSale(saleMap);

            for (final product in sale.products) {
              final productMap = {
                // 'id': product.item.id,
                'saleId': sale.id,
                'itemId': product.item.id,
                'itemName': product.item.productName,
                'rate': product.rate,
                'quantity': product.quantity,
                'productTotal': product.total,
              };
              await DatabaseHelper().insertProduct(productMap);
            }
            context.read<CreateBillBloc>().add(ClearProducts());
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //   AppRoutes.home,
            //   (route) => false,
            // );
            navigateUntil(context, AppRoutes.home);
          }
        },
        kSize: Size(0.4.sw, 56.h),
      ),
    );
  }

  /// key value pair text
  RichText _labelValueText({String? label, String? value}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: label, style: AppTextStyles.kw400Black14),
          TextSpan(text: value, style: AppTextStyles.kw600Black16),
        ],
      ),
    );
  }

  /// row in 2 [labelValueText] pair
  Row _rowLabel(
      {String? label1, String? value1, String? label2, String? value2}) {
    return Row(
      children: [
        _labelValueText(
          label: label1,
          value: value1,
        ),
        const Spacer(),
        _labelValueText(
          label: label2,
          value: value2,
        ),
      ],
    );
  }
}
