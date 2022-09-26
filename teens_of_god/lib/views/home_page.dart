import 'package:flutter/material.dart';
import 'package:teens_of_god/globals.dart';
import 'package:teens_of_god/models/mentor.dart';
import 'package:teens_of_god/views/dashboard_screen.dart';
import 'package:teens_of_god/views/profile_screen.dart';
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

    List tabs = [const DashboardScreen(), const ProfileScreen()];
    return Scaffold(
      body: tabs[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: const Color(0xff3D8880),
        onTap: (index) {
          setState(() {
            _onItemTapped(index);
          });
        },
      ),
    );
  }
}
