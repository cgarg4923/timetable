import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/change_day.dart';

class AppDrawer extends StatelessWidget {
  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  @override
  Widget build(BuildContext context) {
    final _changeDay = Provider.of<ChangeDay>(context, listen: false);
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'TimeTable',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: days
                .map(
                  (day) => ListTile(
                    title: Text(
                      day,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    selectedTileColor: Colors.black12,
                    leading: CircleAvatar(
                      child: Text(
                        day[0],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.deepPurpleAccent,
                    ),
                    onTap: () {
                      _changeDay.changeDay(
                        days.indexOf(day) + 1,
                      );
                      Navigator.of(context).pop();
                    },
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
