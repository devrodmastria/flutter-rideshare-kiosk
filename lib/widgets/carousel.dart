import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kiosk/data/data.dart';
import 'package:kiosk/widgets/climate_control.dart';
import 'package:kiosk/widgets/entertainment.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kiosk/widgets/firestore_message.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CarouselState();
  }
}

class _CarouselState extends State<Carousel> {
  final CarouselSliderController slideController = CarouselSliderController();
  final _battery = Battery();

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

  void _updateBattLevel(int batt) async {
    FirebaseFirestore.instance.collection('ride').doc('climate_status').update({
      'battery': batt,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 625.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 15),
            autoPlayAnimationDuration: const Duration(milliseconds: 500),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeFactor: 0.3,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              (index == 3 && reason == CarouselPageChangedReason.timed)
                  ? _battery.batteryLevel.then((batt) => _updateBattLevel(batt))
                  : null;
            },
          ),
          carouselController: slideController,
          items: sliderNotes.map((currentSliderNote) {
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
                                      sliderNotes.indexOf(currentSliderNote)],
                                  style: TextStyle(
                                      fontSize: 60,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey.shade800),
                                  textAlign: TextAlign.center,
                                ),

                                // slider header icons
                                (sliderNotes.indexOf(currentSliderNote) == 0)
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
                                (sliderNotes.indexOf(currentSliderNote) == 1)
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16.0, 8.0, 0.0, 0.0),
                                        child: Icon(
                                          size: 50.0,
                                          Icons.music_note_outlined,
                                          color: Colors.grey.shade800,
                                        ),
                                      )
                                    : const SizedBox(),
                                (sliderNotes.indexOf(currentSliderNote) == 2)
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16.0, 8.0, 0.0, 0.0),
                                        child: Icon(
                                          size: 50.0,
                                          Icons.theater_comedy_outlined,
                                          color: Colors.grey.shade800,
                                        ),
                                      )
                                    : const SizedBox(),
                                (sliderNotes.indexOf(currentSliderNote) == 3)
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

                                (sliderNotes.indexOf(currentSliderNote) == 4)
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            16.0, 8.0, 0.0, 0.0),
                                        child: Icon(
                                          size: 50.0,
                                          Icons.water_drop_outlined,
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
                                // slider sub headers
                                Text(
                                  currentSliderNote,
                                  style: TextStyle(
                                      fontSize: 48,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                  textAlign: TextAlign.center,
                                ),

                                if (sliderNotes.indexOf(currentSliderNote) == 1)
                                  const FirestoreMsg(),
                                if (sliderNotes.indexOf(currentSliderNote) == 2)
                                  const Entertainment(),
                                if (sliderNotes.indexOf(currentSliderNote) == 3)
                                  const ClimateControl(),
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
