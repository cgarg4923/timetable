import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/home_screen.dart';
import './providers/info.dart';
import 'screens/add_new_item_screen.dart';
import './providers/change_day.dart';
import './screens/edit_item.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Info(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChangeDay(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'RobotoMono',
        ),
        home: HomeScreen(),
        routes: {
          AddNewItem.routeName: (_) => AddNewItem(),
          EditItem.routeName: (_) => EditItem(),
        },
      ),
    );
  }
}
