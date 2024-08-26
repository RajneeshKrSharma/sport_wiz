import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_learning/screens/sports_shop/SportsCategories.dart';
import 'package:flutter_learning/screens/sports_shop/SportsShopResponse.dart';
import 'package:flutter_learning/screens/sports_shop/sports_shop_logic.dart';
import 'package:flutter_learning/shared_pref.dart';
import 'event.dart';
import 'state.dart';

class SportsShopBloc extends Bloc<SportShopEvent, SportShopState> {
  SportsShopBloc() : super(SportShopInitial()) {
    on<SportShopApi>(_onSportShopApiEvent);
    on<SportItemsInParticularCategories>(_onSportItemsInParticularCategories);
  }


  _onSportShopApiEvent(SportShopApi event, Emitter<SportShopState> emit) async {
    emit(SportShopCategoriesLoading());
    BuildContext context      = event.context;

    var response = await SportsShopLogic.callSportsShopApi(context);

    try {
      response.when(idle: () {

      },
          networkFault: (value) {
            emit(SportShopError(
                errorMessage: value["occurredErrorDescriptionMsg"]));
          },
          responseSuccess: (value) {
            SportsShopResponse successResponse = value as SportsShopResponse;
            SharedPrefUtils.setUserStringValue(SharedPrefUtils.sportShopResponse, jsonEncode(successResponse));
            context.read<SportShopCategoriesCubit>().loadSportsCategory();
          },
          responseFailure: (value) {
            emit(SportShopError(errorMessage: "error msg"));
          },
          failure: (value) {
            emit(SportShopError(errorMessage: value["occurredErrorDescriptionMsg"]));
          });
    } catch (e) {
      print("error=========> $e");
    }
  }

  _onSportItemsInParticularCategories(SportItemsInParticularCategories event, Emitter<SportShopState> emit) {
    emit(SportShopItemInParticularCategoriesLoading());
    final savedResponse = SharedPrefUtils.getUserStringValue(SharedPrefUtils.sportShopResponse);
    var respObj = SportsShopResponse.fromJson(jsonDecode(savedResponse));
    if(savedResponse.isNotEmpty) {

    } else {

    }
  }
}

class SportShopCategoriesCubit extends Cubit<SportShopState> {
  SportShopCategoriesCubit() : super(SportShopCategoriesLoading());

  void loadSportsCategory() async {
    final savedResponse = SharedPrefUtils.getUserStringValue(SharedPrefUtils.sportShopResponse);
    if(savedResponse.isNotEmpty) {
      var respObj = SportsShopResponse.fromJson(jsonDecode(savedResponse));
      if (respObj.sportsShop?.isNotEmpty == true) {
        List<SportsCategories> list = [];
        respObj.sportsShop?.forEach((shopItem) {
          if(shopItem.sportsCategory != null) {
            list.add(SportsCategories(
              shopItem.sportsCategory ?? "",
              shopItem.sportsCategoryImage ?? "",
            ));
          }
        });
        emit(SportCategoriesSuccess(result: list));
      }
    }
  }
}

class SportShopItemInParticularCategoriesCubit extends Cubit<SportShopState> {
  SportShopItemInParticularCategoriesCubit() : super(SportShopCategoriesLoading());

  void loadItemsInCategory(String category) async {
    final savedResponse = SharedPrefUtils.getUserStringValue(SharedPrefUtils.sportShopResponse);
    if(savedResponse.isNotEmpty) {
      var respObj = SportsShopResponse.fromJson(jsonDecode(savedResponse));
      if (respObj.sportsShop?.isNotEmpty == true) {
        List<SportsShop>? itemList = respObj.sportsShop?.where((sportsShop) => sportsShop.sportsCategory == category).toList();
        if(itemList!=null && itemList.isNotEmpty) {
          emit(SportItemsInCategoriesSuccess(result: itemList[0].sportsItems ?? []));
        }
      }
    }
  }
}
