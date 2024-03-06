import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kiosk/data/data.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CarouselState();
  }
}

class _CarouselState extends State<Carousel> {
  final CarouselController buttonController = CarouselController();

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
    data: 'https://linktr.ee/rodmastria',
    version: QrVersions.auto,
    size: 300.0,
    backgroundColor: Colors.white,
  );

  void _flipQRstate() {
    _showingQR = !_showingQR;
  }

  Future<void> _openTV(String channel) async {
    final Uri launchUri = Uri(
      scheme: 'app',
      path: 'com.google.android.youtube',
    );
    await launchUrl(launchUri);
  }

  bool _hasTVsupport = false;
  @override
  void initState() {
    super.initState();
    canLaunchUrl(Uri(scheme: 'app', path: 'com.google.android.youtube'))
        .then((result) => setState(() {
              _hasTVsupport = result;
            }));
  }

  @override
  Widget build(BuildContext context) {
    final lastPage = sliderNotes.length - 1;
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(height: 500.0),
          carouselController: buttonController,
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
                                          .onBackground),
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
                                (_showingQR &&
                                        sliderNotes.indexOf(i) == lastPage)
                                    ? _qrImage
                                    : Text(
                                        i,
                                        style: TextStyle(
                                            fontSize: 34,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground),
                                        textAlign: TextAlign.center,
                                      ),
                              ],
                            ),
                          ),

                          // (sliderNotes.indexOf(i) == 1)
                          //     ? Padding(
                          //         padding: const EdgeInsets.all(8.0),
                          //         child: OutlinedButton.icon(
                          //           onPressed: () {
                          //             _hasTVsupport
                          //                 ? setState(() {
                          //                     _openTV('chillvibes');
                          //                   })
                          //                 : null;
                          //           },
                          //           style: navigationStyle,
                          //           label: _hasTVsupport
                          //               ? const Text('Open YouTube TV')
                          //               : const Text('No TV'),
                          //           icon: const Icon(
                          //               Icons.live_tv_outlined),
                          //         ),
                          //       )
                          //     : const SizedBox(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(width: 150),
                              Text(
                                  'Slide ${sliderNotes.indexOf(i) + 1} of ${sliderNotes.length}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontStyle: FontStyle.normal,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground)),
                              // (_showingQR &&
                              //         sliderNotes.indexOf(i) == lastPage)
                              //     ? _qrImageTiny
                              //     : const SizedBox(width: 150)
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
                  buttonController.previousPage(curve: Curves.linear),
              style: navigationStyle,
              label: const Text('back'),
              icon: const Icon(Icons.arrow_circle_left_outlined),
            ),
            const SizedBox(width: 60),
            TextButton(
              onPressed: () {
                buttonController.animateToPage(lastPage);
                setState(() {
                  _flipQRstate();
                });
              },
              child: Text('Enjoy your trip!\n-Rod',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.onBackground)),
            ),
            const SizedBox(width: 60),
            OutlinedButton.icon(
              onPressed: () => buttonController.nextPage(curve: Curves.linear),
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
