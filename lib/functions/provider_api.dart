import 'package:crud_api/functions/services.dart';

import 'package:flutter/material.dart';

class EmployeeProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _employeeData = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get employeeData => _employeeData;
  bool get isLoading => _isLoading;

  Future<void> fetchEmployeeData() async {
    final response = await ApiServices.fetchApi();

    if (response != null) {
      _employeeData = List.from(response);
    } else {}

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteEmployeeById(String id) async {
    final isSuccess = await ApiServices.deleteById(id);

    if (isSuccess) {
      _employeeData.removeWhere((employee) => employee['_id'] == id);
      notifyListeners();
    } else {
      //  showErrorMessage(context, message: 'something went wrong');
    }
  }

  Future<void> updateEmployee(String id, Map<String, dynamic> body) async {
    try {
      final isSuccess = await ApiServices.updateApi(id, body);

      if (isSuccess) {
        final index =
            _employeeData.indexWhere((employee) => employee['_id'] == id);
        if (index != -1) {
          _employeeData[index] = body;
          notifyListeners();
        }
      } else {
        //  showErrorMessage(context, message: 'something went wrong');
      }
    } catch (e) {
      print('Error updating employee: $e');
    }
  }

  Future<void> addEmployee(Map<String, dynamic> body) async {
    final isSuccess = await ApiServices.addApi(body);

    if (isSuccess) {
      _employeeData.add(body);
      notifyListeners();
    } else {
      //  showErrorMessage(context, message: 'something went wrong');
    }
  }
}
