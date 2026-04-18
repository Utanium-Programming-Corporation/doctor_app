import 'package:flutter/material.dart';

abstract final class AppFormField {
  /// Builds a standard labeled text field using the app's input theme.
  static Widget buildTextField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    TextInputAction textInputAction = TextInputAction.next,
    int? maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label),
    );
  }

  /// Builds a text field that shows a clear (✕) button when non-empty.
  static Widget buildTextFieldClearable({
    required String label,
    required TextEditingController controller,
    required VoidCallback onClear,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        return TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: value.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      controller.clear();
                      onClear();
                    },
                  )
                : null,
          ),
        );
      },
    );
  }
}
