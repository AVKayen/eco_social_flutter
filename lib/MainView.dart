import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'view/HomeView.dart';
import 'view/ProfileView.dart';
import 'model/User.dart';
import 'repository/UserRepository.dart';

final _userRepository = TemplateUserRepository();

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;
  late User _user;
  bool _isUserLoaded = false;

  static const List<Map<String, dynamic>> _pages = [
    {'title': 'Home', 'body': HomeView(), 'icon': Icons.home},
    {'title': 'Post', 'icon': Icons.add_box},
    {'title': 'Profile', 'body': ProfileView(), 'icon': Icons.person},
  ];

  void _getCurrentUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      throw Exception('Token not found');
    }
    final User user = await _userRepository.getUserByToken(token: token);
    setState(() {
      _user = user;
      _isUserLoaded = true;
      print("User loaded: $_user");
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      _showPostModalBottomSheet();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showPostModalBottomSheet() {
    TextEditingController postController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Create a new post',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: postController,
                  decoration: const InputDecoration(
                    hintText: 'Description (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Post submitted successfully')),
                    );
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex]['body'],
      appBar: AppBar(
        title: Row(
          // TODO: Change text to Icons and add a progress to next level bar
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_pages[_selectedIndex]['title']),
            if (_isUserLoaded)
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Streak: ${_user.streak}',
                      style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 16),
                  Text('Points: ${_user.points}',
                      style: const TextStyle(fontSize: 16)),
                ],
              ),
          ],
        ),
      ),
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
