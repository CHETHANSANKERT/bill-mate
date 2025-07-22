import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../components/ui/app_colors.dart';
import '../main.dart';

/// State of the snackbar
enum SnackbarState {
  info,
  warning,
  error,
  success,
  defaultState,
}

/// App themed snackbar
void appSnackbar({
  required String message,
  SnackbarState snackbarState = SnackbarState.warning,
  BuildContext? context,
}) {
  final snackbar = SnackBar(
    content: Row(
      children: [
        Icon(
          _snackbarIcon(snackbarState),
          color: _snackbarTextColor(snackbarState),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: _snackbarTextColor(snackbarState),
            ),
          ),
        ),
      ],
    ),
    backgroundColor: _snackbarColor(snackbarState),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.r),
    ),
  );
  context != null
      ? ScaffoldMessenger.of(context).showSnackBar(snackbar)
      : scaffoldMessengerKey.currentState?.showSnackBar(snackbar);
}

Color _snackbarColor(SnackbarState snackbarState) {
  switch (snackbarState) {
    case SnackbarState.info:
      return Colors.blue.shade100;
    case SnackbarState.warning:
      return AppColors.kPrimaryLightBg;
    case SnackbarState.error:
      return AppColors.kError.withOpacity(0.3);
    case SnackbarState.defaultState:
      return Colors.blueGrey.shade100;
    case SnackbarState.success:
      return AppColors.kSuccessBg;
  }
}

Color _snackbarTextColor(SnackbarState snackBarState) {
  switch (snackBarState) {
    case SnackbarState.info:
      return Colors.blue;
    case SnackbarState.warning:
      return AppColors.kWarning;
    case SnackbarState.error:
      return AppColors.kError;
    case SnackbarState.defaultState:
      return Colors.blueGrey;
    case SnackbarState.success:
      return AppColors.kSuccess;
  }
}

IconData _snackbarIcon(SnackbarState snackbarState) {
  switch (snackbarState) {
    case SnackbarState.info:
      return Icons.info;
    case SnackbarState.warning:
      return Icons.info_outline;
    case SnackbarState.error:
      return Icons.error;
    case SnackbarState.defaultState:
      return Icons.notifications_active;
    case SnackbarState.success:
      return Icons.check_circle;
  }
}
