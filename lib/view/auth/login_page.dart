import 'package:flutter/material.dart';
import 'package:urben_nest/utls/app_theme.dart';
import 'package:urben_nest/utls/widgets/auth_frame.dart';
import 'package:urben_nest/utls/widgets/input_field.dart';
import 'package:urben_nest/utls/widgets/primery_button.dart';
import 'package:urben_nest/view/auth/forgot_password_page.dart';
import 'package:urben_nest/view/auth/sign_up_page.dart';
import 'package:urben_nest/view/dashboard/dashboard_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthFrame(
      child: Column(
        children: [
          SizedBox(height: 30),
          Text("LOGIN", style: Theme.of(context).textTheme.headlineLarge),
          SizedBox(height: 30),
          InputField(labelText: "email"),
          InputField(labelText: "password"),
          SizedBox(height: 100),

          PrimeryButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DashboardPage()),
              );
            },
            text: "Login",
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
              );
            },
            child: Text(
              "Forget Password?",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpPage()),
              );
            },
            child: RichText(
              text: TextSpan(
                text: "never here?",
                style: Theme.of(context).textTheme.bodySmall,
                children: [
                  TextSpan(
                    text: " create an account",
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppTheme.infoBlue),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
