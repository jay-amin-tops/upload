import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  BottomNavBar({required this.selectedIndex, required this.onItemTapped});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Courses',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Toppers',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.video_library),
          label: 'Videos',
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: const Color.fromARGB(255, 0, 0, 0), // Set the selected item color
      unselectedItemColor: const Color.fromARGB(255, 0, 0, 0), // Set the unselected item color
      backgroundColor: const Color.fromARGB(255, 255, 255, 255) ,
      onTap: widget.onItemTapped,
    );
  }
}
