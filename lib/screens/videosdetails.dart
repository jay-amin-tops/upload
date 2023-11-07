import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class VideoDetailsPage extends StatefulWidget {
  final int courseId;
  final int? userId;

  VideoDetailsPage({required this.courseId, this.userId});

  @override
  _VideoDetailsPageState createState() => _VideoDetailsPageState();
}

class _VideoDetailsPageState extends State<VideoDetailsPage> {
  List<dynamic> _videoDetails = [];

  @override
  void initState() {
    super.initState();
    _fetchVideoDetails();
  }

  Future<void> _fetchVideoDetails() async {
    final url = Uri.parse('https://theeracivilservice.com/api/videos/${widget.courseId}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _videoDetails = json.decode(response.body);
      });
    } else {
      // Handle the error
      print('Failed to fetch video details. Error code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Details'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: _videoDetails.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _videoDetails.length,
              itemBuilder: (context, index) {
                final video = _videoDetails[index];
                return GestureDetector(
                  onTap: () {
                    _launchYouTube(video['Link']);
                  },
                  child: ListTile(
                    title: Text(
                      video['topic'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        _launchYouTube(video['Link']);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey[900],
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      child: Text('Play'),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _launchYouTube(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Failed to launch YouTube URL: $url');
    }
  }
}
