import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:theeracivilservice/screens/bottomnavigation.dart';
import 'package:theeracivilservice/screens/coursedetails.dart';
import 'package:theeracivilservice/screens/videos.dart';
import 'package:theeracivilservice/screens/homepage.dart';

class ToppersPage extends StatefulWidget {
  final int? userId;

  ToppersPage({required this.userId});

  @override
  _ToppersPageState createState() => _ToppersPageState();
}

class _ToppersPageState extends State<ToppersPage> {
  int _selectedIndex = 0;
  List<dynamic> _toppers = [];

  // static const List<Widget> _widgetOptions = <Widget>[
  //   Text('Home Page'),
  //   Text('Courses Page'),
  //   Text('Toppers Page'),
  //   Text('Videos Page'),
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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

  @override
  void initState() {
    super.initState();
    _fetchToppers();
  }

  Future<void> _fetchToppers() async {
    var response = await http.get(Uri.parse('https://theeracivilservice.com/api/toppers'));
    if (response.statusCode == 200) {
      setState(() {
        _toppers = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Toppers'),
        backgroundColor: Colors.blueGrey[900],
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
        child: _toppers.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _toppers.length,
                itemBuilder: (context, index) {
                  final topper = _toppers[index];
                  return ListTile(
                    leading: Container(
                      width: 120, // Increase the width
                      height: 120, // Increase the height
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 1.0,
                        ),
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://theeracivilservice.com/storage/' + topper['image'],
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(
                      topper['name'],
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Year: ${topper['year']}, Rank: ${topper['rank']}',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
