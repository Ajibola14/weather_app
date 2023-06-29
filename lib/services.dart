class Services{
  String formatTime(String time) {
  List<String> timeComponents = time.split(':');
  int hour = int.parse(timeComponents[0]);
  int minute = int.parse(timeComponents[1]);
  String formattedHour = hour.toString().padLeft(2, '0');
  String formattedMinute = minute.toString().padLeft(2, '0');

  return "$formattedHour:$formattedMinute";
}
}