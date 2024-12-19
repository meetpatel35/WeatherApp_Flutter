

import 'package:flutter/material.dart';
class HourlyForecast extends StatelessWidget {
  const HourlyForecast({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 107,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(8.0),
        child:const Column(
          children: [
            Text(
              "9:27",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 6,
            ),
            Icon(
              Icons.cloud,
              size: 30,
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              "301.6",
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
