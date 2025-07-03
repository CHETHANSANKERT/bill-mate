import 'package:bill_mate/screens/bills/all_sales.dart';
import 'package:bill_mate/screens/bills/prinitable_bill_screen.dart';
import 'package:bill_mate/screens/create_bill/all_items.dart';
import 'package:bill_mate/screens/store/all_stores.dart';
import 'package:bill_mate/screens/bills/billing_home_screen.dart';
import 'package:bill_mate/screens/create_bill/add_products.dart';
import 'package:bill_mate/screens/store/create_store.dart';
import 'package:bill_mate/utils/common_utils.dart';
import 'package:flutter/material.dart';

part 'app_routes.dart';

class AppPages {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    CommonUtility.printMsg('CHANGING ROUTE TO : ${settings.name}');
    switch (settings.name) {
      case AppRoutes.home:
        return _createRoute(const BillingHomeScreen());
      case AppRoutes.createStore:
        return _createRoute(const CreateStore());
      case AppRoutes.addProducts:
        final args = settings.arguments as Map<String, dynamic>;
        return _createRoute(AddProducts(
          storeName: args['storeName'],
          ownerName: args['ownerName'],
          location: args['location'],
          area: args['area'],
          beat: args['beat'],
          address: args['address'],
          gstNumber: args['gstNumber'],
          storeId: args['storeId'],
        ));
      case AppRoutes.allSales:
        return _createRoute(const AllSalesScreen());
      case AppRoutes.allStores:
        return _createRoute(const AllStoresScreen());
      case AppRoutes.printableBill:
        return _createRoute(const PrintableBillScreen());
      case AppRoutes.allItems:
        return _createRoute(const AllItemsScreen());
      default:
        return _createRoute(const BillingHomeScreen());
    }
  }

  static Route<dynamic> _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var opacityAnimation = animation.drive(tween);

        return FadeTransition(
          opacity: opacityAnimation,
          child: child,
        );
      },
    );
  }
}

navigateOffNamed(
  BuildContext context,
  String route,
) {
  return Navigator.of(context).pushReplacementNamed(route);
}

navigateTo(BuildContext context, String route) {
  return Navigator.of(context).pushNamed(route);
}

navigateOffTo(
  BuildContext context,
  Widget route,
) {
  return Navigator.of(context).pushReplacement(AppPages._createRoute(route));
}

navigateUntil(
  BuildContext context,
  String givenRoute,
) {
  Navigator.of(context).pushNamedAndRemoveUntil(
    givenRoute,
    (route) => false,
  );
  // return Navigator.of(context).popUntil(ModalRoute.withName(givenRoute));
}
