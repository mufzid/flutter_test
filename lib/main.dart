import 'package:crud_api/functions/provider_api.dart';
import 'package:crud_api/screens/addfile.dart';
import 'package:crud_api/screens/employee_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EmployeeProvider(),
      child: MaterialApp(
        home: const EmployeeListScreen(),
        routes: {
          '/list': (context) => const EmployeeListScreen(),
          '/add': (context) => const AddScreen(),
        },
      ),
    );
  }
}
