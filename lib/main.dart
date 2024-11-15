import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'controller/CurrentUser.dart';

import 'components/LoginForm.dart';
import 'components/SignupForm.dart';

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
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) => const App(),
        },
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
  //TEMPORARY

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(16),
                child: SvgPicture.asset('assets/logo.svg')),
            const Text('An Ecological Social App',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.green,
                )),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return const LoginForm();
                      },
                    );
                  },
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return const SignupForm();
                      },
                    );
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
