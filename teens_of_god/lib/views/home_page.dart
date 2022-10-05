import 'package:flutter/material.dart';
import 'package:teens_of_god/globals.dart';
import 'package:teens_of_god/models/mentor.dart';
import 'package:teens_of_god/views/dashboard_screen.dart';
import 'package:teens_of_god/views/profile_screen.dart';
import 'package:teens_of_god/views/students_screen.dart';
import 'package:teens_of_god/views/volunteers_screen.dart';
import 'package:teens_of_god/widgets/buttons.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  initState() {
    super.initState();
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    void _onItemTapped(int index) {
      setState(() {
        selectedIndex = index;
      });
    }

    List tabs = [
      const DashboardScreen(),
      StudentsScreen(mentor: mentor),
      VolunteersScreen(mentor: mentor),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: tabs[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Volunteers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Color.fromARGB(255, 167, 146, 27),
        unselectedItemColor: Color.fromARGB(255, 163, 163, 163),
        unselectedLabelStyle:TextStyle(color:  Color.fromARGB(255, 163, 163, 163)),
        onTap: (index) {
          setState(() {
            _onItemTapped(index);
          });
        },
      ),
    );
  }
}
