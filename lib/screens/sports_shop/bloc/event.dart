import 'package:flutter/cupertino.dart';

abstract class SportShopEvent {}

class SportShopApi extends SportShopEvent {
  BuildContext context;
  SportShopApi({required this.context});
}

class SportItemsInParticularCategories extends SportShopEvent {
  String sportCategory;
  SportItemsInParticularCategories({required this.sportCategory});
}