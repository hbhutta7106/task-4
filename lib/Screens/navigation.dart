import 'package:flutter/material.dart';
import 'package:task_4/Screens/alluser.dart';
import 'package:task_4/Screens/firebaseuser.dart';
import 'package:task_4/constants.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  List<Widget> pages = const [
    AllUserScreen(),
    FirebaseUsersScreen(),
  ];
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: selectedIndex == 0
            ? const Text("Users")
            : const Text("Firebase Users"),
        backgroundColor: Colors.blue[400],
        centerTitle: true,
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        elevation: 2.0,
        selectedItemColor: Colors.blue,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        unselectedItemColor: lightTextColor,
        items: [
          BottomNavigationBarItem(
              tooltip: "Users",
              icon: Icon(
                Icons.home,
                color: selectedIndex == 0 ? Colors.blue : lightTextColor,
                size: 25,
              ),
              label: "Api Users"),
          BottomNavigationBarItem(
              activeIcon: const Icon(
                Icons.person_2_rounded,
                color: Colors.blue,
                size: 25,
              ),
              icon: Icon(
                Icons.person_2_rounded,
                color: selectedIndex == 1 ? Colors.blue : lightTextColor,
                size: 25,
              ),
              label: "Firebase Users"),
        ],
      ),
    );
  }
}
