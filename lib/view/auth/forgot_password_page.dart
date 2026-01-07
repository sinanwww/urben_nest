import 'package:flutter/material.dart';
import 'package:urben_nest/utls/widgets/auth_frame.dart';
import 'package:urben_nest/utls/widgets/input_field.dart';
import 'package:urben_nest/utls/widgets/primery_button.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AuthFrame(
          child: Column(
            children: [
              SizedBox(height: 30),
              Text(
                "FORGOT PASSWORD",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 30),
              InputField(labelText: "email"),
              SizedBox(height: 100),

              PrimeryButton(onPressed: () {}, text: "Send Reset Link"),
              SizedBox(height: 10),
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
