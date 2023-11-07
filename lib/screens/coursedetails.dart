import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import "package:theeracivilservice/screens/bottomnavigation.dart";
import "package:theeracivilservice/screens/toppers.dart";
import "package:theeracivilservice/screens/videos.dart";
import "package:theeracivilservice/screens/materials.dart";
import "package:theeracivilservice/screens/tests.dart";
import "package:theeracivilservice/screens/videosdetails.dart";
import "package:theeracivilservice/screens/homepage.dart";

class CoursePage extends StatefulWidget {
  final int? userId;
  CoursePage({required this.userId});

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  int _selectedIndex = 0;
  List<dynamic> _courses = [];

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
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    var response =
        await http.get(Uri.parse('https://theeracivilservice.com/api/courses'));
    if (response.statusCode == 200) {
      setState(() {
        _courses = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
        backgroundColor: Colors.blueGrey[900],

      ),
      body: Container(
       decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
                      // Color.fromARGB(255, 248, 167, 5),
                      // Color.fromARGB(255, 13, 145, 211),
                      // Color.fromARGB(255, 19, 199, 19),

        //      Color.fromARGB(255, 211, 181, 181), // Replace with your desired dark color
        // Color.fromARGB(255, 174, 221, 143),


        Color.fromARGB(255, 0, 0, 0), // Replace with your desired dark color
        Color.fromARGB(78, 0, 0, 0), // Replace with your desired dark color

// Color(0xFF2E7D32), // Darker shade of green
//     Color(0xFF1B5E20), 


        // Color.fromARGB(255, 13, 13, 13),
              // Color.fromARGB(255, 197, 168, 202),
              // const Color.fromARGB(255, 49, 43, 59),
            ],
          ),
        ),
      child:
      _courses.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(50.0),
              
              // SizedBox

              itemCount: _courses.length,
              itemBuilder: (context, index) {
                final course = _courses[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CourseDetailsScreen(course: course, userId: widget.userId),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.only(bottom: 50.0), // Add margin between the tiles

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 2.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            'https://theeracivilservice.com/storage/' +
                                course['image'],
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
            color: Color.fromARGB(255, 243, 243, 243),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            
                            children: [
                              Text(
                                course['name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35.0,
                                  color: const Color.fromARGB(255, 2, 2, 2),

                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                course['sub_name'],
                                style: TextStyle(
                                  fontSize: 25.0,
                                  color: const Color.fromARGB(255, 2, 2, 2),
                                ),
                              ),
                         
                            ],
                          ),
                          
                        ),
                    ),
                      ],
                    ),
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


class CourseDetailsScreen extends StatelessWidget {
  final dynamic course;
  final int? userId;

  CourseDetailsScreen({required this.course, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Details'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          // color: Colors.grey[200],
          color:        Color.fromARGB(255, 14, 13, 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 10 / 10, // Set the desired aspect ratio here
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(1000.0),
                  child: Image.network(
                    'https://theeracivilservice.com/storage/' + course['image'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
               SizedBox(height: 86),
              Text(
                'Course Name:   ${course['name']}',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            
              SizedBox(height: 25),
              Text(
                'Course Title:   ${course['sub_name']}',
                // course['sub_name'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              SizedBox(height: 25),
              Text(
                
                course['heading'],
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              SizedBox(height: 25),
              Text(
                'Price: ${course['price']}',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              SizedBox(height: 25),
              Text(
                'Summary:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              SizedBox(height:10),
              Text(
                course['small_description'],
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Description:',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              SizedBox(height: 8),
              Text(
                course['description'],
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final courseId = course['id'];
                      if (courseId != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TestsPage(courseId: courseId, userId: userId),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueGrey[900],
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    child: Text('Tests'),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      final courseId = course['id'];
                      if (courseId != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MaterialsPage(courseId: courseId, userId: userId),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueGrey[900],
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    child: Text('Materials'),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      final courseId = course['id'];
                      if (courseId != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoDetailsPage(courseId: courseId, userId: userId),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blueGrey[900],
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    child: Text('Videos'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
