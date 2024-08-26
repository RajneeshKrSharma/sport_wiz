import 'package:flutter_learning/database/db.dart';
import 'package:flutter_learning/screens/purchase_history/purchased_history_model.dart';
import 'package:flutter_learning/screens/sports_shop/SportsShopResponse.dart';
import 'package:sembast/sembast.dart';

class DatabaseDao {
  // Private constructor
  DatabaseDao._internal();

  // Static instance of the class
  static final DatabaseDao _instance = DatabaseDao._internal();

  // Factory constructor to return the singleton instance
  factory DatabaseDao() {
    return _instance;
  }

  Future<void> saveSportItems(SportsItems sportItem) async {
    final db = await SportsDb().db;
    final store = intMapStoreFactory.store('sport_items');
    await store.add(db, sportItem.toJson());
  }

  Future<List<SportsItems>> getSportItemsByCategory(String category) async {
    final db = await SportsDb().db;
    final store = intMapStoreFactory.store('sport_items');

    final finder = Finder(
      filter: Filter.equals('itemCategory', category),
    );

    final records = await store.find(db, finder: finder);

    return records.map((record) {
      return SportsItems.fromJson(record.value);
    }).toList();
  }

  // Update operation
  /*Future<int> updateSportItemQuantity(SportsItems sportItem) async {
    final db = await SportsDb().db;
    final store = intMapStoreFactory.store('sport_items');

    final finder = Finder(
      filter: Filter.equals('sportItemName', sportItem),
    );

    return await store.update(db, sportItem.toJson(), finder: finder);
  }*/

  // Delete operation
  Future<int> deleteSportItem(String sportItemName) async {
    final db = await SportsDb().db;
    final store = intMapStoreFactory.store('sport_items');

    final finder = Finder(
      filter: Filter.equals('itemName', sportItemName),
    );

    return await store.delete(db, finder: finder);
  }

  Future<int> deleteAllSportItems() async {
    final db = await SportsDb().db;
    final store = intMapStoreFactory.store('sport_items');

    // Delete all records in the store
    return await store.delete(db);
  }

  Future<List<SportsItems>> getAllSportItems() async {
    final db = await SportsDb().db;
    final store = intMapStoreFactory.store('sport_items');

    final records = await store.find(db);

    return records.map((record) {
      return SportsItems.fromJson(record.value);
    }).toList();
  }

  Future<void> savePurchasedItems(PurchasedItems sportItem) async {
    final db = await SportsDb().db;
    final store = intMapStoreFactory.store('purchase_items');
    await store.add(db, sportItem.toJson());
  }

  Future<List<PurchasedItems>> getPurchasedItemsByOrderNo(String orderNumber) async {
    final db = await SportsDb().db;
    final store = intMapStoreFactory.store('purchase_items');

    final finder = Finder(
      filter: Filter.equals('orderNumber', orderNumber),
    );

    final records = await store.find(db, finder: finder);

    return records.map((record) {
      return PurchasedItems.fromJson(record.value);
    }).toList();
  }

  Future<void> saveAllPurchasedItems(List<PurchasedItems> purchasedItems) async {
    final db = await SportsDb().db;
    final store = intMapStoreFactory.store('purchase_items');

    // Using batch operation to save all items at once
    await db.transaction((txn) async {
      for (PurchasedItems item in purchasedItems) {
        await store.add(txn, item.toJson());
      }
    });
  }

  Future<List<PurchasedItems>> getAllPurchasedItems() async {
    final db = await SportsDb().db;
    final store = intMapStoreFactory.store('purchase_items');

    final records = await store.find(db);

    return records.map((record) {
      return PurchasedItems.fromJson(record.value);
    }).toList();
  }

  Future<int> deleteAllPurchaseItems() async {
    final db = await SportsDb().db;
    final store = intMapStoreFactory.store('purchase_items');
    return await store.delete(db);
  }

}
