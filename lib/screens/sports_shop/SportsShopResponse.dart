class SportsShopResponse {
  List<SportsShop>? sportsShop;

  SportsShopResponse({this.sportsShop});

  SportsShopResponse.fromJson(Map<String, dynamic> json) {
    if (json['sports_shop'] != null) {
      sportsShop = <SportsShop>[];
      json['sports_shop'].forEach((v) {
        sportsShop!.add(new SportsShop.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sportsShop != null) {
      data['sports_shop'] = this.sportsShop!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SportsShop {
  String? sportsCategory;
  String? sportsCategoryImage;
  List<SportsItems>? sportsItems;

  SportsShop({this.sportsCategory, this.sportsCategoryImage, this.sportsItems});

  SportsShop.fromJson(Map<String, dynamic> json) {
    sportsCategory = json['sports_category'];
    sportsCategoryImage = json['sport_category_image'];
    if (json['sports_items'] != null) {
      sportsItems = <SportsItems>[];
      json['sports_items'].forEach((v) {
        sportsItems!.add(new SportsItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sports_category'] = this.sportsCategory;
    data['sport_category_image'] = this.sportsCategoryImage;
    if (this.sportsItems != null) {
      data['sports_items'] = this.sportsItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SportsItems {
  String? itemName;
  String? itemImage;
  String? itemMrp;
  String? itemCategory;
  String? dateTime;
  int? quantity;

  SportsItems({this.itemName, this.itemImage, this.itemMrp, this.itemCategory, this.dateTime, this.quantity});

  SportsItems.fromJson(Map<String, dynamic> json) {
    itemName = json['itemName'];
    itemImage = json['itemImage'];
    itemMrp = json['itemMrp'];
    itemCategory = json['itemCategory'];
    dateTime = json['dateTime'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemName'] = this.itemName;
    data['itemImage'] = this.itemImage;
    data['itemMrp'] = this.itemMrp;
    data['itemCategory'] = this.itemCategory;
    data['dateTime'] = this.dateTime;
    data['quantity'] = this.quantity;
    return data;
  }

  SportsItems withCopy({
    String? itemName,
    String? itemImage,
    String? itemMrp,
    String? itemCategory,
    String? dateTime,
    int? quantity,
  }) {
    return SportsItems(
      itemName: itemName ?? this.itemName,
      itemImage: itemImage ?? this.itemImage,
      itemMrp: itemMrp ?? this.itemMrp,
      itemCategory: itemCategory ?? this.itemCategory,
      dateTime: dateTime ?? this.dateTime,
      quantity: quantity ?? this.quantity,
    );
  }
}
