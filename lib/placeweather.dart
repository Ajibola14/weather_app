import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'services.dart';
import 'weather_grid_view.dart';

String _formatHour(int hour) {
  return hour.toString().padLeft(2, '0');
}

class PlaceWeather extends StatelessWidget {
  const PlaceWeather({super.key, required this.weather});
  final dynamic weather;

  @override
  Widget build(BuildContext context) {
    final String name = weather['location']['name'];
    final String country = weather['location']['country'];
    String localtimeStr = weather["location"]["localtime"];
    var localdate = localtimeStr.split(' ')[0];
    var localtime = localtimeStr.split(' ')[1];
    String formattedTime = Services().formatTime(localtime);
    String updatedLocaltimeStr = "$localdate $formattedTime";
    DateTime updatedLocaltime = DateTime.parse(updatedLocaltimeStr);
    final date = DateFormat('MMM dd').format(updatedLocaltime);
    final time = DateFormat('HH:mm').format(updatedLocaltime);
    final String temp = weather['current']['temp_c'].toString();
    final tempIcon = weather['current']['condition']['icon'];
    final tempText = weather['current']['condition']['text'];
    final windSpeed = weather['current']['wind_kph'];
    final pressure = weather['current']['pressure_mb'];
    final uvIndex = weather['current']['uv'];
    final humidity = weather['current']['humidity'];
    final cloud = weather['current']['cloud'];
    final visibility = weather['current']['vis_km'];
    final List forecastWeather = weather['forecast']['forecastday'];
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(color: Colors.grey[300]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    "https:$tempIcon",
                    scale: 0.5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "${temp}\u00B0C",
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.w500),
                      ),
                      Spacer(),
                      Flexible(
                        child: Text(
                          tempText,
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    height: 4,
                    color: Colors.black45,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "$name, ",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text("$country", style: TextStyle(fontSize: 20))
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(date, style: TextStyle(fontSize: 23)),
                      SizedBox(
                        width: 10,
                      ),
                      Text(time,
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w700)),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              child: GridView(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 2.5,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    crossAxisCount: 2),
                children: [
                  weather_details_container(CupertinoIcons.wind, "Wind Speed",
                      windSpeed.toString(), "Km/h"),
                  weather_details_container(Icons.line_weight, "Pressure",
                      pressure.toString(), "hpa"),
                  weather_details_container(Icons.light_mode_rounded,
                      "UV index", uvIndex.toString(), ""),
                  weather_details_container(Icons.water_drop_sharp, "Humidity",
                      humidity.toString(), "km"),
                  weather_details_container(
                      CupertinoIcons.cloud_fill, "Cloud", cloud.toString(), ""),
                  weather_details_container(CupertinoIcons.eye_fill,
                      "Visibilty", visibility.toString(), ""),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Forecast",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: forecastWeather.length,
                itemBuilder: (BuildContext context, int index) {
                  final dayForeCastWeather = forecastWeather[index];
                  final dateStr = dayForeCastWeather["date"];
                  final date = DateTime.parse(dateStr);
                  final dayOfWeek = DateFormat('E').format(date);
                  final max_temp = dayForeCastWeather["day"]["maxtemp_c"];
                  final min_temp = dayForeCastWeather["day"]["mintemp_c"];
                  final icon = dayForeCastWeather["day"]["condition"]["icon"];
                  final condition =
                      dayForeCastWeather["day"]["condition"]["text"];
                  return Container(
                    height: 60,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("$min_temp - $max_temp\u00B0C"),
                        Text(condition),
                        Image.network("https:$icon"),
                        Text(dayOfWeek),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
