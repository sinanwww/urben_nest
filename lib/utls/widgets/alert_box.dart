import 'package:flutter/material.dart';
import 'package:urben_nest/utls/app_theme.dart';
import 'package:urben_nest/utls/font_style.dart';

class AlertBox extends StatelessWidget {
  final String title;
  final String message;
  final Function() onConfirm;
  final IconData icon;
  const AlertBox({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color.fromARGB(31, 229, 44, 75),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 30, color: AppTheme.primary),
          ),
          Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          Text(
            message,
            style: Fontstyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppTheme.neutralGray,
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    foregroundColor: AppTheme.neutralGray,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: const BorderSide(width: 1, color: AppTheme.primary),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => onConfirm(),
                  child: Text(title),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
