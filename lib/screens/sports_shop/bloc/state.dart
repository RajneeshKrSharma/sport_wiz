import 'package:flutter_learning/screens/sports_shop/SportsCategories.dart';
import 'package:flutter_learning/screens/sports_shop/SportsShopResponse.dart';

abstract class SportShopState {}

class SportShopInitial extends SportShopState {}

class SportShopLoading extends SportShopState{}

class SportShopCategoriesLoading extends SportShopState{}

class SportShopItemInParticularCategoriesLoading extends SportShopState{}

class SportShopSuccess extends SportShopState{
  SportsShopResponse? response;

  SportShopSuccess({required this.response});
}

class SportCategoriesSuccess extends SportShopState{
  List<SportsCategories> result;

  SportCategoriesSuccess({required this.result});
}

class SportItemsInCategoriesSuccess extends SportShopState{
  List<SportsItems> result;

  SportItemsInCategoriesSuccess({required this.result});
}

class SportShopError extends SportShopState{
  String errorMessage;

  SportShopError({required this.errorMessage});
}