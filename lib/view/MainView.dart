import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/controller/CurrentPage.dart';
import '/controller/CurrentUser.dart';

import '/model/User.dart';

import '/view/pages/HomeView.dart';
import '/view/pages/ProfileView.dart';

class MainView extends StatefulWidget {
  const MainView({
    super.key,
    Widget page = const HomeView(),
  });

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;
  final currentPage = CurrentPage();
  late User _user;

  late List<Map<String, dynamic>> _pages = [];

  void _loadPages() async {
    final currentUser = Provider.of<CurrentUser>(context, listen: false);
    await currentUser.loadFromStorage();
    _user = currentUser.user!;

    setState(() {
      _pages = [
        const {'title': 'Home', 'body': HomeView(), 'icon': Icons.home},
        const {'title': 'Post', 'icon': Icons.add_box},
        {
          'title': 'Profile',
          'body': ProfileView(profileId: _user.id),
          'icon': Icons.person
        },
      ];
    });
  }

  @override
  void initState() {
    super.initState();
    currentPage.setCurrentPage(const HomeView());
    _loadPages();
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      _showPostModalBottomSheet();
    } else {
      setState(() {
        _selectedIndex = index;
        currentPage.setCurrentPage(_pages[index]['body']);
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          currentPage.goBack();
        }
      },
      child: ChangeNotifierProvider(
        create: (context) => currentPage,
        child: (_pages.isEmpty)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Scaffold(
                body: Consumer<CurrentPage>(
                  builder: (context, currentPage, child) {
                    return currentPage.currentPage!;
                  },
                ),
                appBar: AppBar(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_pages[_selectedIndex]['title']),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                          ),
                          Text('${_user!.streak}',
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.star,
                          ),
                          Text('${_user!.points}',
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
                  selectedItemColor:
                      Theme.of(context).colorScheme.inversePrimary,
                  onTap: _onItemTapped,
                ),
              ),
      ),
    );
  }
}
