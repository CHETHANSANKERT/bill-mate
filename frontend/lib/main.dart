import 'package:bill_mate/bloc/bill/bill_bloc.dart';
import 'package:bill_mate/bloc/create_bill/create_bill_bloc.dart';
import 'package:bill_mate/bloc/store/store_bloc.dart';
import 'package:bill_mate/components/ui/app_colors.dart';
import 'package:bill_mate/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import 'bloc/login/login_bloc.dart';
import 'constants/design_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  onLoadApp();

  runApp(const MyApp());
}

Future<void> onLoadApp() async {

  /// Request storage permission
  await _requestStoragePermission();

  /// for adding an auto backup feature
  // await Workmanager().initialize(_callbackDispatcher);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: AppColors.kStatusBar,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
}

Future<void> _requestStoragePermission() async {
  final status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
        BlocProvider<BillBloc>(create: (context) => BillBloc()),
        BlocProvider<CreateBillBloc>(create: (context) => CreateBillBloc()),
        BlocProvider<StoreBloc>(create: (context) => StoreBloc()),
      ],
      child: SafeArea(
        child: ScreenUtilInit(
          designSize: const Size(DesignsSize.width, DesignsSize.height),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            scaffoldMessengerKey: scaffoldMessengerKey,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            initialRoute: AppRoutes.home,
            onGenerateRoute: AppPages.generateRoute,
          ),
        ),
      ),
    );
  }
}
