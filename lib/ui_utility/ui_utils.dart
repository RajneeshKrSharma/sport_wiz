import 'dart:async';

import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../models/SportImageTextCardModel.dart';

class HeaderCard extends StatefulWidget {
  final SportInfo sportInfo;

  const HeaderCard({required this.sportInfo});

  @override
  State<HeaderCard> createState() => _HeaderCardState();
}

class _HeaderCardState extends State<HeaderCard> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Card.outlined(
          elevation: 2.0,
          color: Colors.orange.withOpacity(0.2),
          child: SportsImageTextCard(sportInfo: widget.sportInfo),
        ),
        Positioned(
          bottom: -10,
          left: -20,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.7),
                  offset: const Offset(5.0, 5.0),
                  blurRadius: 10.0,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Text(
              "${widget.sportInfo.sportItemId}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 72,
                fontWeight: FontWeight.w900
              ),
            ),
          ),
        )
      ],
    ).pSymmetric(h:10, v: 0);
  }
}

class SportsImageTextCard extends StatelessWidget {
  final SportInfo sportInfo;

  SportsImageTextCard({super.key, required this.sportInfo});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    // Placeholder image shown while the network image loads
                    Center(child: Icon(Icons.download_for_offline, size: 36, color: Colors.grey.withOpacity(0.4))),
                    Image.network(
                      sportInfo.sportImage,
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
                )
              ),
            ),
            Text(
              sportInfo.sportName,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ).pSymmetric(h: 8, v: 8),
      ],
    );
  }
}


class AutoSlidingBanner extends StatefulWidget {

  const AutoSlidingBanner();

  @override
  _AutoSlidingBannerState createState() => _AutoSlidingBannerState();
}

class _AutoSlidingBannerState extends State<AutoSlidingBanner> {
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;

  final listOfBannerCards = [
    BannerCards(imagePath: "https://images.hindustantimes.com/img/2024/07/20/1600x900/Paris_Olympics_1721472243707_1721472244402.jpg"),
    BannerCards(imagePath: "https://i.ytimg.com/vi/IQBI_1pAsIw/maxresdefault.jpg"),
    BannerCards(imagePath: "https://cloudfront-us-east-2.images.arcpublishing.com/reuters/6XHUBLBAWBNYJPBQTHJPWPJ2UQ.jpg"),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);

    // Set up the auto-slide timer
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < listOfBannerCards.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PageView(
        controller: _pageController,
        children: listOfBannerCards,
      ),
    );
  }
}

class BannerCards extends StatelessWidget {
  final String imagePath;

  const BannerCards({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Card(
        elevation: 8,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            // Placeholder image shown while the network image loads
            Center(child: Icon(Icons.download_for_offline, size: 48, color: Colors.grey.withOpacity(0.4))),
            Image.network(
              imagePath,
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
        ),
      ),
    );
  }
}

class ConicalArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, size.height / 2); // Start at the middle left
    path.lineTo(size.width, 0); // Top right corner
    path.lineTo(size.width, size.height); // Bottom right corner
    path.close(); // Closes the path to form the triangle

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
