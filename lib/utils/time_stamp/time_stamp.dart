import 'package:date_format/date_format.dart';

class VRTimeStamp {
  String getNowAppointmentTime(){
    DateTime _nowDate = DateTime.now();
    String appointmentTime = formatDate(_nowDate, [HH,':',nn]);
    return appointmentTime;
  }

  String getNowAppointmentDate(){
    DateTime _nowDate = DateTime.now();
    String appointmentDate = formatDate(_nowDate, [yyyy,'年',mm,'月',dd,'日']);
    return appointmentDate;
  }

  String dateToString(String timeDate){
    int time = int.parse(timeDate) * 1000;
    DateTime _nowDate = DateTime.fromMillisecondsSinceEpoch(time);

    String appointmentDate = formatDate(_nowDate, [yyyy,'年',mm,'月',dd,'日',HH,':',nn]);

    return appointmentDate;
  }
}