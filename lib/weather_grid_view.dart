import 'package:flutter/material.dart';

class weather_details_container extends StatelessWidget {
  const weather_details_container(
    this.icon,
    this.statusText,
    this.status,
    this.unit, {
    super.key,
  });
  final String status;
  final String statusText;
  final IconData icon;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey[200]),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                statusText,
                style: TextStyle(color: Colors.black54),
              ),
              Text(
                "$status $unit",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              )
            ],
          )
        ],
      ),
    );
  }
}
