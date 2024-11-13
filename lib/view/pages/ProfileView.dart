import 'package:flutter/material.dart';
import 'package:bson/bson.dart';
import 'package:provider/provider.dart';

import '/controller/CurrentUser.dart';
import '/controller/CurrentPage.dart';

import '/repository/UserRepository.dart';
import '/repository/ActivityRepository.dart';

import '/model/User.dart';
import '/model/Activity.dart';

import '/components/ProfileWidget.dart';
import '/components/ActivityWidget.dart';

final _userRepository = HttpUserRepository();
final _activityRepository = HttpActivityRepository();

class ProfileView extends StatefulWidget {
  final ObjectId? profileId;

  const ProfileView({super.key, this.profileId});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  dynamic _profile;
  final List<Activity> _activities = [];
  late CurrentUser _currentUser;
  late CurrentPage _currentPage;
  List<PrivateProfile> _friends = [];
  bool _isCurrentUser = false;

  void _getProfile() async {
    final CurrentPage currentPage =
        Provider.of<CurrentPage>(context, listen: false);
    final CurrentUser currentUser =
        Provider.of<CurrentUser>(context, listen: false);
    if (currentUser.token == null || currentUser.user == null) {
      Navigator.pop(context);
      throw Exception('User not found');
    }

    late dynamic profile;

    if (widget.profileId == null || widget.profileId == currentUser.user!.id) {
      profile = currentUser.user!;

      setState(() {
        _currentPage = currentPage;
        _currentUser = currentUser;
      });

      if (_friends.isEmpty) {
        for (final ObjectId friendId in currentUser.user!.friends) {
          final PrivateProfile? friend = await _userRepository.getUserProfile(
              id: friendId, token: currentUser.token!);
          if (friend != null) {
            setState(() {
              _friends.add(friend);
            });
          }
        }
      }
    } else {
      profile = await _userRepository.getUserProfile(
          id: widget.profileId!, token: currentUser.token!);
    }

    if (profile == null) {
      throw Exception('User not found');
    }

    if (profile.runtimeType == User) {
      setState(() {
        _isCurrentUser = true;
      });
    } else {
      setState(() {
        _isCurrentUser = false;
      });
    }
    setState(() {
      _profile = profile!;
    });
    if ((_profile.runtimeType == PrivateProfile ||
            _profile.runtimeType == User) &&
        _activities.isEmpty) {
      for (final ObjectId activityId in _profile!.activities.reversed) {
        final Activity? activity = await _activityRepository.getActivity(
            id: activityId, token: currentUser.token!);
        if (activity != null) {
          setState(() {
            _activities.add(activity);
          });
        }
      }
    }
  }

  void _showFriendsDialog() {
    Set<int> selected = {0};
    String changeKey = '';
    List<PublicProfile> searchResults = [];

    Widget pendingRequests() {
      return (_profile!.incomingRequests.isNotEmpty)
          ? Column(
              children: [
                for (final FriendshipRequest request
                    in _profile!.incomingRequests)
                  Row(
                    children: [
                      TextButton(
                        style: const ButtonStyle(
                          foregroundColor:
                              WidgetStatePropertyAll<Color>(Colors.black),
                        ),
                        onPressed: () async {
                          _currentPage.redirectToProfile(request.userId);
                          Navigator.pop(context);
                        },
                        child: Text(request.username),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () async {
                              await _userRepository.acceptFriendRequest(
                                  userId: request.userId,
                                  token: _currentUser.token!);
                              _currentPage.redirectToProfile();
                              _currentUser.refreshUser();
                              _getProfile();
                              _profile!.incomingRequests.remove(request);
                              Navigator.pop(context);
                            },
                            child: const Text('Accept'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await _userRepository.rejectFriendRequest(
                                  userId: request.userId,
                                  token: _currentUser.token!);
                              _currentPage.redirectToProfile();
                              _currentUser.refreshUser();
                              _getProfile();
                              _profile!.incomingRequests.remove(request);
                              Navigator.pop(context);
                            },
                            child: const Text('Decline'),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            )
          : const Column(
              children: [
                Text('No pending requests'),
              ],
            );
    }

    Widget friendsList() {
      return (_friends.isNotEmpty)
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              for (final PrivateProfile friend in _friends)
                TextButton(
                    style: const ButtonStyle(
                      foregroundColor:
                          WidgetStatePropertyAll<Color>(Colors.black),
                    ),
                    onPressed: () {
                      _currentPage.redirectToProfile(friend.id);
                      Navigator.pop(context);
                    },
                    child: Row(children: [
                      Text(friend.username),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.local_fire_department,
                      ),
                      Text('${friend.streak}'),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.star,
                      ),
                      Text('${friend.points}'),
                      TextButton(
                          style: const ButtonStyle(
                            foregroundColor:
                                WidgetStatePropertyAll<Color>(Colors.black),
                          ),
                          onPressed: () async {
                            await _userRepository.removeFriend(
                                userId: friend.id, token: _currentUser.token!);
                            _currentPage.redirectToProfile();
                            _currentUser.refreshUser();
                            _getProfile();
                            _friends.remove(friend);
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.remove_circle)),
                    ])),
            ])
          : const Text('No friends yet, add some in the third card');
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: SegmentedButton(
                segments: const [
                  ButtonSegment(
                    value: 0,
                    label: Text('Requests',
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 10, overflow: TextOverflow.clip)),
                    icon: Icon(Icons.mail),
                  ),
                  ButtonSegment(
                    value: 1,
                    label: Text('Friends', style: TextStyle(fontSize: 10)),
                    icon: Icon(Icons.people),
                  ),
                  ButtonSegment(
                    value: 2,
                    label: Text('Add Friends', style: TextStyle(fontSize: 10)),
                    icon: Icon(Icons.person_add),
                  ),
                ],
                selected: selected,
                onSelectionChanged: (Set<int> value) {
                  setState(() {
                    selected = value;
                  });
                },
              ),
              content: selected.contains(0)
                  ? pendingRequests()
                  : selected.contains(1)
                      ? friendsList()
                      : Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: TextField(
                                    onChanged: (String value) {
                                      changeKey = value;
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Search for friends',
                                    ),
                                    onSubmitted: (String value) async {
                                      List<PublicProfile> results =
                                          await _userRepository.searchUsers(
                                              query: value,
                                              token: _currentUser.token!);
                                      setState(() {
                                        searchResults = results;
                                      });
                                    },
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    List<PublicProfile> results =
                                        await _userRepository.searchUsers(
                                            query: changeKey,
                                            token: _currentUser.token!);
                                    setState(() {
                                      searchResults = results;
                                    });
                                  },
                                  child: const Text('Search'),
                                ),
                              ],
                            ),
                            (searchResults.isEmpty)
                                ? const Text('No results')
                                : Column(
                                    children: [
                                      for (final PublicProfile result
                                          in searchResults)
                                        Row(children: [
                                          TextButton(
                                            onPressed: () {
                                              _currentPage
                                                  .redirectToProfile(result.id);
                                              Navigator.pop(context);
                                            },
                                            child: Text(result.username),
                                          ),
                                          IconButton(
                                            onPressed: () async {
                                              await _userRepository.addFriend(
                                                  userId: result.id,
                                                  token: _currentUser.token!);
                                              _currentPage.redirectToProfile();
                                              _currentUser.refreshUser();
                                              _getProfile();
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(Icons.person_add),
                                          ),
                                        ])
                                    ],
                                  ),
                          ],
                        ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void didUpdateWidget(ProfileView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profileId != widget.profileId) {
      _getProfile();
      _activities.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return _profile == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              ProfileWidget(user: _profile!),
              (_isCurrentUser)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _showFriendsDialog();
                          },
                          child: const Text('Friends'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            await _currentUser.logout();
                            Navigator.pushNamedAndRemoveUntil(
                                // below line is safe as we are using custom router
                                // ignore: use_build_context_synchronously
                                context,
                                '/',
                                (route) => false);
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    )
                  : Container(),
              Expanded(
                child: ListView.builder(
                  itemCount: _activities.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Activity activity = _activities[index];
                    return Column(
                      children: [
                        ActivityWidget(activity: activity, showProfile: false),
                        const Divider(
                          height: 0,
                          indent: 16,
                          endIndent: 16,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
  }
}
