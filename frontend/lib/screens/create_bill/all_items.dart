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
import '../../services/local/db_service.dart';
import '../../utils/app_snackbar.dart';
import '../../utils/empty_screen.dart';

class ItemEditResult {
  final double rate;
  final double stockQuantity;

  const ItemEditResult({
    required this.rate,
    required this.stockQuantity,
  });
}

class AllItemsScreen extends StatefulWidget {
  const AllItemsScreen({super.key});

  @override
  State<AllItemsScreen> createState() => _AllItemsScreenState();
}

class _AllItemsScreenState extends State<AllItemsScreen> {
  Future<ItemEditResult?> showEditItemDialog({
    required BuildContext context,
    required Map<String, dynamic> item,
  }) {
    final formKey = GlobalKey<FormState>();

    final rateController = TextEditingController(
      text: item['rate'].toString(),
    );

    final stockController = TextEditingController(
      text: item['stockQuantity'].toString(),
    );

    return showDialog<ItemEditResult>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Header
                  Row(
                    children: [
                      const Icon(Icons.inventory_2_outlined),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Edit Item",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Item Name
                  TextFormField(
                    initialValue: item['itemName'],
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: "Item Name",
                      prefixIcon: const Icon(Icons.label_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Rate
                  TextFormField(
                    controller: rateController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: validateNumber,
                    decoration: InputDecoration(
                      labelText: "Rate",
                      prefixIcon: const Icon(Icons.currency_rupee),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Stock
                  TextFormField(
                    controller: stockController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: validateNumber,
                    decoration: InputDecoration(
                      labelText: "Stock Quantity",
                      prefixIcon: const Icon(Icons.inventory),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            if (!formKey.currentState!.validate()) {
                              return;
                            }

                            Navigator.pop(
                              context,
                              ItemEditResult(
                                rate: double.parse(
                                  rateController.text,
                                ),
                                stockQuantity: double.parse(
                                  stockController.text,
                                ),
                              ),
                            );
                          },
                          child: const Text("Save"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String? validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Required";
    }

    if (double.tryParse(value) == null) {
      return "Invalid number";
    }

    return null;
  }

  Future<void> editItem(
    BuildContext context,
    Map<String, dynamic> item,
  ) async {
    final result = await showEditItemDialog(
      context: context,
      item: item,
    );

    if (result == null) {
      return;
    }

    await DatabaseHelper().updateItem(
      id: item['id'],
      rate: result.rate,
      stockQuantity: result.stockQuantity,
    );

    appSnackbar(message: 'Please enter all the values', snackbarState: SnackbarState.warning);
  }

  @override
  void initState() {
    super.initState();
    context.read<CreateBillBloc>().add(LoadAllItems());
  }

  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> filteredItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: commonAppBar(title: 'All-Items', context: context, actionsDefined: [
      //   _search(),
      // ]),
      appBar: commonAppBar(
        context: context,
        titleWidget: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search Item...',
                  border: InputBorder.none,
                ),
                onChanged: _filterItems,
              )
            : const Text('All-Items'),
        actionsDefined: [
          _search(),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.h),
        child: ListView(
          children: [
            _buildHeader(),
            BlocBuilder<CreateBillBloc, CreateBillState>(
              builder: (context, state) {
                if (state is AllItemsLoaded) {
                  final allItems = isSearching && searchController.text.isNotEmpty ? filteredItems : state.items;
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

  Widget _search() {
    return IconButton(
      icon: Icon(
        isSearching ? Icons.close : Icons.search,
      ),
      onPressed: () {
        setState(() {
          if (isSearching) {
            searchController.clear();
            filteredItems.clear();
          }
          isSearching = !isSearching;
        });
      },
    );
  }

  void _filterItems(String query) {
    final state = context.read<CreateBillBloc>().state;

    if (state is AllItemsLoaded) {
      setState(() {
        filteredItems = state.items.where((item) {
          return item['itemName'].toString().toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.kSecondaryDarkBg,
      padding: EdgeInsets.all(8.h),
      child: Row(
        children: [
          expandedText('Sl.', 1),
          expandedText('Sale', 6),
          expandedText('Rate', 3),
          expandedText('Stock', 3),
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

  Widget _buildRow(int index, Map<String, dynamic> item, BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.h),
          child: Row(
            children: [
              expandedText('${index + 1}', 1, isStart: true),
              expandedText(item['itemName'] ?? '', 6, isStart: true),
              expandedText('₹${(item['rate'] ?? 0).toStringAsFixed(2)}', 3, isStart: true),
              Expanded(
                flex: 3,
                child: Text(
                  '${(item['stockQuantity'] ?? 0.0).toStringAsFixed(0)}',
                  style: TextStyle(
                    color: (item['stockQuantity'] ?? 0.0) < 10
                        ? Colors.red
                        : Theme.of(context).textTheme.bodyMedium!.color!,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
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
                              'Are you sure you want to delete this Item?',
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
                                  await DatabaseHelper().deleteItem(item['id']);
                                  context.read<CreateBillBloc>().add(LoadAllItems());
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
                    8.horizontalSpace,
                    InkWell(
                      onTap: () => editItem(context, item),
                      child: SvgPicture.asset(
                        GeneralImageAssets.icEdit,
                        colorFilter: const ColorFilter.mode(AppColors.kBlue, BlendMode.srcIn),
                        height: 20.h,
                      ),
                    ),
                  ],
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
