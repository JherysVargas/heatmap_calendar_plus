import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:heatmap_calendar_plus/heatmap_calendar_plus.dart';

class HeatMapCalendarExample extends StatefulWidget {
  const HeatMapCalendarExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HeatMapCalendarExample();
}

class _HeatMapCalendarExample extends State<HeatMapCalendarExample> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController heatLevelController = TextEditingController();

  final HeatMapCalendarController calendarController =
      HeatMapCalendarController();

  bool isOpacityMode = true;

  Map<DateTime, int> heatMapDatasets = {};

  @override
  void dispose() {
    super.dispose();
    dateController.dispose();
    heatLevelController.dispose();
  }

  Widget _textField(final String hint, final TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 20, top: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffe7e7e7), width: 1.0)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF20bca4), width: 1.0)),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          isDense: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heatmap Calendar'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(20),
              elevation: 20,
              child: Padding(
                padding: const EdgeInsets.all(20),

                // HeatMapCalendar
                child: HeatMapCalendar(
                  flexible: true,
                  initDate: DateTime(2020, 6, 1),
                  controller: calendarController,
                  datasets: heatMapDatasets,
                  colorMode:
                      isOpacityMode ? ColorMode.opacity : ColorMode.color,
                  monthTextStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  datePattern: 'yyyy-MM-dd',
                  blockSpacing: 6,
                  // weekStartsWith: 1,
                  marginHeader: const EdgeInsets.only(bottom: 10),
                  colorsets: const {
                    1: Colors.red,
                    3: Colors.orange,
                    5: Colors.yellow,
                    7: Colors.green,
                    9: Colors.blue,
                    11: Colors.indigo,
                    13: Colors.purple,
                  },
                  headerBuilder: (context, currentDate) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          color: Colors.black54,
                          onPressed: () {
                            calendarController.previousMonth();
                          },
                        ),
                        GestureDetector(
                          child: Text(
                            '${currentDate?.year} - ${currentDate?.month} - ${currentDate?.day}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                          onTap: () {
                            final randomMonth = Random().nextInt(12) + 1;
                            final randomYear = Random().nextInt(5) + 2020;

                            calendarController.gotToDate(
                              DateTime(
                                randomYear,
                                randomMonth,
                                1,
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          color: Colors.black54,
                          onPressed: () {
                            calendarController.nextMonth();
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            _textField('YYYYMMDD', dateController),
            _textField('Heat Level', heatLevelController),
            ElevatedButton(
              child: const Text('COMMIT'),
              onPressed: () {
                setState(() {
                  heatMapDatasets[DateTime.parse(dateController.text)] =
                      int.parse(heatLevelController.text);
                });
              },
            ),

            // ColorMode/OpacityMode Switch.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Color Mode'),
                CupertinoSwitch(
                  value: isOpacityMode,
                  onChanged: (value) {
                    setState(() {
                      isOpacityMode = value;
                    });
                  },
                ),
                const Text('Opacity Mode'),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
