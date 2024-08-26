import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_learning/database/dao.dart';
import 'package:flutter_learning/navigation/route_name.dart';
import 'package:flutter_learning/res/color.dart';
import 'package:flutter_learning/screens/sports_shop/SportsShopResponse.dart';
import 'package:flutter_learning/screens/sports_shop/bloc/bloc.dart';
import 'package:flutter_learning/screens/sports_shop/bloc/event.dart';
import 'package:flutter_learning/screens/sports_shop/bloc/state.dart';
import 'package:flutter_learning/screens/utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_x/velocity_x.dart';

class SportShop extends StatefulWidget {
  const SportShop({super.key});

  @override
  State<SportShop> createState() => _SportShopState();
}

class _SportShopState extends State<SportShop> {
  final ValueNotifier<int> _selectedSportCategory = ValueNotifier<int>(0);
  final ValueNotifier<List<SportsItems?>> _cartedSportItem = ValueNotifier<List<SportsItems?>>([]);
  final TextEditingController _quantityController = TextEditingController();

  List<TextEditingController> _controllers = [];

  final dbDao = DatabaseDao();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SportsShopBloc>(context)
        .add(SportShopApi(context: context));
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    await dbDao.deleteAllSportItems();

  }

  @override
  void dispose() {
    _selectedSportCategory.dispose();
    _cartedSportItem.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Sport Shop',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 4,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black87),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: const Text(
                      maxLines: 1,
                      "Shop sports product !",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: appDarkGreen,
                        fontSize: 14,
                      ),
                    ).p(8),
                  ),
                  ValueListenableBuilder<List<SportsItems?>>(
                      valueListenable: _cartedSportItem,
                      builder: (context, selectedCategory, child) {
                        return Visibility(
                          visible: _cartedSportItem.value.isNotEmpty,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border:
                              Border.all(width: 1, color: const Color(0xFF006400)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.shopping_cart).p(3),
                                Text(
                                  "${getTotalQtyValue(_cartedSportItem.value)} Items \n Rs ${getTotalCartValue(_cartedSportItem.value)}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: appDarkGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ).p(4),
                          ).pOnly(right: 8),
                        ).pSymmetric(h: 2, v: 8);
                      })
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 80,
                            child: BlocBuilder<SportShopCategoriesCubit, SportShopState>(
                              builder: (context, state) {
                                if (state is SportCategoriesSuccess) {
                                  context
                                      .read<
                                      SportShopItemInParticularCategoriesCubit>()
                                      .loadItemsInCategory(
                                      state.result[0].sportsCategory);
                                  return Wrap(
                                    children: List.generate(state.result.length,
                                            (int index) {
                                          return ValueListenableBuilder<int>(
                                            valueListenable: _selectedSportCategory,
                                            builder:
                                                (context, selectedCategory, child) {
                                              return InkWell(
                                                onTap: () {
                                                  _selectedSportCategory.value =
                                                      index;
                                                  context
                                                      .read<
                                                      SportShopItemInParticularCategoriesCubit>()
                                                      .loadItemsInCategory(state
                                                      .result[index]
                                                      .sportsCategory);
                                                },
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 70,
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                        color: selectedCategory ==
                                                            index
                                                            ? Colors.green
                                                            : Colors.grey
                                                            .withOpacity(0.2),
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: ClipRRect(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                              child: Stack(
                                                                children: [
                                                                  // Placeholder image shown while the network image loads
                                                                  Center(child: Icon(Icons.download_for_offline, size: 36, color: Colors.grey.withOpacity(0.4))),
                                                                  Image.network(
                                                                    state.result[index].sportsCategoryImage,
                                                                    fit: BoxFit.cover,
                                                                    width: double.infinity,
                                                                    height: double.infinity,
                                                                    loadingBuilder: (context, child, progress) {
                                                                      if (progress == null) {
                                                                        return child;
                                                                      } else {
                                                                        final percentage = (progress.cumulativeBytesLoaded / (progress.expectedTotalBytes ?? 1)) * 100;
                                                                        return Center(
                                                                          child: SizedBox(
                                                                            width: double.infinity,
                                                                            height: 100,
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
                                                                          ),
                                                                        );
                                                                      }
                                                                    },
                                                                    errorBuilder: (context, error, stackTrace) {
                                                                      return Center(child: Icon(Icons.dnd_forwardslash, size: 36, color: Colors.grey.withOpacity(0.7)));
                                                                    },
                                                                  ),
                                                                ],
                                                              ).p(2),
                                                            ),
                                                          ),
                                                          Text(
                                                            state.result[index]
                                                                .sportsCategory,
                                                            style: TextStyle(
                                                              color:
                                                              selectedCategory ==
                                                                  index
                                                                  ? Colors.white
                                                                  : Colors.grey,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible:
                                                      selectedCategory == index,
                                                      child: Container(
                                                        width: 6,
                                                        height: 80,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                          color: Colors.green,
                                                        ),
                                                      ).pSymmetric(h: 2),
                                                    ),
                                                  ],
                                                ).pSymmetric(v: 4),
                                              );
                                            },
                                          );
                                        }),
                                  );
                                }
                                return Wrap(
                                  children: List.generate(15, (int index) {
                                    return Shimmer.fromColors(
                                      period:
                                      const Duration(milliseconds: 1000),
                                      baseColor: Colors.grey[400]!,
                                      highlightColor: Colors.grey[200]!,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[400]!,
                                              borderRadius:
                                              const BorderRadius.only(
                                                topLeft: Radius.circular(6),
                                                topRight: Radius.circular(6),
                                              ),
                                            ),
                                          ).pOnly(bottom: 2),
                                          Container(
                                            width: 80,
                                            height: 10,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[400]!,
                                              borderRadius:
                                              const BorderRadius.only(
                                                bottomLeft: Radius.circular(6),
                                                bottomRight: Radius.circular(6),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ).pSymmetric(v: 4);
                                  }),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: MediaQuery.of(context).size.height,
                      color: Colors.grey.withOpacity(0.3),
                    ).pSymmetric(h: 8),
                    Expanded(
                      child: BlocBuilder<
                          SportShopItemInParticularCategoriesCubit,
                          SportShopState>(
                        builder: (context, state) {
                          if (state is SportItemsInCategoriesSuccess) {
                            _controllers = List.generate(state.result.length,
                                    (index) => TextEditingController(text: "0"));
                            return SingleChildScrollView(
                              child: Wrap(
                                  children: List.generate(state.result.length,
                                          (int index) {
                                        return Container(
                                          width: (MediaQuery.of(context).size.width -
                                              130) /
                                              2,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey.withOpacity(0.7),
                                                  width: 1),
                                              borderRadius: BorderRadius.circular(8)),
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(6),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(6),
                                                  child: Stack(
                                                    children: [
                                                      // Placeholder image shown while the network image loads
                                                      SizedBox(
                                                          width: double.infinity,
                                                          height: 100,
                                                          child: Center(child: Icon(Icons.download_for_offline, size: 36, color: Colors.grey.withOpacity(0.4)))
                                                      ),
                                                      Image.network(
                                                        "${state.result[index].itemImage}",
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                        height: 100,
                                                        loadingBuilder: (context, child, progress) {
                                                          if (progress == null) {
                                                            return child;
                                                          } else {
                                                            final percentage = (progress.cumulativeBytesLoaded / (progress.expectedTotalBytes ?? 1)) * 100;
                                                            return Center(
                                                              child: SizedBox(
                                                                width: double.infinity,
                                                                height: 100,
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
                                                              ),
                                                            );
                                                          }
                                                        },
                                                        errorBuilder: (context, error, stackTrace) {
                                                          return SizedBox(
                                                              width: double.infinity,
                                                              height: 100,
                                                              child: Center(child: Icon(Icons.download_for_offline, size: 36, color: Colors.grey.withOpacity(0.4)))
                                                          );
                                                        },
                                                      ),
                                                    ],
                                                  ).p(2)

                                                ).pSymmetric(h: 4, v: 2),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.deepPurpleAccent
                                                            .withOpacity(0.1),
                                                        borderRadius:
                                                        BorderRadius.circular(6)),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "${state.result[index].itemName}",
                                                          style: const TextStyle(
                                                            color: Colors.deepPurple,
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 4.0),
                                                          child: Align(
                                                            alignment:
                                                            Alignment.centerRight,
                                                            child: Text(
                                                              "${state.result[index].itemMrp}",
                                                              style: const TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                FontWeight.w800,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ).pSymmetric(h: 8),
                                                  ).pSymmetric(h: 4),
                                                  Container(
                                                    width: 130,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.grey, width: 1),
                                                      borderRadius:
                                                      BorderRadius.circular(6),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: IconButton(
                                                            icon: const Icon(
                                                                Icons.remove,
                                                                size: 14,
                                                                color: Colors.black),
                                                            onPressed: () async {
                                                              List<SportsItems?> currentList = List.from(_cartedSportItem.value);
                                                              SportsItems? itemInCart = currentList.firstWhere((i) => i?.itemName == state.result[index].itemName, orElse: () => null);

                                                              if (itemInCart != null) {
                                                                if (itemInCart.quantity != null && itemInCart.quantity! > 1) {
                                                                  itemInCart.quantity = itemInCart.quantity! - 1;
                                                                  currentList[currentList.indexOf(itemInCart)] = itemInCart.withCopy(quantity: itemInCart.quantity);
                                                                  _cartedSportItem.value = currentList;
                                                                  _controllers[index].text = itemInCart.quantity.toString();
                                                                  await dbDao.saveSportItems(currentList[currentList.indexOf(itemInCart)]!.withCopy(dateTime: getCurrentTimeInIndia()));
                                                                } else {
                                                                  currentList.remove(itemInCart);
                                                                  _cartedSportItem.value = currentList;
                                                                  _controllers[index].text = '0';
                                                                  await dbDao.deleteSportItem(itemInCart.itemName!); // Remove item from database
                                                                }
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 30,
                                                          child: TextField(
                                                            controller: _controllers[index],
                                                            textAlign: TextAlign.center,
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .digitsOnly,
                                                            ],
                                                            enabled: false,
                                                            maxLines: 1,
                                                            keyboardType:
                                                            TextInputType.number,
                                                            decoration:
                                                            const InputDecoration(
                                                              border:
                                                              OutlineInputBorder(),
                                                              contentPadding:EdgeInsets.all(0),
                                                              enabledBorder:
                                                              OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors.grey),
                                                              ),
                                                              focusedBorder:
                                                              OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors.grey),
                                                              ),
                                                            ),
                                                            style: const TextStyle(
                                                              fontSize: 12,
                                                              // Set your desired font size here
                                                              color: Colors.black,
                                                            ),
                                                            cursorColor: Colors
                                                                .grey, // Prevents any interactions with the TextField
                                                          ).p(2),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: IconButton(
                                                            icon: const Icon(Icons.add,
                                                                size: 14,
                                                                color: Colors.black),
                                                            onPressed: () async {

                                                              List<SportsItems?> currentList = List.from(_cartedSportItem.value);
                                                              SportsItems? itemInCart = currentList.firstWhere((i) => i?.itemName == state.result[index].itemName, orElse: () => null);

                                                              if (itemInCart != null) {
                                                                if(itemInCart.quantity != null) {
                                                                  itemInCart.quantity = itemInCart.quantity! + 1;
                                                                  currentList.remove(itemInCart);
                                                                  currentList.add(itemInCart.withCopy(quantity: itemInCart.quantity));
                                                                  _cartedSportItem.value = currentList;
                                                                  _controllers[index].text = itemInCart.quantity.toString();
                                                                  if(itemInCart.itemName != null) {
                                                                    await dbDao.deleteSportItem(itemInCart.itemName ?? "");
                                                                    await dbDao.saveSportItems(itemInCart.withCopy(dateTime: getCurrentTimeInIndia()));
                                                                  }
                                                                }

                                                              } else {
                                                                state.result[index].quantity = 1; // Add quantity property if not present
                                                                currentList.add(state.result[index]);
                                                                _cartedSportItem.value = currentList;
                                                                _quantityController.text = '1';
                                                                _controllers[index].text = '1';
                                                                await dbDao.saveSportItems(state.result[index].withCopy(dateTime: getCurrentTimeInIndia()));
                                                              }
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ).pSymmetric(h: 4, v: 8),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ).p(4);
                                      })),
                            );
                          }
                          return SingleChildScrollView(
                            child: Wrap(
                              children: List.generate(15, (int index) {
                                return Container(
                                  width:
                                  (MediaQuery.of(context).size.width - 130) /
                                      2,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400]!,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Shimmer.fromColors(
                                    period: const Duration(milliseconds: 800),
                                    baseColor: Colors.grey[400]!,
                                    highlightColor: Colors.grey[200]!,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 130,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400]!,
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(6),
                                              topRight: Radius.circular(6),
                                            ),
                                          ),
                                        ).p(2),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey[400]!,
                                                  borderRadius:
                                                  BorderRadius.circular(6)),
                                              child: const Column(
                                                children: [
                                                  Text(
                                                    "",
                                                    style: TextStyle(
                                                      color: Colors.deepPurple,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                    Alignment.centerRight,
                                                    child: Text(
                                                      "",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.w800,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ).pSymmetric(h: 2, v: 4),
                                            Container(
                                              width: 130,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey, width: 1),
                                                borderRadius:
                                                BorderRadius.circular(6),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ).p(4),
                                  ).pSymmetric(v: 4),
                                ).pSymmetric(v: 2, h: 2);
                              }),
                            ),
                          );
                        },

                      ),
                    ),
                  ],
                ).p(8),
              ),
              ValueListenableBuilder(
                  valueListenable: _cartedSportItem, builder: (context, v, child) {
                return Visibility(
                    visible: _cartedSportItem.value.isNotEmpty,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(RouteNames.CART_SCREEN);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.deepPurpleAccent,
                                borderRadius: BorderRadius.circular(60)),
                            child: const SizedBox(
                                width: 280,
                                height: 50.0,
                                child: Center(
                                  child: Text(
                                    "Go to Cart",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ))),
                      ).p(16),
                    )
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
