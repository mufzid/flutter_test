import 'package:crud_api/functions/provider_api.dart';
import 'package:crud_api/screens/addfile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<EmployeeProvider>(context, listen: false).fetchEmployeeData();
  }

  @override
  Widget build(BuildContext context) {
    final employeeListProvider = Provider.of<EmployeeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Employee List',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        backgroundColor: const Color.fromARGB(255, 40, 40, 40),
        child: const Icon(Icons.add, color: Colors.white, size: 35),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        color: const Color.fromARGB(255, 220, 219, 219),
        child: RefreshIndicator(
          onRefresh: () async {
            await employeeListProvider.fetchEmployeeData();
          },
          child: Visibility(
            visible: employeeListProvider.employeeData.isNotEmpty,
            replacement: const Center(
              child: Center(
                child: Text(
                  'No item in the list',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            child: ListView.builder(
              itemCount: employeeListProvider.employeeData.length,
              itemBuilder: (context, index) {
                final employee = employeeListProvider.employeeData[index];
                final id = employee['_id'] as String;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(255, 221, 220, 220),
                              blurRadius: 10,
                              spreadRadius: 10,
                            )
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Stack(children: [
                                  const CircleAvatar(
                                    backgroundColor:
                                        Color.fromARGB(255, 170, 170, 170),
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        'https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg'),
                                  ),
                                  Positioned(
                                    bottom: -18,
                                    left: 20,
                                    child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.add_a_photo,
                                        size: 15,
                                      ),
                                    ),
                                  )
                                ]),
                              ),
                              SizedBox(
                                width: 190,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text('id'),
                                    Text(
                                      employee['name'],
                                      style: const TextStyle(
                                          color: Color.fromARGB(255, 189, 0, 0),
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    ),

                                    Text(
                                      employee['job'],
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),

                                    Text(
                                      employee['email'],
                                      style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    navigatorToEditPage(employee);
                                  },
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        surfaceTintColor: Colors.black,
                                        backgroundColor: Colors.white,
                                        title: const Text('Are you sure?'),
                                        content: const Text(
                                            'This action will permanently delete this data'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0)),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context, true);
                                              employeeListProvider
                                                  .deleteEmployeeById(id);
                                            },
                                            child: const Text(
                                              'Delete',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void navigatorToEditPage(Map employee) {
    final route = MaterialPageRoute(
      builder: (context) => AddScreen(todo: employee),
    );
    Navigator.push(context, route);
  }
}
