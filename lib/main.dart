import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/employees.dart';
import './screens/employe_detail_screen.dart';
import './screens/new_employee_screen.dart';

import './screens/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ((context) => Employees()),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: WelcomeScreen(),
          routes: {
            EmployeeScreen.route: (context) => EmployeeScreen(),
            NewEmployeeScreen.route: (context) => NewEmployeeScreen(),
          }),
    );
  }
}
