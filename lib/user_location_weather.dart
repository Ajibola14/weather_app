import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'services.dart';
import 'weather_grid_view.dart';

class UserLocationWeather extends StatelessWidget {
  const UserLocationWeather({required this.userLocationWeather, super.key});
  final dynamic userLocationWeather;
  @override
  Widget build(BuildContext context) {
    final tempIcon = userLocationWeather["current"]["condition"]["icon"];
    final tempText = userLocationWeather['current']['condition']['text'];
    final temp = userLocationWeather["current"]["temp_c"];
    final name = userLocationWeather["location"]["name"];
    final country = userLocationWeather["location"]["country"];
    String localtimeStr = userLocationWeather["location"]["localtime"];
    var localdate = localtimeStr.split(' ')[0];
    var localtime = localtimeStr.split(' ')[1];
    String formattedTime = Services().formatTime(localtime);
    String updatedLocaltimeStr = "$localdate $formattedTime";
    DateTime updatedLocaltime = DateTime.parse(updatedLocaltimeStr);
    final date = DateFormat('MMM dd').format(updatedLocaltime);
    final time = DateFormat('HH:mm').format(updatedLocaltime);

    final windSpeed = userLocationWeather['current']['wind_kph'];
    final pressure = userLocationWeather['current']['pressure_mb'];
    final uvIndex = userLocationWeather['current']['uv'];
    final humidity = userLocationWeather['current']['humidity'];
    final cloud = userLocationWeather['current']['cloud'];
    final visibility = userLocationWeather['current']['vis_km'];
    final List forecastWeather = userLocationWeather['forecast']['forecastday'];
    return SingleChildScrollView(
      padding: EdgeInsets.all(5),
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
                  scale: 0.6,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      "${temp}\u00B0C",
                      style:
                          TextStyle(fontSize: 35, fontWeight: FontWeight.w500),
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
                weather_details_container(
                    Icons.line_weight, "Pressure", pressure.toString(), "hpa"),
                weather_details_container(Icons.light_mode_rounded, "UV index",
                    uvIndex.toString(), ""),
                weather_details_container(Icons.water_drop_sharp, "Humidity",
                    humidity.toString(), "km"),
                weather_details_container(
                    CupertinoIcons.cloud_fill, "Cloud", cloud.toString(), ""),
                weather_details_container(CupertinoIcons.eye_fill, "Visibilty",
                    visibility.toString(), ""),
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
                  height: 55,
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
    );
  }
}
