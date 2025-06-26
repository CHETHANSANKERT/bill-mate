import 'package:bill_mate/bloc/bill/bill_bloc.dart';
import 'package:bill_mate/components/button/primary_button.dart';
import 'package:bill_mate/components/ui/app_card.dart';
import 'package:bill_mate/components/ui/text_style.dart';
import 'package:bill_mate/routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/ui/app_bar.dart';
import '../../components/ui/app_colors.dart';
import '../../utils/billing_chart.dart';

class BillingHomeScreen extends StatefulWidget {
  const BillingHomeScreen({super.key});

  @override
  State<BillingHomeScreen> createState() => _BillingHomeScreenState();
}

class _BillingHomeScreenState extends State<BillingHomeScreen> {
  @override
  void initState() {
    context.read<BillBloc>().add(LoadDayGraph());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String selectedType = 'Day';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kAppBg,
      appBar: commonAppBar(
        title: 'Billing-Sheet',
        context: context,
        isBackReq: false,
      ),
      body: BlocListener<BillBloc, BillState>(
        listener: (context, state) async {
          if (state is BillingSuccess) {
            // Navigate to BillingHomeScreen on successful login
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else if (state is BillingFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login failed: ${state.error}')),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BuildCard(
                childWidget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildButton("Daily", 'Day'),
                          _buildButton("Weekly", 'Week'),
                          _buildButton("Monthly", 'Month'),
                          const Icon(Icons.bar_chart, color: AppColors.kBlue),
                        ],
                      ),
                    ),
                    BlocBuilder<BillBloc, BillState>(
                      builder: (context, state) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.kAppBg,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              state is GraphState
                                  ? BillingChart(data: state.data)
                                  : const SizedBox.shrink(),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                cardColor: AppColors.kCardBg,
              ),
              24.verticalSpace,
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: BuildCard(
                      cardColor: AppColors.kPrimaryBg,
                      childWidget: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoutes.allStores);
                        },
                        child: Padding(
                            padding: EdgeInsets.all(16.h),
                            child: const Text(
                              'All-Stores',
                              style: AppTextStyles.kw600Black18,
                              textAlign: TextAlign.center,
                            )),
                      ),
                    ),
                  ),
                  8.horizontalSpace,
                  Expanded(
                    flex: 4,
                    child: BuildCard(
                      cardColor: AppColors.kPrimary,
                      childWidget: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoutes.allSales);
                        },
                        child: Padding(
                            padding: EdgeInsets.all(16.h),
                            child: const Text(
                              'All-Sales',
                              style: AppTextStyles.kw600White16,
                              textAlign: TextAlign.center,
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              16.verticalSpace,
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: BuildCard(
                      cardColor: AppColors.kCardBg,
                      childWidget: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoutes.printableBill);
                        },
                        child: Padding(
                            padding: EdgeInsets.all(16.h),
                            child: const Text(
                              'Print-Bills',
                              style: AppTextStyles.kw600Black18,
                              textAlign: TextAlign.center,
                            ),),
                      ),
                    ),
                  ),
                  8.horizontalSpace,
                  Expanded(
                    flex: 3,
                    child: BuildCard(
                      cardColor: AppColors.kPrimaryLightBg,
                      childWidget: InkWell(
                        onTap: () {
                          // Navigator.of(context).pushNamed(AppRoutes.allSales);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(16.h),
                          child: const Text(
                            'Print-Bills',
                            style: AppTextStyles.kw600Black18,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: PrimaryButton(
        buttonName: 'Create - Bill',
        onClickfunction: () {
          Navigator.pushNamed(context, AppRoutes.createStore);
        },
        kSize: Size(0.4.sw, 56.h),
      ),
    );
  }


  _buildButton(
    String label,
    String type,
  ) {
    return BlocBuilder<BillBloc, BillState>(builder: (context, state) {
      bool isSelected = selectedType == type;
      print('isSelected : $isSelected');
      return GestureDetector(
        onTap: () {
          final bloc = context.read<BillBloc>();
          switch (type) {
            case 'Day':
              bloc.add(LoadDayGraph());
              break;
            case 'Week':
              bloc.add(LoadWeekGraph());
              break;
            case 'Month':
              bloc.add(LoadMonthGraph());
              break;
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.kBlue.withOpacity(0.4)
                : AppColors.kOutline.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: isSelected ? AppColors.kBlue : AppColors.kOutline),
          ),
          child: Text(
            isSelected
                ? '$label - ₹ ${state is GraphState ? state.total.toStringAsFixed(0) : ''}'
                : label,
            style: isSelected
                ? AppTextStyles.kw600White14
                : AppTextStyles.kw400Black14,
          ),
        ),
      );
    });
  }
}
