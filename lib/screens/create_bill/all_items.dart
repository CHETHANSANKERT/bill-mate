import 'package:bill_mate/bloc/create_bill/create_bill_bloc.dart';
import 'package:bill_mate/components/ui/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/ui/app_colors.dart';
import '../../components/ui/app_loader.dart';
import '../../components/ui/text_style.dart';
import '../../constants/asset_constants.dart';
import '../../utils/empty_screen.dart';

class AllItemsScreen extends StatefulWidget {
  const AllItemsScreen({super.key});

  @override
  State<AllItemsScreen> createState() => _AllItemsScreenState();
}

class _AllItemsScreenState extends State<AllItemsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CreateBillBloc>().add(LoadAllItems());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        title: 'All-Items',
        context: context,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.h),
        child: ListView(
          children: [
            _buildHeader(),
            BlocBuilder<CreateBillBloc, CreateBillState>(
              builder: (context, state) {
                if (state is AllItemsLoaded) {
                  final allItems = state.items;
                  if (allItems.isEmpty) {
                    return const Center(
                      child: EmptyScreen(
                        titleText: 'No stores are found.',
                        subTitleText: 'start adding Stores',
                      ),
                    );
                  }
                  return Column(
                    children: [
                      ...List.generate(
                        allItems.length,
                        (index) {
                          final sale = allItems[index];
                          return _buildRow(index, sale, context);
                        },
                      ),
                    ],
                  );
                }
                return const Center(child: AppLoader());
              },
            ),
          ],
        ),
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
          expandedText('rate', 4),
          expandedText('Action', 3),
        ],
      ),
    );
  }

  expandedText(String txt, int flex, {bool isStart = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        txt,
        style: AppTextStyles.kw600Black16,
        // textAlign: isStart ? TextAlign.start : TextAlign.center,
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
              expandedText('${index + 1}', 1, isStart: true),
              expandedText(sale['itemName'] ?? '', 6, isStart: true),
              expandedText('₹${(sale['rate'] ?? 0).toStringAsFixed(2)}', 4,
                  isStart: true),
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
