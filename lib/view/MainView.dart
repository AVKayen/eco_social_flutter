import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_input/image_input.dart';

import '/controller/CurrentPage.dart';
import '/controller/CurrentUser.dart';

import '/repository/ActivityRepository.dart';

import '/model/User.dart';
import '/model/Activity.dart';

import '/view/pages/HomeView.dart';
import '/view/pages/ProfileView.dart';

ActivityRepository _activityRepository = HttpActivityRepository();

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
    setState(() {
      _user = currentUser.user!;
    });

    setState(() {
      _pages = [
        const {'title': 'Home', 'body': HomeView(), 'icon': Icons.home},
        const {'title': 'Post', 'icon': Icons.add_box},
        {'title': 'Profile', 'body': const ProfileView(), 'icon': Icons.person},
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

  void _showPostModalBottomSheet() async {
    final currentUser = Provider.of<CurrentUser>(context, listen: false);
    TextEditingController descController = TextEditingController();
    TextEditingController titleController = TextEditingController();
    int activityTypeSelected = ActivityType.other;
    List<XFile> images = [];
    bool isLoading = false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setLocalState) {
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ImageInput(
                      images: images,
                      allowMaxImage: 3,
                      onImageSelected: (XFile image) {
                        setLocalState(() {
                          images.add(image);
                        });
                      },
                      onImageRemoved: (XFile image, int index) {
                        setLocalState(() {
                          images.removeAt(index);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButton<int>(
                      value: activityTypeSelected,
                      onChanged: (int? newValue) {
                        setLocalState(() {
                          activityTypeSelected = newValue!;
                        });
                      },
                      items: activityTypeFromName.values.map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(activityNameFromType[value]!),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descController,
                      decoration: const InputDecoration(
                        hintText: 'Description (optional)',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    (isLoading)
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              if (titleController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.only(
                                        bottom:
                                            MediaQuery.of(context).size.height -
                                                150,
                                        right: 20,
                                        left: 20),
                                    content:
                                        const Text('Title cannot be empty'),
                                  ),
                                );
                                return;
                              }
                              final newActivity = ActivityForm(
                                title: titleController.text,
                                caption: descController.text,
                                activityType: activityTypeSelected,
                                images: images,
                              );
                              setLocalState(() {
                                isLoading = true;
                              });
                              await _activityRepository.createActivity(
                                  activity: newActivity,
                                  token: currentUser.token!);
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Post submitted successfully')),
                              );
                              currentUser.refreshUser();
                            },
                            child: const Text('Submit'),
                          ),
                  ],
                ),
              ),
            );
          },
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
        builder: (context, child) {
          if (_pages.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                final currentUser =
                    Provider.of<CurrentUser>(context, listen: false);
                final currentPageProvider =
                    Provider.of<CurrentPage>(context, listen: false);
                await currentUser.refreshUser();
                currentPageProvider.refresh();
              },
              child: Scaffold(
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
                      Consumer<CurrentUser>(
                          builder: (context, currentUser, child) => Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.local_fire_department,
                                  ),
                                  Text('${currentUser.user!.streak}',
                                      style: const TextStyle(fontSize: 16)),
                                  const SizedBox(width: 16),
                                  const Icon(
                                    Icons.star,
                                  ),
                                  Text('${currentUser.user!.points}',
                                      style: const TextStyle(fontSize: 16)),
                                ],
                              )),
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
            );
          }
        },
      ),
    );
  }
}
