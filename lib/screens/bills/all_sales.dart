import 'package:bill_mate/components/ui/app_bar.dart';
import 'package:bill_mate/components/ui/app_colors.dart';
import 'package:bill_mate/components/ui/app_loader.dart';
import 'package:bill_mate/components/ui/text_style.dart';
import 'package:bill_mate/constants/asset_constants.dart';
import 'package:bill_mate/utils/app_snackbar.dart';
import 'package:bill_mate/utils/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../bloc/bill/bill_bloc.dart';
import '../../components/button/cross_button.dart';
import '../../components/button/primary_button.dart';
import '../../components/button/text_button.dart';
import '../../routes/app_pages.dart';
import '../../services/local/db_service.dart';
import '../utility_screens/pdf_view.dart';

class AllSalesScreen extends StatefulWidget {
  const AllSalesScreen({super.key});

  @override
  State<AllSalesScreen> createState() => _AllSalesScreenState();
}

class _AllSalesScreenState extends State<AllSalesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BillBloc>().add(LoadAllSales());
  }

  bool _isPrint = false;
  Set<String> selectedSaleIds = {};

  late List<Map<String, dynamic>> sales;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
          title: 'All Sales',
          context: context,
          actionsDefined: [
            _isPrint
                ? crossButton(context, onTap: () {
                    setState(() {
                      _isPrint = false;
                    });
                  })
                : InkWell(
                    onTap: () {
                      setState(() {
                        _isPrint = true;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.h),
                      child: SvgPicture.asset(
                        GeneralImageAssets.icPrint,
                        height: 28.h,
                      ),
                    ),
                  ),
          ],
          onBackTap: () {
            Navigator.of(context).pop();
            context.read<BillBloc>().add(LoadThisMonthGraph());
          }),
      body: BlocBuilder<BillBloc, BillState>(
        builder: (context, state) {
          if (state is AllSalesState) {
            sales = state.sales;
            if (sales.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(16.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox.shrink(),
                    const EmptyScreen(
                      titleText: 'No sales found.',
                      subTitleText: 'Start the Sales',
                    ),
                    PrimaryButton(
                      buttonName: 'Create-Bill',
                      onClickfunction: () {
                        navigateOffNamed(context, AppRoutes.createStore);
                      },
                    ),
                  ],
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _isPrint
          ? PrimaryButton(
              buttonName: 'Print',
              onClickfunction: () async {
                final selectedSales = sales
                    .where((sale) => selectedSaleIds.contains(sale['id']))
                    .toList();

                if (selectedSales.isEmpty) {
                  appSnackbar(message: 'No sales selected',context: context,snackbarState: SnackbarState.warning);
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(content: Text("No sales selected")));
                  return;
                }
                _onRequestSummarySheet(selectedSales);
              },
              kSize: Size(0.4.sw, 56.h),
            )
          : const SizedBox.shrink(),
    );
  }

  void _onRequestSummarySheet(List<Map<String, dynamic>> selectedSales) async {
    await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.kAppBg,
        surfaceTintColor: AppColors.kAppBg,
        title: const Text('Include Summary Sheet?'),
        content: const Text(
            'Do you want to include a table sheet at the end showing all stores and item bill list ?'),
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
                                includeSummarySheet: false,
                              )));
                },
                txt: 'No',
              ),
              PrimaryButton(
                buttonName: 'Yes',
                kSize: Size(70.h, 30.h),
                onClickfunction: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SalesPdfPreviewPage(
                                selectedSales: selectedSales,
                                includeSummarySheet: true,
                              )));
                },
              ),
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
      child: Text(txt, style: AppTextStyles.kw600Black16),
    );
  }

  Widget _buildRow(int index, Map<String, dynamic> sale, BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.h),
          child: Row(
            children: [
              _isPrint
                  ? Checkbox(
                      value: selectedSaleIds.contains(sale['id']),
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            selectedSaleIds.add(sale['id']);
                          } else {
                            selectedSaleIds.remove(sale['id']);
                          }
                        });
                      },
                    )
                  : expandedText('${index + 1}', 1),
              expandedText(sale['storeName'] ?? '', 6),
              expandedText(
                  '₹${(sale['saleTotal'] ?? 0).toStringAsFixed(2)}', 4),
              Expanded(
                flex: 3,
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
                              context.read<BillBloc>().add(LoadAllSales());
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
                    colorFilter:
                        const ColorFilter.mode(AppColors.kRed, BlendMode.srcIn),
                    height: 20.h,
                  ),
                ),
                // ],
                // ),
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
