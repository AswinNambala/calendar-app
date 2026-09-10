import 'package:calendar_app/core/validators/form_validators.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: emailCtrl,
                decoration: InputDecoration(
                  hintText: 'Enter Email',
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.mail_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => FormValidators.emailValidator(value),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: passwordCtrl,
                decoration: InputDecoration(
                  hintText: 'Enter Password',
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.mail_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isVisible = true;
                      });
                    },
                    icon: isVisible
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                  ),
                  border: OutlineInputBorder(),
                ),
                obscureText: isVisible ? true : false,
                keyboardType: TextInputType.number,
                validator: (value) => FormValidators.passwordValidator(value),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(),
                ),
                onPressed: () {},
                child: Text('Login', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: TextStyle(fontSize: 17, color: Colors.black),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 17, color: Colors.blue[900]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text('O r', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  elevation: 2.0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    side: const BorderSide(color: Colors.black12),
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/logo-google-icon-png.png',
                      height: 24.0,
                      width: 24.0,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.account_circle,
                          color: Colors.red,
                          size: 24.0,
                        );
                      },
                    ),
                    const SizedBox(width: 15),
                    Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
