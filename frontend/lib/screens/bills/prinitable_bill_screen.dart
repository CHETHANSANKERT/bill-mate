import 'package:bill_mate/components/ui/app_bar.dart';
import 'package:bill_mate/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../bloc/bill/bill_bloc.dart';
import '../../components/button/primary_button.dart';
import '../../components/button/text_button.dart';
import '../../components/ui/app_colors.dart';
import '../../components/ui/app_loader.dart';
import '../../components/ui/text_style.dart';
import '../../constants/asset_constants.dart';
import '../../model/bill/item.dart';
import '../../model/bill/sale.dart';
import '../../routes/app_pages.dart';
import '../../services/local/db_service.dart';
import '../../utils/empty_screen.dart';
import '../utility_screens/pdf_view.dart';

class PrintableBillScreen extends StatefulWidget {
  const PrintableBillScreen({super.key});

  @override
  State<PrintableBillScreen> createState() => _PrintableBillScreenState();
}

class _PrintableBillScreenState extends State<PrintableBillScreen> {
  late List<Map<String, dynamic>> sales;

  @override
  void initState() {
    super.initState();
    context.read<BillBloc>().add(LoadAllPrintableSales());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        title: 'Print - Bills',
        context: context,
        actionsDefined: [],
        onBackTap: () {
          Navigator.of(context).pop();
          context.read<BillBloc>().add(LoadThisMonthGraph());
        },
      ),
      body: BlocBuilder<BillBloc, BillState>(
        builder: (context, state) {
          if (state is AllSalesState) {
            sales = state.sales;
            if (sales.isEmpty) {
              return const Center(
                child: EmptyScreen(
                  titleText: 'No sales found.',
                  subTitleText: 'Start the Sales',
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.all(16.h),
              child: ListView(
                children: [
                  _buildHeader(),
                  ...List.generate(sales.length, (index) {
                    final sale = sales[index];
                    return _buildRow(index, sale, context);
                  }, growable: true),
                ],
              ),
            );
          }
          return const Center(child: AppLoader());
        },
      ),
      floatingActionButton: PrimaryButton(
        buttonName: 'Print',
        onClickfunction: () async {
          if (sales.isEmpty) {
            appSnackbar(message: 'No sales to be printed', snackbarState: SnackbarState.error);
            // ScaffoldMessenger.of(context).showSnackBar(
            //     const SnackBar(content: Text("No sales to be printed")));
            return;
          }
          _onRequestSummarySheet(sales);
        },
        kSize: Size(0.4.sw, 56.h),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _onRequestSummarySheet(List<Map<String, dynamic>> selectedSales) async {
    await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.kAppBg,
        surfaceTintColor: AppColors.kAppBg,
        title: const Text('Include Summary Sheet?'),
        content:
            const Text('Do you want to include a table sheet at the end showing all stores and their total sales?'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TxtBtn(
                onPress: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SalesPdfPreviewPage(
                                selectedSales: selectedSales,
                                includeSummarySheet: true,
                              )));
                },
                txt: 'No',
              ),
              PrimaryButton(
                  buttonName: 'Yes',
                  kSize: Size(70.h, 30.h),
                  onClickfunction: () async {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SalesPdfPreviewPage(
                                  selectedSales: selectedSales,
                                  includeSummarySheet: true,
                                )));
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.kSecondaryDarkBg,
      padding: EdgeInsets.all(8.h),
      child: Row(
        children: [
          expandedText('Sl.', 1),
          expandedText('Sale', 6),
          expandedText('Total', 4),
          expandedText('Action', 3),
        ],
      ),
    );
  }

  expandedText(
    String txt,
    int flex,
  ) {
    return Expanded(
      flex: flex,
      child: Text(
        txt,
        style: AppTextStyles.kw600Black16,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
      ),
    );
  }

  Widget _buildRow(int index, Map<String, dynamic> sale, BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.h),
          child: Row(
            children: [
              expandedText('${index + 1}', 1),
              expandedText(sale['storeName'] ?? '', 6),
              expandedText('₹${(sale['saleTotal'] ?? 0).toStringAsFixed(2)}', 4),
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        backgroundColor: AppColors.kAppBg,
                        surfaceTintColor: AppColors.kAppBg,
                        title: const Text(
                          'Confirm Delete',
                          style: AppTextStyles.kw600Black16,
                        ),
                        content: const Text(
                          'Are you sure you want to delete this SALE?',
                          style: AppTextStyles.kw400Black14,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cancel',
                              style: AppTextStyles.kw600Black16,
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await DatabaseHelper().deleteSale(sale['id']);
                              context.read<BillBloc>().add(LoadAllPrintableSales());
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Delete',
                              style: AppTextStyles.kErrorText16,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    GeneralImageAssets.icDelete,
                    colorFilter: const ColorFilter.mode(AppColors.kRed, BlendMode.srcIn),
                    height: 20.h,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () async {
                    final Map<String, dynamic>? store = await DatabaseHelper().getStoresById(sale['storeId']);

                    final List<Map<String, dynamic>> itemDetails =
                        await DatabaseHelper().getSaleProductsBySaleId(sale['id']);
                    final List<Product> existingProducts =
                    itemDetails.map((e) {
                      return Product(
                        item: Item(
                          id: e['itemId'],
                          productName: e['itemName'], rate: e['rate'],
                        ),
                        quantity: (e['quantity'] as num).toDouble(),
                        total: (e['productTotal'] as num).toDouble(),
                        rate: (e['rate'] as num).toDouble(),
                      );
                    }).toList();

                    print('sale : ${sale.toString()}');
                    print('store : ${store.toString()}');
                    print('itemDetails : ${itemDetails.toString()}');
                    navigateTo(
                      context,
                      AppRoutes.addProducts,
                      arguments: {
                        'id': sale['id'],
                        'storeId': sale['storeId'],
                        'storeName': sale['storeName'],
                        'ownerName': store?['ownerName'] ?? '',
                        'area': store?['area'] ?? '',
                        'beat': store?['beat'] ?? '',
                        'address': store?['address'] ?? '',
                        'existingSale': existingProducts,
                      },
                    );
                  },
                  child: SvgPicture.asset(
                    GeneralImageAssets.icEdit,
                    colorFilter: const ColorFilter.mode(AppColors.kBlue, BlendMode.srcIn),
                    height: 20.h,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 1,
          color: AppColors.kOutline,
        ),
      ],
    );
  }
}
