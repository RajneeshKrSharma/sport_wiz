import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_learning/models/SportImageTextCardModel.dart';
import 'package:flutter_learning/ui_utility/ui_utils.dart';
import 'package:velocity_x/velocity_x.dart';

class Sports extends StatefulWidget {
  const Sports({super.key});

  @override
  State<Sports> createState() => _SportsState();
}

class _SportsState extends State<Sports> {
  late List<SportInfo> sportImageTextCardInfo = [];

  @override
  void initState() {
    super.initState();
    const json = '''[
      {"sportImage":"https://t3.ftcdn.net/jpg/02/78/42/76/360_F_278427683_zeS9ihPAO61QhHqdU1fOaPk2UClfgPcW.jpg","sportName":"Soccer","sport category":"Team", "sportItemId":1},
      {"sportImage":"https://t3.ftcdn.net/jpg/02/78/42/76/360_F_278427683_zeS9ihPAO61QhHqdU1fOaPk2UClfgPcW.jpg","sportName":"Badminton","sport category":"Team", "sportItemId":2},
      {"sportImage":"https://t3.ftcdn.net/jpg/02/78/42/76/360_F_278427683_zeS9ihPAO61QhHqdU1fOaPk2UClfgPcW.jpg","sportName":"Athletes","sport category":"Team", "sportItemId":3},
      {"sportImage":"https://t3.ftcdn.net/jpg/02/78/42/76/360_F_278427683_zeS9ihPAO61QhHqdU1fOaPk2UClfgPcW.jpg","sportName":"Basketball","sport category":"Team", "sportItemId":4},
      {"sportImage":"https://t3.ftcdn.net/jpg/02/78/42/76/360_F_278427683_zeS9ihPAO61QhHqdU1fOaPk2UClfgPcW.jpg","sportName":"Archery","sport category":"Team", "sportItemId":5}
  ]''';
    List<dynamic> jsonList = jsonDecode(json);
    sportImageTextCardInfo = jsonList.map((item) => SportInfo.fromJson(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AutoSlidingBanner(),
            const Text( "Top Olympics Sports . . .",
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize:28)
            ).pOnly(left: 16, top: 48, bottom: 16),
            SizedBox(
              height: 145,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: sportImageTextCardInfo.length,
                  itemBuilder: (BuildContext buildContext, int itemIndex) {
                    return HeaderCard(sportInfo: sportImageTextCardInfo[itemIndex]).pSymmetric(h: 16, v: 0);
                  }
              ),
            ),

          ],
        ),
      ),
    );
  }
}
