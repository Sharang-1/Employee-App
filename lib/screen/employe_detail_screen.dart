import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/models/employees.dart';

import '../screens/new_employee_screen.dart';

class EmployeeScreen extends StatefulWidget {
  static const route = '/employ';
  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Employees>(context).fetchAndSetEmployees().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final employeeData = Provider.of<Employees>(context).employee;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employes'),
        actions: <Widget>[
          IconButton(
              onPressed: (() {
                Navigator.of(context).pushNamed(NewEmployeeScreen.route);
              }),
              icon: const Icon(Icons.add)),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : employeeData.isEmpty
              ? const Center(
                  child: Text('NO employee'),
                )
              : ListView(
                  children: employeeData.map(
                  (em) {
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.all(5),
                      child: ListTile(
                        leading:
                            CircleAvatar(child: Icon(Icons.person), radius: 25),
                        title: Text(em.name),
                        subtitle: Text(em.post),
                        trailing: Provider.of<Employees>(context, listen: false)
                                .activeEmployee(em.dateOfJoining)
                            ? const Icon(
                                Icons.flag,
                                color: Colors.green,
                              )
                            : const Icon(Icons.outlined_flag),
                      ),
                    );
                  },
                ).toList()),
    );
  }
}
