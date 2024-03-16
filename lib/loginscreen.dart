import 'package:flutter/material.dart';
import 'package:alarm/homescreen.dart';
import 'package:alarm/registration.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  RegExp passwordExp = RegExp(r"^(?=.*[A-Za-z])(?=.*\d).{8,}$");

  Future<void> login() async {
    String email = emailController.text;
    String password = passwordController.text;

    if (emailRegExp.hasMatch(email) && passwordExp.hasMatch(password)) {
          Uri url = Uri.parse("http://localhost:8080/send-data");
          Map<String, String> headers = {"Content-type": "application/json"};

          String json =
              '{"message": "Hello from Flutter","Email": "$email","Password": "$password"}';
          http.Response response =
              await http.post(url, headers: headers, body: json);
          if (response.statusCode == 200) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Verification Successful'),
                  content: Text('Login  successful!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
            print('Data sent successfully');
          } else {
            print('Failed to send data. Status code: ${response.statusCode}');
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Verification Failed'),
                  content: Text('Invalid User And Password.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'Please enter a valid email and a password with at least 8 characters, including uppercase, lowercase, and numbers.'),
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
        title: Text('Login'),
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/images/background_image.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/login_image.jpg',
                        width: 200,
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        width: double.infinity,
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 24.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        width: double.infinity,
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(labelText: 'Email'),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        width: double.infinity,
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(labelText: 'Password'),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: login,
                          child: Text('Login'),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Card(
                        child: ListTile(
                          title: Text(
                            'Sign Up',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14.0), // Adjust font size here
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegistrationScreen()),
                            );
                          },
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
