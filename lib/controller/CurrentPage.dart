import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bson/bson.dart';

import '/view/pages/ActivityView.dart';
import '/view/pages/ProfileView.dart';

class CurrentPage extends ChangeNotifier {
  final List<Widget> _pageStack = [];

  Widget? get currentPage => _pageStack.isNotEmpty ? _pageStack.last : null;

  void setCurrentPage(Widget page) {
    _pageStack.add(page);
    notifyListeners();
  }

  void redirectToProfile(ObjectId userId) {
    _pageStack.add(ProfileView(profileId: userId));
    notifyListeners();
  }

  void redirectToActivity(ObjectId activityId) {
    _pageStack.add(ActivityView(activityId: activityId));
    notifyListeners();
  }

  bool goBack() {
    if (_pageStack.length > 1) {
      _pageStack.removeLast();
      notifyListeners();
      return true;
    }
    return false;
  }
}
