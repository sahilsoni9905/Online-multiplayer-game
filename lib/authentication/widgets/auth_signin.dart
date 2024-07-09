import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mega_app_project/authentication/repository/auth_repository.dart';
import 'package:mega_app_project/authentication/screens/signin_screen.dart'; // Adjusted import based on your needs

class Auth extends ConsumerStatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends ConsumerState<Auth> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Fixed type parameter for GlobalKey<FormState>
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController
        .dispose(); // Dispose of the controller to avoid memory leaks
    super.dispose();
  }

  void _signIn() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    ref.read(AuthRepositoryProvider).signIn(context,
        _authData['email'].toString(), _authData['password'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildUsernameField(),
            _buildPasswordField(),
            _buildForgotPasswordButton(),
            _buildSignInButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return Container(
      margin: EdgeInsets.only(left: 12, right: 15, bottom: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Username',
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
          TextFormField(
            style: TextStyle(color: Colors.white70, fontSize: 20),
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.white70),
              prefixIcon: Icon(Icons.account_circle, color: Colors.white70),
              labelText: 'Username',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
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
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      margin: EdgeInsets.only(left: 12, right: 15, bottom: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Password',
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
          TextFormField(
            style: const  TextStyle(color: Colors.white70, fontSize: 20),
            decoration: const  InputDecoration(
              labelStyle: TextStyle(color: Colors.white70),
              prefixIcon: Icon(Icons.key, color: Colors.white70),
              suffixIcon:
                  Icon(Icons.remove_red_eye_sharp, color: Colors.white70),
              labelText: 'Password',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
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
        ],
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(right: 15, bottom: 30),
      alignment: Alignment.bottomRight,
      child: TextButton(
        onPressed: () {
          // Handle forgot password action
        },
        child: Text(
          'Forgot password?',
          style: TextStyle(color: Colors.white54),
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
            Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0, 1],
        ),
      ),
      width: double.infinity,
      margin: EdgeInsets.only(left: 13, right: 15, bottom: 13),
      child: ElevatedButton(
        onPressed: _signIn, // Fixed to call _signIn method
        child: Text(
          'Sign in',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 3,
        ),
      ),
    );
  }
}
