import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String? labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool obscureText;

  const InputField({
    super.key,
    required this.labelText,
    this.controller,
    this.validator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    final isObscured = ValueNotifier<bool>(obscureText);

    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: ValueListenableBuilder<bool>(
        valueListenable: isObscured,
        builder: (context, obscured, child) {
          return TextFormField(
            controller: controller,
            validator: validator,
            obscureText: obscured,
            decoration: InputDecoration(
              suffixIcon: obscureText
                  ? IconButton(
                      icon: Icon(
                        obscured ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        isObscured.value = !isObscured.value;
                      },
                    )
                  : null,
              labelText: labelText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SerchField extends StatelessWidget {
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  const SerchField({super.key, this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        hintText: 'Search',
      ),
    );
  }
}
