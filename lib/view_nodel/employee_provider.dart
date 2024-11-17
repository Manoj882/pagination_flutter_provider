import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:pagination_example/model/employee.dart';
import 'package:pagination_example/model/employee_response.dart';

class EmployeeProvider extends ChangeNotifier {
  EmployeeResponse? _employeeResponse;

  List<Employee> _listOfEmployee = [];

  int _pageCount = 0;

  bool _isLoading = false;
  bool _hasMoreData = false;

  bool _initialLoading = true;

  bool get initialLoading => _initialLoading;

  bool get isLoading => _isLoading;

  bool get hasMoreData => _hasMoreData;

  int get pageCount => _pageCount;

  EmployeeResponse? get employeeResponse => _employeeResponse;

  List<Employee> get listOfEmployee => _listOfEmployee;

  void setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void onRefreshed(){
    _pageCount = 0 ;
    _listOfEmployee = [];
    notifyListeners();
    //fetchAllEmployee();

  }

   onDisposed(){
    _pageCount = 0;
    _listOfEmployee.clear();
    _isLoading = false;
    _initialLoading = true;
    notifyListeners();

  }

  Future<void> fetchAllEmployee() async {
    final url = Uri.parse(
        'http://192.168.1.79:8080/employees?pageNo=$_pageCount&pageSize=5');

    Map<String, String>? headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    try {
      if (_initialLoading) {
        _isLoading = true;
    
      } else {
        setLoading(true);
      }

      print('hello url: $url');

      final response = await http.get(url, headers: headers);

      await Future.delayed(const Duration(milliseconds: 300));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        final employeeResponse = EmployeeResponse.fromJson(jsonResponse);

        if (employeeResponse.data != null &&
            employeeResponse.data!.isNotEmpty) {
  
              final newEmployees = employeeResponse.data!
                  .where((newEmployee) => !_listOfEmployee.any(
                      (existingEmployee) =>
                          existingEmployee.id == newEmployee.id))
                  .toList();

              _listOfEmployee.addAll(newEmployees);

              if (newEmployees.isNotEmpty) {
                _pageCount++;
                _hasMoreData = true;
              } else {
                _hasMoreData = false;
              }
            } else {
              _hasMoreData = false;
            }
      }
    } catch (e) {
      print("Error::: ${e.toString()}");
    } finally {
      _initialLoading = false;
      _isLoading = false;
      notifyListeners();
    }
  }
}
