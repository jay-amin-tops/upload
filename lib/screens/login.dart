import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:theeracivilservice/screens/homepage.dart';
import 'package:theeracivilservice/screens/registration_page.dart';
import 'dart:async';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<String?> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    var response = await http.post(
      Uri.parse('https://theeracivilservice.com/api/users'),
      body: {'email': email, 'password': password},
    );

    print('Response Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      String? token = jsonResponse['token'];
      int? userId = jsonResponse['id'];
      String? status = jsonResponse['status'];

      if (status == 'success') {
        if (token != null) {
          print(userId);
          // Check if the email is verified
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomePage(userId: userId),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Email not verified'),
                content: Text('Please verify your email before logging in.'),
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
      } else {
        print('Login failed');
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login failed'),
            content: Text('Please check your credentials and try again.'),
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
      print('Login failed');
    }
  }

  void _navigateToRegistrationPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => RegistrationPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
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
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  // border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 255, 255).withOpacity(1),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  // border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 255, 255).withOpacity(1),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  _login();
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 0, 0, 0),
                  onPrimary: Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  textStyle: TextStyle(fontSize: 18.0),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text('Login'),
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: _navigateToRegistrationPage,
                child: Text(
                  'Don\'t have an account? Register here',
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
