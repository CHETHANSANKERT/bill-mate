import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class VirtualKeyboard extends StatelessWidget {
  final TextEditingController otpController;
  final VoidCallback? onApprove;
  final int maxNumber;

  const VirtualKeyboard(
      {super.key,
      required this.otpController,
      this.onApprove,
      this.maxNumber = 4});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 16 / 9,
      children: [
        _buildKey(context: context, label: '1'),
        _buildKey(context: context, label: '2'),
        _buildKey(context: context, label: '3'),
        _buildKey(context: context, label: '4'),
        _buildKey(context: context, label: '5'),
        _buildKey(context: context, label: '6'),
        _buildKey(context: context, label: '7'),
        _buildKey(context: context, label: '8'),
        _buildKey(context: context, label: '9'),
        _buildKey(
            context: context,
            label: '<-',
            onTap: () {
              otpController.text = otpController.text.isNotEmpty
                  ? otpController.text
                      .substring(0, otpController.text.length - 1)
                  : '';
            }),
        _buildKey(context: context, label: '0'),
        _buildKey(context: context, label: '->', onTap: onApprove),
      ],
    );
  }

  Widget _buildKey(
      {required BuildContext context,
      required String label,
      VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ??
          () {
            if (otpController.text.length < maxNumber) {
              otpController.text += label;
            }
          },
      child: Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppColors.kPrimary,
              Color.fromARGB(129, 104, 58, 183),
            ], // Darker shades of blue
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(50.0), // Circular keys
          boxShadow: const [
            BoxShadow(
              spreadRadius: 5,
              blurRadius: 2,
              blurStyle: BlurStyle.solid,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ),
      ),
    );
  }
}
