import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './employee.dart';

class Employees with ChangeNotifier {
  Future<void> addEmployee(Employee employee) async {
    final url =
        Uri.https('test-1a01a-default-rtdb.firebaseio.com', '/employee.json');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': employee.name,
            'post': employee.post,
            'description': employee.description,
            'doj': employee.dateOfJoining.toIso8601String(),
          }));
      final newEmployee = Employee(
          id: json.decode(response.body)['name'],
          name: employee.name,
          post: employee.post,
          dateOfJoining: employee.dateOfJoining,
          description: employee.description);
      _employee.add(newEmployee);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<Employee> _employee = [];

  List<Employee> get employee {
    return [..._employee];
  }

  bool activeEmployee(DateTime doj) {
    Duration dur = DateTime.now().difference(doj);
    var differenceInYears = (dur.inDays / 365).floor();
    if (differenceInYears >= 5) {
      return true;
    }
    return false;
  }

  Future<void> fetchAndSetEmployees() async {
    final url =
        Uri.https('test-1a01a-default-rtdb.firebaseio.com', '/employee.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      final List<Employee> loadedEmployees = [];
      extractedData.forEach((employId, employData) {
        loadedEmployees.add(Employee(
          id: employId,
          name: employData['title'],
          description: employData['description'],
          post: employData['post'],
          dateOfJoining: DateTime.parse(employData['doj']),
        ));
      });
      _employee = loadedEmployees;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
