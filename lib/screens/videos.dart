import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:theeracivilservice/screens/toppers.dart';
import 'package:theeracivilservice/screens/homepage.dart';
import 'package:theeracivilservice/screens/bottomnavigation.dart';
import 'package:theeracivilservice/screens/coursedetails.dart';

class VideosPage extends StatefulWidget {
  final int? userId;
  
  VideosPage({required this.userId});

  @override
  _VideosPageState createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  List<dynamic> _videos = [];
  int _selectedIndex = 0;

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
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    var response = await http.get(Uri.parse('https://theeracivilservice.com/api/videos'));
    if (response.statusCode == 200) {
      setState(() {
        _videos = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Videos'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body:  Container(
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
        child :_videos.isNotEmpty
          ? ListView.builder(
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                var video = _videos[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: TextButton(
                      child: Text(
                        'Play',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 18,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 255, 255, 255)),
                        minimumSize: MaterialStateProperty.all<Size>(Size(80, 50)),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(8)),
                      ),
                      onPressed: () {
                        String videoUrl = video['Link'];
                        _launchURL(videoUrl);
                      },
                    ),
                    title: Text(
                      video['topic'],
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Failed to launch URL: $url');
    }
  }
}
