import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mega_app_project/authentication/repository/auth_repository.dart';

class SignUpAuth extends ConsumerStatefulWidget {
  const SignUpAuth({super.key});

  @override
  ConsumerState<SignUpAuth> createState() => _AuthState();
}

class _AuthState extends ConsumerState<SignUpAuth> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Map<String, String> _authData = {
    'username': '',
    'email': '',
    'password': '',
  };

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  void createAccount() {
    ref.read(AuthRepositoryProvider).signUpwithEmailandPassword(
        context,
        _emailController.text,
        _passwordController.text,
        _usernameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 12),
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              child: const Text(
                'UserName',
                style: TextStyle(color: Colors.white70, fontSize: 18),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 13, right: 15),
              child: TextFormField(
                style: const TextStyle(color: Colors.white70, fontSize: 30),
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.white70,
                  ),
                  labelText: 'UserName',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white54,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                controller: _usernameController,
                validator: (value) {
                  if (value!.isEmpty || value.length < 5) {
                    return 'Username is too short!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['username'] = value!;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 12),
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              child: const Text(
                'Email Id',
                style: TextStyle(color: Colors.white70, fontSize: 18),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 13, right: 15, bottom: 13),
              child: TextFormField(
                style: const TextStyle(color: Colors.white70, fontSize: 20),
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.white70,
                  ),
                  labelText: 'Email Id',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white54,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                validator: (value) {
                  if (value!.isEmpty || !value.contains('@')) {
                    return 'Invalid email!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['email'] = value!;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 12),
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              child: const Text(
                'Password',
                style: TextStyle(color: Colors.white70, fontSize: 18),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 13, right: 15),
              child: TextFormField(
                style: const TextStyle(color: Colors.white70, fontSize: 30),
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.white70,
                  ),
                  suffixIcon: Icon(
                    Icons.remove_red_eye_sharp,
                    color: Colors.white70,
                  ),
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white54,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value!.isEmpty || value.length < 5) {
                    return 'Password is too short!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['password'] = value!;
                },
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                gradient: LinearGradient(
                  colors: [
                    const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                    const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0, 1],
                ),
              ),
              width: double.infinity,
              margin: const EdgeInsets.only(left: 13, right: 15, bottom: 13),
              child: ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  _formKey.currentState!.save();
                  createAccount();
                  // Use _authData['username'], _authData['email'], and _authData['password'] as needed
                },
                child: const Text(
                  'Create Account',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.all(15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
