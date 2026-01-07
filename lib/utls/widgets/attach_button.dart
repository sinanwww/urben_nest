import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:urben_nest/utls/app_theme.dart';

class AttachButton extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onTap;
  const AttachButton({
    super.key,
    required this.imagePath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16),
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.neutralGray,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imagePath,
                height: 50,
                width: 50,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: 10),
              Text(label, style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
        ),
      ),
    );
  }
}
