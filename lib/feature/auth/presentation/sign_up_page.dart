import 'package:calendar_app/core/validators/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController conformPasswordCtrl = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Sign Up',
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
                        isVisible = isVisible ? false : true;
                      });
                    },
                    icon: !isVisible
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
              TextFormField(
                controller: conformPasswordCtrl,
                decoration: InputDecoration(
                  hintText: 'Enter Password Again',
                  labelText: 'Conform Password',
                  prefixIcon: Icon(Icons.mail_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isVisible = isVisible ? false : true;
                      });
                    },
                    icon: !isVisible
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                ),
                onPressed: () {},
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(fontSize: 17, color: Colors.black),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      context.pushReplacement('/login');
                    },
                    child: Text(
                      'Log In',
                      style: TextStyle(fontSize: 17, color: Colors.blue[900]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
