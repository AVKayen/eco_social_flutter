import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MainView.dart';

import 'repository/AuthRepository.dart';

final AuthRepository _authRepository = TemplateAuthRepository();

void main() {
  runApp(const EcoSocial());
}

class EcoSocial extends StatelessWidget {
  const EcoSocial({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eco Social App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: const App(),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _App();
}

class _App extends State<App> {
  void setDefaultPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', '672748e315d90bf94058fb04');
  }

  void _check_login() async {
    setDefaultPrefs();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainView()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _check_login();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
