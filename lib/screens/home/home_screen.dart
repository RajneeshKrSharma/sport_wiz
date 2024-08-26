import 'package:flutter/material.dart';
import 'package:flutter_learning/models/SportImageTextCardModel.dart';
import 'package:flutter_learning/navigation/route_name.dart';
import 'package:flutter_learning/res/color.dart';
import 'package:flutter_learning/screens/sports/sport.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<SportInfo> sportImageTextCardInfo = [];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    switch(index) {
      case 2: {
        Navigator.of(context).pushNamed(RouteNames.PURCHASE_HISTORY_SCREEN);
      }
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appWhite,
        title: const Text("SportWiz"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Sports News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Purchase History',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(RouteNames.SPORT_SHOP_SCREEN);
        },
        tooltip: 'Puchase Bag',
        child: const Icon(Icons.shopping_bag),
      ),
      body: Sports(),
    );
  }
}
