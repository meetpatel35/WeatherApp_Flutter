import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_app/additional_info.dart';
import 'package:weather_app/hourly_forecast.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(76), // Default height of AppBar
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 8.0, vertical: 8.0), // Customize as needed
          child: AppBar(
            centerTitle: true,
            title: const Text("Weather App"),
            actions: [
              IconButton(
                onPressed: () => {},
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "300 °F",
                            style: TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Icon(Icons.cloud, size: 64),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Rain",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Weather Forecast",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    HourlyForecast(),
                    HourlyForecast(),
                    HourlyForecast(),
                    HourlyForecast(),
                    HourlyForecast(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Additional Information",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                
                AdditionalInfo(icon: Icons.water_drop,label: "Humidity",value: "94",),
                AdditionalInfo(icon: Icons.air_outlined,label: "Wind Speed",value: "16",),
                AdditionalInfo(icon: Icons.beach_access,label: "Pressure",value: "1000",),
              ],
            )
          ],
        ),
      ),
    );
  }
}
