import 'package:flutter/material.dart';
import 'package:urben_nest/utls/app_theme.dart';

class CustomFilterRow extends StatelessWidget {
  final List<String> items;
  final ValueNotifier<String> selectedItem;

  const CustomFilterRow({
    super.key,
    required this.items,
    required this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: items
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: ValueListenableBuilder<String>(
                valueListenable: selectedItem,
                builder: (context, value, child) {
                  return InkWell(
                    onTap: () {
                      selectedItem.value = e;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: value == e ? AppTheme.primary : Colors.grey[300],
                      ),
                      child: Text(
                        e,
                        style: TextStyle(
                          color: value == e ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
          .toList(),
    );
  }
}
