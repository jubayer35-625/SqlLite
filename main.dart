import 'package:flutter/material.dart';
import 'package:sqltite_demo/dbhealper.dart';

import 'e.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DBHelper dbHelper = new DBHelper();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

   late Employee employee;

   late List<Employee> empList;
   late int updateIndex;

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  refreshList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Records'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                openDialogueBox(context);
              },
              child: const Icon(
                Icons.add,
                size: 27.0,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: dbHelper.getEmployeeList(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            empList = snapshot.data;
            return ListView.builder(
                shrinkWrap: true,
                itemCount: empList == null ? 0 : empList.length,
                itemBuilder: (BuildContext context, int index) {
                  Employee emp = empList[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 400,
                            height: 400,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Name : ${emp.name}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                                Text(
                                  'Location : ${emp.location}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              openDialogueBox(context);
                              employee = emp;
                              updateIndex = index;
                            },
                            icon: const Icon(Icons.edit, color: Colors.blueAccent),
                          ),
                          IconButton(
                            onPressed: () {
                              dbHelper.deleteEmployee(emp.id);
                              setState(() {
                                empList.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.delete_sweep,
                                color: Colors.redAccent),
                          )
                        ],
                      ),
                    ),
                  );
                });
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  openDialogueBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Employee Details'),
            content: Container(
              height: 300,
              width: 300,
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: 'Name'),
                  ),
                  TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(hintText: 'Location'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  submitAction(context);
                  refreshList();
                  Navigator.pop(context);
                },
                child: const Text('Submit'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              )
            ],
          );
        });
  }

  submitAction(BuildContext context) {
    if (employee == null) {
      Employee st = new Employee(
          name: _nameController.text, location: _locationController.text, id: 0);
      dbHelper.insertEmployee(st).then((value) => {
        _nameController.clear(),
        _locationController.clear(),
        print("Employee record added to db $value")
      });
    } else {
      employee.name = _nameController.text;
      employee.location = _locationController.text;

      dbHelper.updateEmployee(employee).then((value) => {
        _nameController.clear(),
        _locationController.clear(),
        setState(() {
          empList[updateIndex].name = _nameController.text;
          empList[updateIndex].location = _locationController.text;
        }),
      // employee = null;
      });
    }
  }
}
