import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info.dart';
import 'package:weather_app/hourly_forecast.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  final String cityName = 'Mumbai';

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  IconData getWeatherIcon(String currentSky) {
    Map<String, IconData> weatherIcons = {
      'Thunderstorm': Icons.flash_on,
      'Drizzle': Icons.grain,
      'Rain': Icons.umbrella,
      'Snow': Icons.ac_unit,
      'Clouds': Icons.cloud,
      'Clear': Icons.wb_sunny,
      'Mist': Icons.blur_on, // Add other weather conditions as needed
    };

    return weatherIcons[currentSky] ??
        Icons.help_outline; // Default icon if not matched
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$apikey'));
      final data = jsonDecode(response.body);

      if (data['cod'] != "200") {
        throw 'An unexpected err ocusred';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(76),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: AppBar(
            centerTitle: true,
            title: const Text("Weather App"),
            actions: [
              IconButton(
                onPressed: (){
                  setState(() {});
                },
                icon: const Icon(CupertinoIcons.arrow_2_circlepath),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator.adaptive(backgroundColor: Colors.white,));
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          final data = snapshot.data!;
          final currentTemp = data['list'][0]['main']['temp'];
          final currentSky = data['list'][0]['weather'][0]['main'];
          final currentPressure = data['list'][0]['main']['pressure'];
          final currentWindSpeed = data['list'][0]['wind']['speed'];
          final currentHumidity = data['list'][0]['main']['humidity'];

          return Padding(
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
                                "$currentTemp °K",
                                style: TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Icon(
                                getWeatherIcon(currentSky), // Default icon
                                size: 64,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                currentSky,
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
                  "Hourly Forecast",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 15,
                ),

                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Row(
                //       children: [
                //         for (int i = 0; i < 5; i++)
                //           HourlyForecast(
                //             time: data['list'][i + 1]["dt_txt"].toString(),
                //             icon: getWeatherIcon(data['list'][i+1]['weather'][0]['main'].toString()),
                //             temp:
                //                 data['list'][i + 1]['main']['temp'].toString(),
                //           ),
                //       ],
                //     ),
                //   ),
                // ),

                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 15,
                    itemBuilder: (context, index) {
                      final hourlyForecastData = data['list'][index+1];
                      final hourlySky = hourlyForecastData['weather'][0]['main'].toString();
                      final hourlyIcon = getWeatherIcon(hourlySky);                      
                      final hourlyTemp = hourlyForecastData['main']['temp'].toString();
                      final hourlyTime = DateFormat.j().format(DateTime.parse(hourlyForecastData['dt_txt']));
                      return HourlyForecast(time: hourlyTime, temp: hourlyTemp, icon: hourlyIcon);

                    },
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfo(
                      icon: Icons.water_drop,
                      label: "Humidity",
                      value: currentHumidity.toString(),
                    ),
                    AdditionalInfo(
                      icon: Icons.air_outlined,
                      label: "Wind Speed",
                      value: currentWindSpeed.toString(),
                    ),
                    AdditionalInfo(
                      icon: Icons.beach_access,
                      label: "Pressure",
                      value: currentPressure.toString(),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
