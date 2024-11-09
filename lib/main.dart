import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'view/MainView.dart';

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
  bool _isLoggedIn = false;

  void setDefaultPrefs() async {
    final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

    await asyncPrefs.setString('token', '672748e315d90bf94058fb04');
  }

  void _checkToken() async {
    final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

    final String? token = await asyncPrefs.getString('token');

    setState(() {
      _isLoggedIn = (token != null && token.isNotEmpty);
    });

    if (_isLoggedIn && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainView()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: TextButton(
        onPressed: () {
          setDefaultPrefs();
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MainView()),
          );
        },
        child: const Text('Login'),
      )),
    );
  }
}
