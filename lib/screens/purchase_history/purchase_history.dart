import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_learning/database/dao.dart';
import 'package:flutter_learning/res/color.dart';
import 'package:flutter_learning/screens/purchase_history/purchased_history_model.dart';
import 'package:flutter_learning/screens/sports_shop/SportsShopResponse.dart';
import 'package:flutter_learning/screens/utils.dart';
import 'package:velocity_x/velocity_x.dart';

class PurchaseHistory extends StatefulWidget {
  const PurchaseHistory({super.key});

  @override
  State<PurchaseHistory> createState() => _PurchaseHistoryState();
}

class _PurchaseHistoryState extends State<PurchaseHistory> {
  final ValueNotifier<List<List<PurchasedItems>>> _purchasedSportItem = ValueNotifier<List<List<PurchasedItems>>>([]);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final dbDao = DatabaseDao();
    dbDao.getAllPurchasedItems().then((value) {
      // Step 1: Group items by a composite key of category and date
      /*var groupedByCategoryAndDate = groupBy(
        value,
            (PurchasedItems item) => '${item.itemCategory}_${item.dateTime}',
      );*/
      var groupedByCategoryAndDate = groupBy(
        value,
            (PurchasedItems item) => '${item.dateTime}',
      );

      // Step 2: Convert the grouped map values to a list of lists
      List<List<PurchasedItems>> categorizedList = groupedByCategoryAndDate.values.toList();

      // Step 3: Assign the categorized list to _purchasedSportItem
      _purchasedSportItem.value = categorizedList;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text(
          'Purchase History',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 4,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black87),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ValueListenableBuilder<List<List<PurchasedItems>>>(
            valueListenable: _purchasedSportItem,
            builder: (context, purchasedItems, child) {
              if (purchasedItems.isEmpty) {
                return const Center(
                  child: Text(
                    'No purchase history available.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: purchasedItems.length,
                itemBuilder: (context, index) {
                  final particularPurchasedList = purchasedItems[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    elevation: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Sport Order",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                "${particularPurchasedList[0].dateTime}",
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ).pSymmetric(h: 16, v: 8),
                          ExpansionTile(
                            title: Text(
                              "Order No: ${particularPurchasedList[0].orderNumber}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: appDarkGreen,
                              ),
                            ),
                            children: [
                              Column(
                                children: List.generate(particularPurchasedList.length, (itemIndex) {
                                  return Card(
                                    color: appWhite,
                                    elevation: 2,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          height: 80,
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius
                                                .circular(10),
                                            child: Image.network(
                                              fit: BoxFit.cover,
                                              "${particularPurchasedList[itemIndex].itemImage}",
                                              loadingBuilder: (context, child, progress) {
                                                if (progress == null) {
                                                  return child;
                                                } else {
                                                  final percentage = (progress.cumulativeBytesLoaded / (progress.expectedTotalBytes ?? 1)) * 100;
                                                  return Center(
                                                    child: Stack(
                                                      alignment: Alignment.center,
                                                      children: [
                                                        CircularProgressIndicator(
                                                          color: Colors.green,
                                                          value: progress.expectedTotalBytes != null
                                                              ? progress.cumulativeBytesLoaded / (progress.expectedTotalBytes ?? 1)
                                                              : null,
                                                        ),
                                                        Text(
                                                          '${percentage.toStringAsFixed(0)}%',
                                                          style: const TextStyle(
                                                            color: Colors.green,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 8,
                                                          ),
                                                        ),
                                                      ],
                                                    ).p(8),
                                                  );
                                                }
                                              },
                                            ).p(2),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("${particularPurchasedList[itemIndex].itemName}", style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                                              Text("${particularPurchasedList[itemIndex].itemMrp}", style: const TextStyle(color: Colors.black, fontSize: 12)),
                                            ],
                                          ).pSymmetric(h: 16),
                                        ),
                                        Container(
                                            decoration: BoxDecoration(
                                                color: Colors.green.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8)
                                            ), child: Text(
                                            "${particularPurchasedList[itemIndex].quantity} piece",
                                            style: const TextStyle(
                                                color: appDarkGreen,
                                                fontSize: 10)).p(8)),
                                      ],
                                    ).p(8),
                                  ).pSymmetric(h: 2, v: 4);
                                }),
                              ).pSymmetric(h: 4),
                              Text("Order Total : Rs ${getTotalPurchasedValue(particularPurchasedList)}", style: const TextStyle(color: Colors.grey,
                                  fontWeight: FontWeight.bold, fontSize: 16)).p(16),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
