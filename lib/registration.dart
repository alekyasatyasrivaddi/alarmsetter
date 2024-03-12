import 'package:flutter/material.dart';
import 'package:alarm/homescreen.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  void register() {
    String username = usernameController.text;
    String password = passwordController.text;
    String city = cityController.text;
    String dob = dobController.text;
    String phoneNumber = phoneNumberController.text;
    if (username.isNotEmpty &&
        password.isNotEmpty &&
        city.isNotEmpty &&
        dob.isNotEmpty &&
        phoneNumber.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all fields.'),
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
            'assets/images/regbackground.png', 
            fit: BoxFit.cover,
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
                      Text(
                        'Registration Screen',
                        style: TextStyle(fontSize: 24.0),
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(labelText: 'Username'),
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
                        controller: dobController,
                        decoration: InputDecoration(labelText: 'Date of Birth'),
                      ),
                      SizedBox(height: 8.0),
                      TextField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(labelText: 'Phone Number'),
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.3,
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
