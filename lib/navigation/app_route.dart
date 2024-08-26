import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_learning/navigation/route_name.dart';
import 'package:flutter_learning/screens/cart/cart.dart';
import 'package:flutter_learning/screens/home/home_screen.dart';
import 'package:flutter_learning/screens/purchase_history/purchase_history.dart';
import 'package:flutter_learning/screens/purchase_success/purchase_sucess.dart';
import 'package:flutter_learning/screens/sports_shop/SportShop.dart';
import 'package:flutter_learning/screens/sports_shop/SportsShopResponse.dart';
import 'package:flutter_learning/screens/sports_shop/bloc/bloc.dart';
import '../screens/sports/sport.dart';


class AppRoutes {
  Route<dynamic>? router(RouteSettings setting) {
    switch (setting.name) {
      case RouteNames.HOME_SCREEN:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

        case RouteNames.SPORTS_SCREEN:
        return MaterialPageRoute(builder: (_) => const Sports());

      case RouteNames.PURCHASE_SUCCESS_SCREEN:
        return MaterialPageRoute(builder: (_) => const PurchaseSuccess());

        case RouteNames.CART_SCREEN:
          //var args = setting.arguments as List<SportsItems>;
        return MaterialPageRoute(builder: (_) => CartScreen());

        case RouteNames.PURCHASE_HISTORY_SCREEN:
        return MaterialPageRoute(builder: (_) => PurchaseHistory());

      case RouteNames.SPORT_SHOP_SCREEN:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<SportsShopBloc>(
                  create: (BuildContext context) => SportsShopBloc(),
                ),
                BlocProvider<SportShopCategoriesCubit>(
                  create: (BuildContext context) => SportShopCategoriesCubit(),
                ),
                BlocProvider<SportShopItemInParticularCategoriesCubit>(
                  create: (BuildContext context) => SportShopItemInParticularCategoriesCubit(),
                ),
              ],
              child: const SportShop(),
            )
        );

      default:
        return MaterialPageRoute(builder: (_) => const Sports());
    }
  }
}
