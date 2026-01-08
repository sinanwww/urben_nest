import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urben_nest/utls/app_theme.dart';
import 'package:urben_nest/utls/widgets/auth_frame.dart';
import 'package:urben_nest/utls/widgets/input_field.dart';
import 'package:urben_nest/utls/widgets/primery_button.dart';
import 'package:urben_nest/view/dashboard/dashboard_page.dart';

import 'package:urben_nest/view_model/auth_view_model.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp(AuthViewModel authViewModel) async {
    if (_formKey.currentState!.validate()) {
      final success = await authViewModel.signUp(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (success) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authViewModel.errorMessage ?? 'Sign up failed'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Stack(
      children: [
        AuthFrame(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Text(
                    "SIGN UP",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 30),
                  InputField(
                    labelText: "name",
                    controller: _nameController,
                    validator: (value) =>
                        value!.isEmpty ? "Name is required" : null,
                  ),
                  InputField(
                    labelText: "phone number",
                    controller: _phoneController,
                    validator: (value) =>
                        value!.isEmpty ? "Phone is required" : null,
                  ),
                  InputField(
                    labelText: "email",
                    controller: _emailController,
                    validator: (value) => value!.isEmpty || !value.contains('@')
                        ? "enter valid email"
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
                          onPressed: () => _handleSignUp(authViewModel),
                          text: "Sign Up",
                        ),
                  const SizedBox(height: 10),
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
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppTheme.primary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 50,
          left: 10,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
