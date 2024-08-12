import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kiosk/data/data.dart';
import 'package:kiosk/widgets/climate_control.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CarouselState();
  }
}

class _CarouselState extends State<Carousel> {
  final CarouselController slideController = CarouselController();

  final ButtonStyle navigationStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.fromLTRB(8, 24, 8, 24),
    foregroundColor: Colors.black,
    backgroundColor: Colors.blue.shade100,
    textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  );

  final ButtonStyle hyperlinkStyles = ElevatedButton.styleFrom(
    padding: const EdgeInsets.all(24),
    foregroundColor: Colors.black,
    backgroundColor: Colors.white,
    textStyle: const TextStyle(fontSize: 36),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  );

  final ButtonStyle qrStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
    foregroundColor: Colors.black,
    backgroundColor: Colors.white,
    textStyle: const TextStyle(fontSize: 24),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
    ),
  );

  final _qrImage = QrImageView(
    data: 'https://linktr.ee/rodmastria',
    version: QrVersions.auto,
    size: 150.0,
    backgroundColor: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 625.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 10),
            autoPlayAnimationDuration: const Duration(milliseconds: 500),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            scrollDirection: Axis.horizontal,
          ),
          carouselController: slideController,
          items: sliderNotes.map((slideActive) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            sliderGradientStart[0],
                            sliderGradientEnd[0],
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(height: 50),
                          Container(
                            color: Colors.lightGreen.shade400,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  sliderHeaders[
                                      sliderNotes.indexOf(slideActive)],
                                  style: TextStyle(
                                      fontSize: 60,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey.shade800),
                                  textAlign: TextAlign.center,
                                ),
                                (sliderNotes.indexOf(slideActive) == 0)
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Icon(
                                          size: 50.0,
                                          Icons.waving_hand_outlined,
                                          color: Colors.grey.shade800,
                                        ),
                                      )
                                    : const SizedBox(),
                                (sliderNotes.indexOf(slideActive) == 1)
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Icon(
                                          size: 50.0,
                                          Icons.music_note,
                                          color: Colors.grey.shade800,
                                        ),
                                      )
                                    : const SizedBox(),
                                (sliderNotes.indexOf(slideActive) == 2)
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Icon(
                                          size: 50.0,
                                          Icons.wind_power,
                                          color: Colors.grey.shade800,
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  slideActive,
                                  style: TextStyle(
                                      fontSize: 48,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                  textAlign: TextAlign.center,
                                ),
                                if (sliderNotes.indexOf(slideActive) == 2)
                                  const Column(
                                    children: [
                                      SizedBox(height: 16),
                                      ClimateControl()
                                    ],
                                  ),
                                if (sliderNotes.indexOf(slideActive) == 3)
                                  Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          style: hyperlinkStyles,
                                          child: const Text('YouTube'),
                                          onPressed: () => launchUrlString(
                                              'https://www.youtube.com/'),
                                        ),
                                        const SizedBox(width: 24),
                                        ElevatedButton(
                                          style: hyperlinkStyles,
                                          child: const Text('News'),
                                          onPressed: () => launchUrlString(
                                              'https://www.apnews.com/'),
                                        ),
                                        const SizedBox(width: 24),
                                        ElevatedButton(
                                          style: hyperlinkStyles,
                                          child: const Text('Netflix'),
                                          onPressed: () => launchUrlString(
                                              'https://www.netflix.com/'),
                                        )
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ));
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200.0,
              child: ElevatedButton.icon(
                onPressed: () => slideController.animateToPage(0),
                style: navigationStyle,
                label: Text(sliderHeaders[0]),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 200.0,
              child: ElevatedButton.icon(
                onPressed: () => slideController.animateToPage(1),
                style: navigationStyle,
                label: Text(sliderHeaders[1]),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 200.0,
              child: ElevatedButton.icon(
                onPressed: () => slideController.animateToPage(2),
                style: navigationStyle,
                label: Text(sliderHeaders[2]),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 200.0,
              child: ElevatedButton.icon(
                onPressed: () => slideController.animateToPage(3),
                style: navigationStyle,
                label: Text(sliderHeaders[3]),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 200.0,
              child: ElevatedButton.icon(
                onPressed: () => slideController.animateToPage(4),
                style: navigationStyle,
                label: Text(sliderHeaders[4]),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
