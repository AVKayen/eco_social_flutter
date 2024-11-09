import 'package:flutter/material.dart';

class CurrentPage extends ChangeNotifier {
  final List<Widget> _pageStack = [];

  Widget? get currentPage => _pageStack.isNotEmpty ? _pageStack.last : null;

  void setCurrentPage(Widget page) {
    _pageStack.add(page);
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