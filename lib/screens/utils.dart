import 'package:flutter_learning/screens/purchase_history/purchased_history_model.dart';
import 'package:flutter_learning/screens/sports_shop/SportsShopResponse.dart';
import 'package:intl/intl.dart';

enum ButtonShrinkStatus{notStarted, started, over}

String getCurrentTimeInIndia() {
  final now = DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));
  final formatter = DateFormat('dd MMM, yyyy HH:mm:ss aa');
  return formatter.format(now);
}

double getTotalCartValue(List<SportsItems?> value) {
  double total = 0.0;
  for (var item in value) {
    String mrp = item?.itemMrp?.split(" ")[1] ?? "0.0";
    int qty = item?.quantity ?? 0;
    double totalMrp = double.parse(mrp) *  qty;
    total += totalMrp;
  }
  return double.parse(total.toStringAsFixed(2));
}

int getTotalQtyValue(List<SportsItems?> value) {
  int total = 0;
  for (var item in value) {
    total += item?.quantity ?? 0;
  }
  return total;
}

double getTotalPurchasedValue(List<PurchasedItems> value) {
  double total = 0.0;
  for (var item in value) {
    String mrp = item?.itemMrp?.split(" ")[1] ?? "0.0";
    int qty = item?.quantity ?? 0;
    double totalMrp = double.parse(mrp) *  qty;
    total += totalMrp;
  }
  return double.parse(total.toStringAsFixed(2));
}