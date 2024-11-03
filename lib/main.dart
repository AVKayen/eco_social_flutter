import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'view/FeedView.dart';
import 'view/HomeView.dart';
import 'view/ProfileView.dart';

void main() {
  runApp(const EcoSocial());
}

class EcoSocial extends StatelessWidget {
  const EcoSocial({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eco Social App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const View(),
    );
  }
}

class View extends StatefulWidget {
  const View({super.key});

  @override
  State<View> createState() => _ViewState();
}

class _ViewState extends State<View> {
  int _selectedIndex = 0;

  void setDefaultPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', '672748d470e4e2a12d6cd21b');
  }

  static const List<Map<String, dynamic>> _pages = [
    {'title': 'Home', 'body': HomeView(), 'icon': Icons.home},
    {'title': 'Feed', 'body': FeedView(), 'icon': Icons.menu},
    {'title': 'Profile', 'body': ProfileView(), 'icon': Icons.person},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex]['body'],
      bottomNavigationBar: BottomNavigationBar(
        items: _pages.map((page) {
          return BottomNavigationBarItem(
            icon: Icon(page['icon']),
            label: page['title'],
          );
        }).toList(),
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.inversePrimary,
        onTap: _onItemTapped,
      ),
    );
  }
}
