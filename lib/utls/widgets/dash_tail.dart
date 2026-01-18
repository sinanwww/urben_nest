import 'package:flutter/material.dart';
import 'package:urben_nest/utls/app_theme.dart';

class DashTail extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? role; // Optional role: 'admin' or 'member'

  const DashTail({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),

                // Role badge
                if (role != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          (role?.toLowerCase() == 'creator' ||
                              role?.toLowerCase() == 'admin')
                          ? AppTheme.primary.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            (role?.toLowerCase() == 'creator' ||
                                role?.toLowerCase() == 'admin')
                            ? AppTheme.primary
                            : Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      role!.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color:
                            (role?.toLowerCase() == 'creator' ||
                                role?.toLowerCase() == 'admin')
                            ? AppTheme.primary
                            : Colors.grey[700],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],

                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        Divider(thickness: 1, color: AppTheme.neutralGray),
      ],
    );
  }
}
