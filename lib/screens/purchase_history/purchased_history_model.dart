class PurchasedItems {
  String? orderNumber;
  String? itemName;
  String? itemImage;
  String? itemMrp;
  String? itemCategory;
  String? dateTime;
  int? quantity;

  PurchasedItems({this.orderNumber, this.itemName, this.itemImage, this.itemMrp, this.itemCategory, this.dateTime, this.quantity});

  PurchasedItems.fromJson(Map<String, dynamic> json) {
    orderNumber = json['orderNumber'];
    itemName = json['itemName'];
    itemImage = json['itemImage'];
    itemMrp = json['itemMrp'];
    itemCategory = json['itemCategory'];
    dateTime = json['dateTime'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderNumber'] = this.orderNumber;
    data['itemName'] = this.itemName;
    data['itemImage'] = this.itemImage;
    data['itemMrp'] = this.itemMrp;
    data['itemCategory'] = this.itemCategory;
    data['dateTime'] = this.dateTime;
    data['quantity'] = this.quantity;
    return data;
  }

  PurchasedItems withCopy({
    String? orderNumber,
    String? itemName,
    String? itemImage,
    String? itemMrp,
    String? itemCategory,
    String? dateTime,
    int? quantity,
  }) {
    return PurchasedItems(
      orderNumber: orderNumber ?? this.orderNumber,
      itemName: itemName ?? this.itemName,
      itemImage: itemImage ?? this.itemImage,
      itemMrp: itemMrp ?? this.itemMrp,
      itemCategory: itemCategory ?? this.itemCategory,
      dateTime: dateTime ?? this.dateTime,
      quantity: quantity ?? this.quantity,
    );
  }
}
