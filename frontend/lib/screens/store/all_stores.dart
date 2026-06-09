import 'package:bill_mate/bloc/store/store_bloc.dart';
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
import '../../utils/empty_screen.dart';

class AllStoresScreen extends StatefulWidget {
  const AllStoresScreen({super.key});

  @override
  State<AllStoresScreen> createState() => _AllStoresScreenState();
}

class _AllStoresScreenState extends State<AllStoresScreen> {
  @override
  void initState() {
    context.read<StoreBloc>().add(LoadAllStores());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        title: 'All-Stores',
        context: context,
        actionsDefined: [],
      ),
      body: BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          if (state is AllStoresState) {
            final stores = state.stores;
            if (stores.isEmpty) {
              return const Center(
                child: EmptyScreen(
                  titleText: 'No stores are found.',
                  subTitleText: 'start adding Stores',
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.all(16.h),
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(stores.length, (index) {
                          final sale = stores[index];
                          return _buildRow(index, sale, context);
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: AppLoader());
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.kSecondaryDarkBg,
      padding: EdgeInsets.all(8.h),
      child: Row(
        children: [
          expandedText('Store Name', 5),
          expandedText('Area', 3),
          expandedText('Beat', 3),
        ],
      ),
    );
  }

  Expanded expandedText(
    String txt,
    int flex,
  ) {
    return Expanded(
      flex: flex,
      child: Text(
        txt,
        style: AppTextStyles.kw600Black16,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildRow(int index, Map<String, dynamic> store, BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.h),
          child: Row(
            children: [
              expandedText(store['storeName'] ?? '', 5),
              expandedText(store['area'] ?? '', 3),
              expandedText(store['beat'] ?? '', 3),
              // Expanded(
              //   flex: 3,
              //   child: Row(
              //     children: [
              //       InkWell(
              //         onTap: () {
              //
              //         },
              //         child: SvgPicture.asset(
              //           GeneralImageAssets.icEdit,
              //           colorFilter: const ColorFilter.mode(AppColors.kBlue, BlendMode.srcIn),
              //           height: 20.h,
              //         ),
              //       ),
              //       16.horizontalSpace,
              //       InkWell(
              //         onTap: () {
              //           showDialog(
              //             context: context,
              //             barrierDismissible: false,
              //             builder: (context) => AlertDialog(
              //               backgroundColor: AppColors.kAppBg,
              //               surfaceTintColor: AppColors.kAppBg,
              //               title: const Text(
              //                 'Confirm Delete',
              //                 style: AppTextStyles.kw600Black16,
              //               ),
              //               content: Text(
              //                 'Are you sure you want to delete store - ${store['storeName']}?',
              //                 style: AppTextStyles.kw400Black14,
              //               ),
              //               actions: [
              //                 TextButton(
              //                   onPressed: () {
              //                     Navigator.pop(context);
              //                   },
              //                   child: const Text(
              //                     'Cancel',
              //                     style: AppTextStyles.kw600Black16,
              //                   ),
              //                 ),
              //                 TextButton(
              //                   onPressed: () async {
              //                     await DatabaseHelper().deleteStore(store['id'].toString());
              //                     context.read<StoreBloc>().add(LoadAllStores());
              //                     Navigator.pop(context);
              //                   },
              //                   child: const Text(
              //                     'Delete',
              //                     style: AppTextStyles.kErrorText16,
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           );
              //         },
              //         child: SvgPicture.asset(
              //           GeneralImageAssets.icDelete,
              //           colorFilter: const ColorFilter.mode(AppColors.kRed, BlendMode.srcIn),
              //           height: 20.h,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
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
