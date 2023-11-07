import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
// import "package:theeracivilservice/screens/extras/fetchscreen.dart";
// import "package:theeracivilservice/screens/homepage.dart";
import "package:theeracivilservice/screens/login.dart";
// import 'package:flutter_downloader/flutter_downloader.dart';


void main(List<String> args) {
  runApp(TheeraApp());
}
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   FlutterDownloader.initialize(debug: true); // Initialize the flutter_downloader plugin
//   runApp(TheeraApp());
// }
class TheeraApp extends StatelessWidget {
  const TheeraApp({super.key});

  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 253, 252, 252),
        fontFamily: GoogleFonts.dmSans().fontFamily
      ),
      // home: Homepage(),
      home: LoginPage(),
    );
  }
}
