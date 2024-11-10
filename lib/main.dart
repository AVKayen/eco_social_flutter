import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'view/MainView.dart';

import 'controller/CurrentUser.dart';
import 'repository/AuthRepository.dart';
import 'model/User.dart';

final AuthRepository _authRepository = TemplateAuthRepository();

void main() {
  runApp(const EcoSocial());
}

class EcoSocial extends StatelessWidget {
  const EcoSocial({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrentUser()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Eco Social App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        home: const App(),
      ),
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _App();
}

class _App extends State<App> {
  User? _user;
  CurrentUser currentUser = CurrentUser();

  //TEMPORARY
  void setDefaultPrefs() async {
    final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

    await asyncPrefs.setString('token', '672748e315d90bf94058fb04');
  }

  void _checkToken() async {
    currentUser.loadFromStorage();
    _user = currentUser.user;
    if (_user != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MainView()),
      );
    }
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
        ),
      ),
    );
  }
}
