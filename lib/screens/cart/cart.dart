import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_learning/database/dao.dart';
import 'package:flutter_learning/navigation/route_name.dart';
import 'package:flutter_learning/res/color.dart';
import 'package:flutter_learning/screens/purchase_history/purchased_history_model.dart';
import 'package:flutter_learning/screens/sports_shop/SportsShopResponse.dart';
import 'package:flutter_learning/screens/utils.dart';
import 'package:velocity_x/velocity_x.dart';

class CartScreen extends StatefulWidget {
  
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final dbDao = DatabaseDao();
  
  final ValueNotifier<List<SportsItems>> cartedListOfItems = ValueNotifier<List<SportsItems>>([]);
  final ValueNotifier<double> _animatedButton = ValueNotifier<double>(300);
  final ValueNotifier<ButtonShrinkStatus> _buttonShrinkStatus = ValueNotifier<ButtonShrinkStatus>(ButtonShrinkStatus.notStarted);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dbDao.getAllSportItems().then((value) {
      cartedListOfItems.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Product cart'),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ValueListenableBuilder(
        valueListenable: cartedListOfItems,
        builder: (context, v, child) {
          return SafeArea(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: cartedListOfItems.value.isNotEmpty
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: RichText(
                      maxLines: 1,
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        children: [
                          const TextSpan(text: "You have picked "),
                          TextSpan(
                            text: "${cartedListOfItems.value.length}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: appDarkGreen, // Change this to your desired color
                            ),
                          ),
                          const TextSpan(text: " products . . "),
                        ],
                      ),
                    ).pSymmetric(h: 4, v: 4),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: cartedListOfItems.value.length,
                        itemBuilder: (BuildContext context, int index) {
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
                                      "${cartedListOfItems.value[index].itemImage}",
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
                                      Text("${cartedListOfItems.value[index].itemName}", style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                                      Row(
                                        children: [
                                          Text("${cartedListOfItems.value[index].itemMrp}", style: const TextStyle(color: Colors.black, fontSize: 14)),
                                          const SizedBox(width: 8,),
                                          Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.green.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(8)
                                              ), child: Row(
                                                children: [
                                                  Text(
                                                  "${cartedListOfItems.value[index].quantity} piece",
                                                  style: const TextStyle(
                                                      color: appDarkGreen,
                                                      fontSize: 10)).p(8),
                                                ],
                                              ))
                                        ],
                                      )
                                    ],
                                  ).pSymmetric(h: 16),
                                ),
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {


                                      },
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.blue.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8)
                                          ),
                                        child: const Icon(Icons.edit, size: 14, color: Colors.blue).p(8),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    InkWell(
                                      onTap: () {


                                      },
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.red.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: const Icon(Icons.delete, size: 14, color: Colors.red).p(8),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ).p(8),
                          ).pSymmetric(h: 4, v: 4);
                        }),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1,
                    color: Colors.grey,
                  ).pSymmetric(v: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total", style: TextStyle(color: Colors.black,
                          fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("Rs. ${getTotalCartValue(cartedListOfItems.value)}", style: const TextStyle(color: Colors.black,
                          fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ).p(16),
                  ValueListenableBuilder(
                      valueListenable: _buttonShrinkStatus,
                      builder: (context, selectedCat, child) {
                        return ValueListenableBuilder<double>(
                            valueListenable: _animatedButton,
                            builder:
                                (context, selectedCategory, child) {
                              return InkWell(
                                onTap: () {
                                  _animatedButton.value = 50.0;
                                  _buttonShrinkStatus.value = ButtonShrinkStatus.notStarted;
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: appDarkGreen,
                                        borderRadius: BorderRadius.circular(60)),
                                    child: AnimatedContainer(
                                      width: _animatedButton.value,
                                      height: 50,
                                      onEnd: () {
                                        if (_buttonShrinkStatus.value != ButtonShrinkStatus.over) {
                                          _buttonShrinkStatus.value = ButtonShrinkStatus.started;
                                        } else {
                                          _buttonShrinkStatus.value = ButtonShrinkStatus.notStarted;
                                        }

                                        Future.delayed(const Duration(seconds: 3), () async {
                                          List<PurchasedItems> purchaseItemList = [];
                                          for(var item in cartedListOfItems.value) {
                                            purchaseItemList.add(
                                              PurchasedItems(
                                                orderNumber: "#${generateOrderNumber()}",
                                                itemName: item.itemName,
                                                itemCategory: item.itemCategory,
                                                itemMrp: item.itemMrp,
                                                itemImage: item.itemImage,
                                                quantity: item.quantity,
                                                dateTime: getCurrentTimeInIndia()
                                              )
                                            );
                                          }
                                          if(purchaseItemList.isNotEmpty) {
                                            await dbDao.saveAllPurchasedItems(purchaseItemList);
                                            await dbDao.deleteAllSportItems();
                                          }
                                          Navigator.of(context).pushReplacementNamed(RouteNames.PURCHASE_SUCCESS_SCREEN);
                                        });
                                      },
                                      curve: Curves.easeIn,
                                      duration: const Duration(milliseconds: 200),
                                      child: SizedBox(
                                          width: _animatedButton.value,
                                          height: 50.0,
                                          child: _buttonShrinkStatus.value == ButtonShrinkStatus.started
                                              ? const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: CircularProgressIndicator(
                                                color: Colors.white),
                                          )
                                              : const Center(
                                              child: Visibility(
                                                visible: true,
                                                child: Text(
                                                  "Place Order",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ))),
                                    )
                                ),
                              );
                            }
                        );
                      }
                  ).p(16)
                ],
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_checkout, size: 28, color: Colors.grey,),
                  const Text("No Items Yet", style: TextStyle(color: Colors.orange,
                      fontWeight: FontWeight.bold, fontSize: 24)),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(RouteNames.SPORT_SHOP_SCREEN);

                      },
                      child: const Text("Add items in cart", style: TextStyle(color: Colors.white, fontSize: 18)))
                ],
              ),
            ).p(8),
          );
        },
      ),
    );
  }

  int generateOrderNumber() {
    Random random = Random();
    // Generates a random number between 100000 and 999999
    int orderNumber = 100000 + random.nextInt(900000);
    return orderNumber;
  }
}
