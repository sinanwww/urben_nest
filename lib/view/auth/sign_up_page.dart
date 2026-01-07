import 'package:flutter/material.dart';
import 'package:urben_nest/utls/app_theme.dart';
import 'package:urben_nest/utls/widgets/auth_frame.dart';
import 'package:urben_nest/utls/widgets/input_field.dart';
import 'package:urben_nest/utls/widgets/primery_button.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AuthFrame(
          child: Column(
            children: [
              SizedBox(height: 30),
              Text("SIGN UP", style: Theme.of(context).textTheme.headlineLarge),
              SizedBox(height: 30),
              InputField(labelText: "name"),
              InputField(labelText: "phone number"),
              InputField(labelText: "email"),
              InputField(labelText: "password"),
              SizedBox(height: 100),

              PrimeryButton(onPressed: () {}, text: "Sign Up"),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: RichText(
                  text: TextSpan(
                    text: "already have an account? ",
                    style: Theme.of(context).textTheme.bodySmall,
                    children: [
                      TextSpan(
                        text: "Login",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 50,
          left: 10,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
