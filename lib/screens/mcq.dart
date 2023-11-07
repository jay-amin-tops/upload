import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class McqPage extends StatefulWidget {
  final int? testId;
  final int? userId;

  const McqPage({Key? key, required this.testId, required this.userId}) : super(key: key);

  @override
  _McqPageState createState() => _McqPageState();
}

class _McqPageState extends State<McqPage> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  int? selectedOptionIndex;
  late Timer timer;
  Duration remainingTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<Duration> fetchTimeFromAPI() async {
    final response = await http.get(Uri.parse('https://theeracivilservice.com/api/exam/${widget.testId}'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData is List && jsonData.isNotEmpty) {
        final data = jsonData[0];
        if (data.containsKey('time')) {
          final time = data['time'];
          return parseDuration(time);
        }
      }
    }

    return Duration.zero;
  }

  Duration parseDuration(String time) {
    final parts = time.split(':');
    if (parts.length == 3) {
      final hours = int.tryParse(parts[0]) ?? 0;
      final minutes = int.tryParse(parts[1]) ?? 0;
      final seconds = int.tryParse(parts[2]) ?? 0;
      return Duration(hours: hours, minutes: minutes, seconds: seconds);
    }
    return Duration.zero;
  }

  void startTimer(Duration duration) {
    remainingTime = duration;
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (remainingTime.inSeconds > 0) {
          remainingTime -= Duration(seconds: 1);
        } else {
          timer.cancel(); // Stop the timer when it reaches zero
          // Perform any desired action when the timer ends
          Navigator.pop(context);
        }
      });
    });
  }

  Future<void> fetchQuestions() async {
    try {
      final time = await fetchTimeFromAPI();
      print('Time from API: $time');
      startTimer(time); // Start the timer with the fetched time
      final response = await http.get(Uri.parse('https://theeracivilservice.com/api/questions/${widget.testId}'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null && data is List<dynamic>) {
          setState(() {
            questions = List<Map<String, dynamic>>.from(data);
          });
        } else {
          print('Invalid data format: $data');
        }
      } else {
        print('Failed to fetch questions. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching questions: $error');
    }
  }

  void selectOption(int optionIndex) {
    setState(() {
      selectedOptionIndex = optionIndex;
    });
  }

  void goToNextQuestion() async {
    if (selectedOptionIndex != null) {
      final selectedOptionText = questions[currentQuestionIndex]['choice$selectedOptionIndex'];
      final questionId = questions[currentQuestionIndex]['id'];
      final testId = widget.testId;
      final userId = widget.userId; // Replace '123' with the actual user ID

      try {
        final response = await http.post(
          Uri.parse('https://theeracivilservice.com/api/exams/$testId'),
          body: {
            'exam_id': testId.toString(),
            'user_id': userId.toString(),
            'question_id': questionId.toString(),
            'choice': selectedOptionText,
          },
        );
        print(testId);
        print(userId);
        print(questionId);
        print(selectedOptionText);
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        if (response.statusCode == 200) {
          // Successfully submitted the answer
          if (currentQuestionIndex == questions.length - 1) {
            // Reached the last question, navigate back or perform desired action
            Navigator.pop(context);
          } else {
            // Move to the next question
            setState(() {
              currentQuestionIndex = (currentQuestionIndex + 1) % questions.length;
              selectedOptionIndex = null; // Reset selected option for the next question
            });
          }
        } else {
          // Handle the case when the answer submission fails
          print('Failed to submit answer. Status code: ${response.statusCode}');
        }
      } catch (error) {
        print('Error submitting answer: $error');
      }
    } else {
      print("Please Select an Option");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Please Select an Option'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
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
  void dispose() {
    timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String timerText = '${remainingTime.inHours.toString().padLeft(2, '0')}:${(remainingTime.inMinutes % 60).toString().padLeft(2, '0')}:${(remainingTime.inSeconds % 60).toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: Text('MCQ Page'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.grey[200],
        child: Center(
          child: questions.isEmpty
              ? CircularProgressIndicator()
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                questions[currentQuestionIndex]['question'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  ListTile(
                    title: Container(
                      height: 40, // Adjust the height as desired
                      color: selectedOptionIndex == 1 ? const Color.fromARGB(255, 0, 0, 0) : null,
                      child: Center(
                        child: Text(
                          questions[currentQuestionIndex]['choice1'],
                          style: TextStyle(
                            color: selectedOptionIndex == 1 ? Colors.white : Colors.black,
                            fontWeight: selectedOptionIndex == 1 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      selectOption(1);
                    },
                  ),
                  ListTile(
                    title: Container(
                      height: 40, // Adjust the height as desired
                      color: selectedOptionIndex == 2 ? const Color.fromARGB(255, 0, 0, 0) : null,
                      child: Center(
                        child: Text(
                          questions[currentQuestionIndex]['choice2'],
                          style: TextStyle(
                            color: selectedOptionIndex == 2 ? Colors.white : Colors.black,
                            fontWeight: selectedOptionIndex == 2 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      selectOption(2);
                    },
                  ),
                  ListTile(
                    title: Container(
                      height: 40, // Adjust the height as desired
                      color: selectedOptionIndex == 3 ? const Color.fromARGB(255, 0, 0, 0) : null,
                      child: Center(
                        child: Text(
                          questions[currentQuestionIndex]['choice3'],
                          style: TextStyle(
                            color: selectedOptionIndex == 3 ? Colors.white : Colors.black,
                            fontWeight: selectedOptionIndex == 3 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      selectOption(3);
                    },
                  ),
                  ListTile(
                    title: Container(
                      height: 40, // Adjust the height as desired
                      color: selectedOptionIndex == 4 ? const Color.fromARGB(255, 0, 0, 0) : null,
                      child: Center(
                        child: Text(
                          questions[currentQuestionIndex]['choice4'],
                          style: TextStyle(
                            color: selectedOptionIndex == 4 ? Colors.white : Colors.black,
                            fontWeight: selectedOptionIndex == 4 ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      selectOption(4);
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Remaining Time: $timerText',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: goToNextQuestion,
                child: Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

