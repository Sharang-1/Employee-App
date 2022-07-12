import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';
import '../models/employees.dart';

class NewEmployeeScreen extends StatefulWidget {
  static const route = '/new-employ';

  @override
  State<NewEmployeeScreen> createState() => _NewEmployeeScreenState();
}

class _NewEmployeeScreenState extends State<NewEmployeeScreen> {
  DateTime selectedDate = DateTime.now();
  final _form = GlobalKey<FormState>();
  var _isLoading = false;
  bool datetimeSelected = false;
  var _newEmployee = Employee(
      id: DateTime.now().toString(),
      name: '',
      description: '',
      dateOfJoining: DateTime.now(),
      post: '');

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        datetimeSelected = true;
        selectedDate = value;
        _newEmployee = Employee(
            id: _newEmployee.id,
            name: _newEmployee.name,
            description: _newEmployee.description,
            dateOfJoining: value,
            post: _newEmployee.post);
      });
    });
  }

  void _saveForm() {
    final _isValid = _form.currentState!.validate();
    if (!_isValid) {
      return;
    }
    _form.currentState?.save();
    setState(() {
      _isLoading = true;
    });
    try {
      Provider.of<Employees>(context, listen: false).addEmployee(_newEmployee);
    } catch (error) {
      showDialog<Null>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('An error occour'),
          content: Text('Something went wrong'),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Okay'),
            )
          ],
        ),
      );
    }
    Navigator.of(context).pop();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Employee'),
        actions: <Widget>[
          IconButton(onPressed: _saveForm, icon: Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter the name !';
                  }
                  return null;
                },
                onSaved: (value) {
                  _newEmployee = Employee(
                      id: _newEmployee.id,
                      name: value as String,
                      description: _newEmployee.description,
                      dateOfJoining: _newEmployee.dateOfJoining,
                      post: _newEmployee.post);
                },
              ),
              TextFormField(
                decoration: InputDecoration(label: Text('Post')),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter the post !';
                  }
                  return null;
                },
                onSaved: (value) {
                  _newEmployee = Employee(
                      id: _newEmployee.id,
                      post: value as String,
                      description: _newEmployee.description,
                      dateOfJoining: _newEmployee.dateOfJoining,
                      name: _newEmployee.name);
                },
              ),
              TextFormField(
                decoration: InputDecoration(label: Text('Description')),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter the Description !';
                  }
                  return null;
                },
                onSaved: (value) {
                  _newEmployee = Employee(
                      id: _newEmployee.id,
                      description: value as String,
                      name: _newEmployee.name,
                      dateOfJoining: _newEmployee.dateOfJoining,
                      post: _newEmployee.post);
                },
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: 60,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(!datetimeSelected
                          ? 'No date chosen'
                          : 'picked Date : ${DateFormat.yMMMd().format(selectedDate)}'),
                    ),
                    FlatButton(
                        onPressed: _presentDatePicker,
                        child: Text(
                          'Choose DOJ',
                          style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
