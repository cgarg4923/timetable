import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

List<String> _days = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday",
];

class InfoItem {
  final String id;
  final String title;
  final String description;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  InfoItem({
    this.id,
    this.title,
    this.description,
    this.startTime,
    this.endTime,
  });
}

class Info with ChangeNotifier {
  final Map<int, List<InfoItem>> _information = {};
  final List<String> weekDays = [
    'Monday.json',
    'Tuesday.json',
    'Wednesday.json',
    'Thursday.json',
    'Friday.json',
    'Saturday.json',
    'Sunday.json',
  ];
  static const url = 'https://timetable-522dd-default-rtdb.firebaseio.com/';
  List<InfoItem> getInfo(int day) {
    return _information[day];
  }

  InfoItem getSingleInfo(int day, String id) {
    return _information[day].firstWhere(
      (element) => element.id == id,
    );
  }

  Future<void> fetchAndSetTimeTable() async {
    try {
      final response = await http.get(url + 'timetable.json');
      final result = json.decode(response.body) as Map<String, dynamic>;
      for (int i = 0; i < 7; i++) {
        _information.putIfAbsent(i + 1, () => []);
        if (result.containsKey(_days[i])) {
          result[_days[i]].forEach(
            (key1, value) {
              print(key1);
              _information[i + 1].add(
                InfoItem(
                  id: key1,
                  title: value['title'],
                  description: value['description'],
                  startTime: TimeOfDay(
                      hour: int.parse(value['startTime'].split(":")[0]),
                      minute: int.parse(value['startTime'].split(":")[1])),
                  endTime: TimeOfDay(
                      hour: int.parse(value['endTime'].split(":")[0]),
                      minute: int.parse(value['endTime'].split(":")[1])),
                ),
              );
            },
          );
          _information[i + 1].sort(
            (a, b) => a.startTime.hour.compareTo(b.startTime.hour),
          );
        }
      }

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addInfo(int day, InfoItem infoItem) {
    String uri = url + 'timetable/' + weekDays[day - 1];
    return http
        .post(
      uri,
      body: json.encode(
        {
          'title': infoItem.title,
          'description': infoItem.description,
          'startTime': infoItem.startTime.hour.toString() +
              ':' +
              infoItem.startTime.minute.toString(),
          'endTime': infoItem.endTime.hour.toString() +
              ':' +
              infoItem.endTime.minute.toString(),
        },
      ),
    )
        .then((response) {
      if (_information.containsKey(day)) {
        infoItem = InfoItem(
          id: json.decode(response.body)['name'],
          title: infoItem.title,
          description: infoItem.description,
          startTime: infoItem.startTime,
          endTime: infoItem.endTime,
        );
        _information[day].add(infoItem);
      } else {
        infoItem = InfoItem(
          id: json.decode(response.body)['name'],
          title: infoItem.title,
          description: infoItem.description,
          startTime: infoItem.startTime,
          endTime: infoItem.endTime,
        );
        _information.putIfAbsent(
          day,
          () => [infoItem],
        );
      }
      _information[day]
          .sort((a, b) => a.startTime.hour.compareTo(b.startTime.hour));
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  void edit(int day, String id, String title, String description,
      TimeOfDay startTime, TimeOfDay endTime) {
    _information[day]
            [_information[day].indexWhere((element) => element.id == id)] =
        InfoItem(
      id: id,
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
    );
    _information[day]
        .sort((a, b) => a.startTime.hour.compareTo(b.startTime.hour));
    notifyListeners();
  }

  void delete(int day, String id) {
    _information[day].removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
