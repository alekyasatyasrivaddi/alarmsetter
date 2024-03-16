import 'dart:convert';

import 'package:alarm/loginscreen.dart';
import 'package:flutter/material.dart';
import 'package:alarm/homescreen.dart';
import 'package:http/http.dart' as http;

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  void register() async {
    String username = usernameController.text;
    String password = passwordController.text;
    String city = cityController.text;
    String email = emailController.text;
    String phoneNumber = phoneNumberController.text;

    RegExp nameExp = RegExp(r"^[a-zA-Z\s]+$");
    RegExp emailExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    RegExp passwordExp = RegExp(r"^(?=.*[A-Za-z])(?=.*\d).{8,}$");
    RegExp cityExp = RegExp(r"^[a-zA-Z\s]+$");
    RegExp phoneExp = RegExp(r"^\d{10}$");

    if (username.isNotEmpty &&
        password.isNotEmpty &&
        city.isNotEmpty &&
        email.isNotEmpty &&
        phoneNumber.isNotEmpty &&
        nameExp.hasMatch(username) &&
        passwordExp.hasMatch(password) &&
        cityExp.hasMatch(city) &&
        emailExp.hasMatch(email) &&
        phoneExp.hasMatch(phoneNumber)) {
      final Map<String, dynamic> datasend = {
                            'UserName': username,
                            'email': email,
                            'password': password,
                            'city':city,
                            'Phnno':phoneNumber
                          };
                          print(datasend);
                          try {
                            http.Response response = await http.post(
                              Uri.parse('http://localhost:8080/Createaccount'),
                              body: jsonEncode(datasend),
                              headers: {"Content-Type": "application/json"},
                            );

                            if (response.statusCode == 200) {
                              print('Data sent successfully');
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Registration status!'),
                                    content: Text(
                                      'Registration  successful! Please login to continue.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen(),
                                            ),
                                          );
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              print(
                                  'Failed to send data: ${response.statusCode}');
                            }
                          } catch (e) {
                            print('Error: $e');
                          }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all fields correctly.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/regbackground.jpg',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo Image Widget
                      Image.asset(
                        'assets/images/registration.jpg',
                        width: 150, // Set width according to your preference
                        height: 150, // Set height according to your preference
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Registration Screen',
                        style: TextStyle(fontSize: 24.0),
                      ),
                      SizedBox(height: 16.0),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextField(
                              controller: usernameController,
                              decoration: InputDecoration(labelText: 'Username'),
                            ),
                            SizedBox(height: 8.0),
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(labelText: 'Email'),
                            ),
                            SizedBox(height: 8.0),
                            TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(labelText: 'Password'),
                            ),
                            SizedBox(height: 8.0),
                            TextField(
                              controller: cityController,
                              decoration: InputDecoration(labelText: 'City'),
                            ),
                            
                            SizedBox(height: 8.0),
                            TextField(
                              controller: phoneNumberController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(labelText: 'Phone Number'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: ElevatedButton(
                          onPressed: register,
                          child: Text('Register'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
