import 'package:flutter/material.dart';
import 'package:urben_nest/utls/app_theme.dart';
import 'package:urben_nest/utls/widgets/auth_frame.dart';
import 'package:urben_nest/utls/widgets/input_field.dart';
import 'package:urben_nest/utls/widgets/primery_button.dart';
import 'package:urben_nest/view/auth/forgot_password_page.dart';
import 'package:urben_nest/view/auth/sign_up_page.dart';

import 'package:provider/provider.dart';
import 'package:urben_nest/view/dashboard/dashboard_page.dart';
import 'package:urben_nest/view_model/auth_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(AuthViewModel authViewModel) async {
    if (_formKey.currentState!.validate()) {
      final success = await authViewModel.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authViewModel.errorMessage ?? 'Login failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return AuthFrame(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 30),
            Text("LOGIN", style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 30),
            InputField(
              labelText: "email",
              controller: _emailController,
              validator: (value) => value!.isEmpty || !value.contains('@')
                  ? "Enter a valid email"
                  : null,
            ),
            InputField(
              labelText: "password",
              controller: _passwordController,
              obscureText: true,
              validator: (value) => value!.length < 6
                  ? "Password must be at least 6 chars"
                  : null,
            ),
            const SizedBox(height: 100),

            authViewModel.isLoading
                ? const CircularProgressIndicator(color: AppTheme.primary)
                : PrimeryButton(
                    onPressed: () => _handleLogin(authViewModel),
                    text: "Login",
                  ),
            const SizedBox(height: 10),
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
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
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
      ),
    );
  }
}
