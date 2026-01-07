import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urben_nest/utls/app_theme.dart';
import 'package:urben_nest/utls/images.dart';

class AuthFrame extends StatelessWidget {
  final Widget child;
  const AuthFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Column(
              children: [
                SvgPicture.asset(Images.doodles),
                SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,

                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),

                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
