import 'package:flutter/material.dart';
import 'package:pagination_example/main.dart';
import 'package:pagination_example/view/pagination_example.dart';
import 'package:pagination_example/view_nodel/employee_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final empProvider = context.watch<EmployeeProvider>();


print('hello emp list: ${empProvider.listOfEmployee.length}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PaginationExample(),),);
                },
                child: const Text('Go to employee list page')),
          ),
        ],
      ),
    );
  }
}
