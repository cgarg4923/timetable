import 'package:flutter/widgets.dart';

class ChangeDay with ChangeNotifier {
  int _selectedDay;
  ChangeDay() {
    _selectedDay = DateTime.now().weekday;
  }
  int get day {
    return _selectedDay;
  }

  void changeDay(int day) {
    _selectedDay = day;
    notifyListeners();
  }
}
