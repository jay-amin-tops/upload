import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:theeracivilservice/screens/homepage.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  Future<String?> _register() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String mobile = _mobileController.text;

    var response = await http.post(
      Uri.parse('https://theeracivilservice.com/api/register'),
      body: {
        'name': name,
        'email': email,
        'password': password,
        'mobile': mobile,
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      String? token = jsonResponse['token'];
      int? userId = jsonResponse['userId'];

      if (token != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => HomePage(userId: userId!),
          ),
        );
      } else {
        print('Registration failed: Token not found');
      }
    } else if (response.statusCode == 409) {
      var jsonResponse = jsonDecode(response.body);
      String? errorMessage = jsonResponse['message'];
      if (errorMessage == 'Email already exists') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Registration Failed'),
              content: Text('The provided email is already registered.'),
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
      } else {
        print('Registration failed');
      }
    } else {
      print('Registration failed');
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with registration
      setState(() {
        _isSubmitting = true;
      });
      _register();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
        backgroundColor: Colors.blueGrey[900], // Change the color of the app bar here
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
        Color.fromARGB(255, 0, 0, 0), // Replace with your desired dark color
        Color.fromARGB(78, 0, 0, 0), // Replace with your desired dark color

            ],
          ),
        ),
        padding: EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 40.0), // Added spacing on top and bottom
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  // border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 255, 255).withOpacity(1),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  // border: OutlineInputBorder(),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(1),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  // border: OutlineInputBorder(),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(1),
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _mobileController,
                decoration: InputDecoration(
                  labelText: 'Mobile',
                  labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  // border: OutlineInputBorder(),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(1),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your mobile number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 0, 0, 0),
                  onPrimary: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  textStyle: TextStyle(fontSize: 18.0),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
