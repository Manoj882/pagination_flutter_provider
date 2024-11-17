import 'package:flutter/material.dart';
import 'package:pagination_example/view/home_page.dart';
import 'package:pagination_example/view/pagination_example.dart';
import 'package:pagination_example/view_nodel/employee_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => EmployeeProvider(),),
    ],
    child: const MyApp(),
    ),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: PaginationExample(),
      home: const HomePage(),
    );
  }
}
