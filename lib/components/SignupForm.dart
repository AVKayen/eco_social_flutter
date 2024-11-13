import 'package:flutter/material.dart';
import 'package:image_input/image_input.dart';

import '/model/User.dart';
import '/controller/CurrentUser.dart';
import '/view/MainView.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final CurrentUser _currentUser = CurrentUser();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _username;
  String? _password;
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const Text('Sign up',
                style: TextStyle(
                  fontSize: 24,
                )),
            // ImageInput(
            //   images: (_image == null) ? null : [_image!],
            //   onImageSelected: (XFile image) {
            //     setState(() {
            //       _image = image;
            //     });
            //   },
            // ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
              onSaved: (String? value) {
                _username = value!;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              onSaved: (String? value) {
                _password = value!;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final formData = RegisterForm(
                    username: _username!,
                    password: _password!,
                    picture: _image,
                  );
                  final bool success = await _currentUser.register(formData);
                  if (success) {
                    await _currentUser.login(UserForm(
                      username: _username!,
                      password: _password!,
                    ));
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainView()),
                    );
                  }
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
