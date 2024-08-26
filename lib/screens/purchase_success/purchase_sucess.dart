import 'package:flutter/material.dart';
import 'package:flutter_learning/navigation/route_name.dart';
import 'package:velocity_x/velocity_x.dart';

class PurchaseSuccess extends StatelessWidget {
  const PurchaseSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacementNamed(RouteNames.PURCHASE_HISTORY_SCREEN);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_rounded, size: 72, color: Colors.green).pSymmetric(h: 16, v: 16),
            const Text("Yup ! Order placed successfully.", style: TextStyle(color: Colors.black,
                fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
