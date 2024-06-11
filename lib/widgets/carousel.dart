import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kiosk/data/data.dart';
import 'package:kiosk/widgets/climate_control.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CarouselState();
  }
}

class _CarouselState extends State<Carousel> {
  final CarouselController slideController = CarouselController();

  final ButtonStyle navigationStyle = OutlinedButton.styleFrom(
    padding: const EdgeInsets.all(8),
    foregroundColor: Colors.white,
    textStyle: const TextStyle(fontSize: 20),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
  );

  var _showingQR = false;

  final _qrImage = QrImageView(
    data: 'https://www.linkedin.com/in/rodmastria/',
    version: QrVersions.auto,
    size: 300.0,
    backgroundColor: Colors.white,
  );

  void _flipQRstate() {
    _showingQR = !_showingQR;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(height: 500.0),
          carouselController: slideController,
          items: sliderNotes.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            Colors.lightBlue.withOpacity(0.55),
                            Colors.lightBlue.withOpacity(0.9)
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
                            color: Colors.lightBlue.shade400,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  sliderHeaders[sliderNotes.indexOf(i)],
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontStyle: FontStyle.italic,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                  textAlign: TextAlign.center,
                                ),
                                (sliderNotes.indexOf(i) == 0)
                                    ? const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Icon(Icons.waving_hand_outlined),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                (_showingQR)
                                    ? _qrImage
                                    : Text(
                                        i,
                                        style: TextStyle(
                                            fontSize: 34,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface),
                                        textAlign: TextAlign.center,
                                      ),
                                if (!_showingQR && sliderNotes.indexOf(i) == 1)
                                  const Column(
                                    children: [
                                      SizedBox(height: 16),
                                      ClimateControl()
                                    ],
                                  )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(width: 150),
                              Text(
                                  'Slide ${sliderNotes.indexOf(i) + 1} of ${sliderNotes.length}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontStyle: FontStyle.normal,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface)),
                              const SizedBox(width: 150)
                            ],
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
            OutlinedButton.icon(
              onPressed: () =>
                  slideController.previousPage(curve: Curves.linear),
              style: navigationStyle,
              label: const Text('back'),
              icon: const Icon(Icons.arrow_circle_left_outlined),
            ),
            const SizedBox(width: 60),
            TextButton(
              onLongPress: () {
                setState(() {
                  _flipQRstate();
                });
              },
              onPressed: () {},
              child: Text('Enjoy your trip!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                      color: Theme.of(context).colorScheme.onSurface)),
            ),
            const SizedBox(width: 60),
            OutlinedButton.icon(
              onPressed: () => slideController.nextPage(curve: Curves.linear),
              style: navigationStyle,
              label: const Text('next'),
              icon: const Icon(Icons.arrow_circle_right_outlined),
            ),
          ],
        ),
      ],
    );
  }
}
