import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:theeracivilservice/screens/bottomnavigation.dart';
import 'package:theeracivilservice/screens/coursedetails.dart';
import 'package:theeracivilservice/screens/toppers.dart';
import 'package:theeracivilservice/screens/videos.dart';

class HomePage extends StatefulWidget {
  final int? userId;

  HomePage({required this.userId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> pages = [];

  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage(userId: widget.userId)),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CoursePage(userId: widget.userId)),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ToppersPage(userId: widget.userId)),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VideosPage(userId: widget.userId)),
      );
    }
  }

  Map<String, dynamic> _welcomeInfo = {};
  Map<String, dynamic> _aboutData = {};

  @override
  void initState() {
    super.initState();
    _fetchWelcomeInfo();
    _fetchAboutData();
  }

  Future<void> _fetchWelcomeInfo() async {
    var response = await http.get(Uri.parse('https://theeracivilservice.com/api/welcome-information'));
    if (response.statusCode == 200) {
      setState(() {

        _welcomeInfo = json.decode(response.body);
        print(_welcomeInfo['image1']);
      });
    }
  }

  Future<void> _fetchAboutData() async {
    var response = await http.get(Uri.parse('https://theeracivilservice.com/api/abouts'));
    if (response.statusCode == 200) {
      setState(() {
        _aboutData = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_welcomeInfo.isNotEmpty)
                Column(
                  children: [
                    SizedBox(height: 25),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 2.0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.all(8.0),
                        child: Image.network(
                          
                          'https://theeracivilservice.com/storage/${_welcomeInfo['image1']}',
                          width: 350,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 2.0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.all(8.0),
                        child: Image.network(
                          'https://theeracivilservice.com/storage/${_welcomeInfo['image2']}',
                          width: 350,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        _welcomeInfo['heading'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Change the color of the heading text here
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        _welcomeInfo['slogan'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Change the color of the slogan text here
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        'Contact Us At: ${_welcomeInfo['contact']}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Change the color of the contact text here
                        ),
                      ),
                    ),
                    SizedBox(height: 100),
                  ],
                )
              else
                Center(child: CircularProgressIndicator()),

              if (_aboutData.isNotEmpty)
                Column(
                  children: [
                    SizedBox(height: 25),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 2.0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.all(8.0),
                        child: Image.network(
                          'https://theeracivilservice.com/storage/${_aboutData['image']}',
                          width: 350,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        _aboutData['title'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Change the color of the title text here
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        _aboutData['description'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Change the color of the description text here
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Special Features:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Change the color of the special features text here
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _aboutData['points1'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Change the color of the points text here
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _aboutData['points2'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Change the color of the points text here
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _aboutData['points3'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Change the color of the points text here
                      ),
                    ),
                  ],
                )
              else
                Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
      ),
    );
  }
}
