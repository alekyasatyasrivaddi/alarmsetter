import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Alarm {
  final String name;
  final TimeOfDay time;

  Alarm({required this.name, required this.time});
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Alarm> alarms = [];

  void addAlarm() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      // Show dialog to enter alarm name
      showDialog(
        context: context,
        builder: (BuildContext context) {
          String alarmName = ''; // Initial value for the alarm name
          return AlertDialog(
            title: Text('Enter Alarm Name'),
            content: TextField(
              onChanged: (value) {
                alarmName = value; // Update alarmName as the user types
              },
              decoration: InputDecoration(hintText: 'Enter name'),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  if (alarmName.isNotEmpty) {
                    DateTime? t=DateTime(0,0,0,pickedTime.hour,pickedTime.minute);
                    String time = DateFormat.Hm().format(t);
                    DateFormat.Hm().format(t);
                    final Map<String,dynamic> addAlarm={
                      'name':alarmName,
                      'time':time,};
                      final Uri url = Uri.parse(
                      'http://localhost:8080/Create'); // Update with your Go server endpoint
                      print(addAlarm);
                      try {
                          final http.Response response = await http.post(
                              url,
                              body: jsonEncode(addAlarm),
                              headers: {'Content-Type': 'application/json'},
                          );
                          if (response.statusCode == 200) {
                              print('Data sent successfully');
                          } else {
                              print('Failed to send data: ${response.statusCode}');
                          }
                      } catch (e) {
                          print('Error: $e');
                      }
                    
                    setState(() {
                      alarms.add(Alarm(name: alarmName, time: pickedTime));
                    });
                    Navigator.of(context).pop(); // Close the dialog
                  }
                },
                child: Text('Add'),
              ),
            ],
          );
        },
      );
    }
  }

  void deleteAlarm(int index) {
    setState(() {
      alarms.removeAt(index);
    });
  }

  void deleteAllAlarms() {
    setState(() {
      alarms.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarm App'),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/homebackground.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: alarms.length,
                  itemBuilder: (context, index) {
                    final alarm = alarms[index];
                    return ListTile(
                      title: Text(alarm.name),
                      subtitle: Text('Time: ${alarm.time.format(context)}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Delete Alarm'),
                                content: Text('Are you sure you want to delete this alarm?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      deleteAlarm(index);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: addAlarm,
                      child: Text('Add Alarm'),
                    ),
                    SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete All Alarms'),
                              content: Text('Are you sure you want to delete all alarms?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    deleteAllAlarms();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Delete All'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Delete All'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
