import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pagination_example/main.dart';
import 'package:pagination_example/model/employee_response.dart';
import 'package:pagination_example/view_nodel/employee_provider.dart';
import 'package:provider/provider.dart';

class PaginationExample extends StatefulWidget {
  const PaginationExample({super.key});

  @override
  State<PaginationExample> createState() => _PaginationExampleState();
}

class _PaginationExampleState extends State<PaginationExample> {
  // final _scrollController = ScrollController();

  // Timer? _debounce;

  Timer? _shrinkTimer;

  final ValueNotifier<bool> _showNoMoreData = ValueNotifier(false);

  late EmployeeProvider _employeeProvider;

  @override
  void initState() {
    super.initState();
    _employeeProvider = context.read<EmployeeProvider>();
    _fetchEmployee();
  }

  void _fetchEmployee() {
    // final employeeProvider = context.read<EmployeeProvider>();
    _employeeProvider.fetchAllEmployee().then((_) {
      if (!_employeeProvider.hasMoreData) {
        _showNoMoreDataTemporarily();
      }
    });
  }

  void _showNoMoreDataTemporarily() { 
    _showNoMoreData.value = true;

    Future.delayed(const Duration(seconds: 1), () {
      _showNoMoreData.value = false;
    });
  }

  @override
  void dispose() {
    _shrinkTimer?.cancel();
    _showNoMoreData.dispose();
   // _employeeProvider.onDisposed();

   _resetData();

    super.dispose();
  }

  _resetData() {
    Future(()async{
      await _employeeProvider.onDisposed();
    });
  
  }

  @override
  Widget build(BuildContext context) {
    final employeeProvider = context.watch<EmployeeProvider>();
    final listOfEmployee = employeeProvider.listOfEmployee;
    final isLoading = employeeProvider.isLoading;

    print('hello is loading: $isLoading');
    print('hello page count: ${employeeProvider.pageCount}');
    print('hello has more data: ${employeeProvider.hasMoreData}');

    print('list of length: ${employeeProvider.listOfEmployee.length}');

    print('*************************************************');
    print('');
    print('');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagination Example'),
      ),
      body: (employeeProvider.initialLoading)
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            )
          : Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 60,
                  child: SingleChildScrollView(
                    child: TextFormField(),
                  ),
                ),
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (employeeProvider.isLoading) {
                        return false;
                      }

                      if (!employeeProvider.isLoading &&
                         // employeeProvider.hasMoreData &&
                          scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                        _fetchEmployee();

                        // if(_debounce?.isActive ?? false) _debounce?.cancel();

                        // _debounce = Timer(const Duration(milliseconds: 50), (){
                        //   _fetchEmployee();
                        // });
                      }

                      return true;
                    },
                    child: RefreshIndicator(
                      onRefresh: () async {
                        //employeeProvider.onRefreshed();
                        employeeProvider.onRefreshed();
                        _fetchEmployee();
                      },
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: listOfEmployee.length,
                          itemBuilder: (context, index) {
                            final employee = listOfEmployee[index];
                            return Container(
                              height: 300,
                              width: double.infinity,
                              margin: const EdgeInsets.only(
                                  right: 20, left: 20, top: 10),
                              decoration:
                                  const BoxDecoration(color: Colors.amber),
                              child: ListTile(
                                title: Text(employee.name ?? ''),
                                subtitle: Text(employee.email ?? ''),
                              ),
                            );
                          }),
                    ),
                  ),
                ),
                if (isLoading &&
                    employeeProvider.hasMoreData &&
                    employeeProvider.pageCount != 0)
                  const SizedBox(
                    height: 5,
                  ),
                if (isLoading &&
                    employeeProvider.hasMoreData &&
                    employeeProvider.pageCount != 0)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                const SizedBox(
                  height: 5,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _showNoMoreData,
                  builder: (context, value, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: value ? 30 : 0,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24),),
                      ),
                      curve: Curves.easeInOut,
                      child: value
                          ? const Center(
                              child: Text(
                                'No more data',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            )
                          : null,
                    );
                  },
                ),
              ],
            ),
    );
  }
}
